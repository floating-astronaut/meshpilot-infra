#!/usr/bin/env bash
# Regenerates SNAPSHOT.md + mirrors key configs into this repo.
# Run manually: ./snapshot.sh   |   Runs daily via cron (see sync.sh).
# Does NOT touch README.md — that's the hand-maintained doc.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$SCRIPT_DIR/SNAPSHOT.md"
TS="$(date -u +'%Y-%m-%d %H:%M:%S UTC')"

# Box-specific: unit/file name pattern for "our" services
SVC_PATTERN="mesh-pilot|glitch|grow-dashboard|cod-confirm|retell|shopify-app|hydrogen|exotic|cloudflared"
DIR_BASES=(/home/ubuntu /srv/apps)

# ---------- collect ----------
RUNNING=$(systemctl list-units --type=service --state=running --no-pager --no-legend 2>/dev/null \
  | grep -E "$SVC_PATTERN" || true)

FAILED=$(systemctl --failed --no-pager --no-legend 2>/dev/null || true)

INACTIVE=$(systemctl list-unit-files --type=service --no-pager --no-legend 2>/dev/null \
  | awk '{print $1}' | grep -E "$SVC_PATTERN" \
  | while read -r svc; do
      state=$(systemctl is-active "$svc" 2>/dev/null || true)
      [[ "$state" != "active" ]] && echo "$svc  [$state]"
    done || true)

PORTS=$(sudo ss -tlnpH 2>/dev/null \
  | sed -E 's/users:\(\("([^"]+)",pid=[0-9]+[^)]*\).*/proc=\1/' \
  | awk '{printf "%-28s %s\n", $4, $NF}' | sort -u || true)

DOCKER=$(docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' 2>/dev/null || echo "(docker unavailable)")

NGINX_SITES=$(ls /etc/nginx/sites-enabled/ 2>/dev/null || true)

CERTS=$(sudo certbot certificates 2>/dev/null | grep -E "Certificate Name|Domains|Expiry" || echo "(certbot unavailable)")

PG_DBS=$(sudo -u postgres psql -tAc "SELECT datname || '  (' || pg_size_pretty(pg_database_size(datname)) || ')' FROM pg_database WHERE NOT datistemplate ORDER BY 1" 2>/dev/null || echo "(postgres unavailable)")

DISK=$(df -h / /srv 2>/dev/null | awk '!seen[$0]++' || true)
MEM=$(free -h 2>/dev/null | head -3 || true)
UPTIME=$(uptime -p 2>/dev/null || true)
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs || true)

dir_inventory() {
  local base="$1"
  [[ -d "$base" ]] || return 0
  find "$base" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | while read -r d; do
    local name remote
    name=$(basename "$d")
    if [[ -d "$d/.git" ]]; then
      remote=$(git -C "$d" remote get-url origin 2>/dev/null || echo "(no remote)")
      printf "%-45s  git: %s\n" "$base/$name" "$remote"
    else
      printf "%-45s  (not a git repo)\n" "$base/$name"
    fi
  done
}
DIRS=""
for b in "${DIR_BASES[@]}"; do DIRS+="$(dir_inventory "$b")"$'\n'; done

CRONTAB=$(crontab -l 2>/dev/null || echo "(empty)")

# ---------- mirror configs into repo ----------
# nginx vhosts (proxy config only — no secrets expected)
mkdir -p "$SCRIPT_DIR/nginx" "$SCRIPT_DIR/systemd" "$SCRIPT_DIR/cron"
rm -f "$SCRIPT_DIR/nginx/"* "$SCRIPT_DIR/systemd/"* 2>/dev/null || true
for f in /etc/nginx/sites-available/*; do
  [[ -f "$f" ]] && cp "$f" "$SCRIPT_DIR/nginx/$(basename "$f")"
done

# custom systemd units, with secret-looking Environment= values redacted
systemctl list-unit-files --type=service --no-pager --no-legend 2>/dev/null \
  | awk '{print $1}' | grep -E "$SVC_PATTERN" \
  | while read -r svc; do
      src=$(systemctl show -p FragmentPath --value "$svc" 2>/dev/null)
      [[ -f "$src" ]] || continue
      sed -E 's/^(\s*Environment="?[A-Za-z0-9_]*(KEY|TOKEN|SECRET|PASS|PWD|DSN|CRED|AUTH|PRIVATE)[A-Za-z0-9_]*=).*/\1[REDACTED]/I' \
        "$src" > "$SCRIPT_DIR/systemd/$svc"
    done

# cloudflared tunnel config (no credentials json — config.yml only)
if [[ -f /etc/cloudflared/config.yml ]]; then
  cp /etc/cloudflared/config.yml "$SCRIPT_DIR/cloudflared-config.yml"
fi

# crontab dump
echo "$CRONTAB" > "$SCRIPT_DIR/cron/ubuntu.crontab"

# ---------- write snapshot ----------
cat > "$OUT" <<EOF
# Server Snapshot — aws-meshpilot (3.22.91.135)

**Auto-generated — do not edit.** Regenerated daily by \`snapshot.sh\` (committed by \`sync.sh\`).
Hand-maintained notes live in [README.md](README.md).

**Generated:** $TS
**Uptime:** $UPTIME
**Load avg:** $LOAD

## Running services (ours)

\`\`\`
$RUNNING
\`\`\`

## Inactive / stopped (ours)

\`\`\`
${INACTIVE:-(none)}
\`\`\`

## Failed services

\`\`\`
${FAILED:-(none)}
\`\`\`

## Docker containers

\`\`\`
$DOCKER
\`\`\`

## Listening ports

\`\`\`
$PORTS
\`\`\`

## Nginx sites enabled

\`\`\`
$NGINX_SITES
\`\`\`

## TLS certificates

\`\`\`
$CERTS
\`\`\`

## Postgres databases

\`\`\`
$PG_DBS
\`\`\`

## Disk

\`\`\`
$DISK
\`\`\`

## Memory

\`\`\`
$MEM
\`\`\`

## Project directories

\`\`\`
$DIRS
\`\`\`

## Crontab (ubuntu)

\`\`\`
$CRONTAB
\`\`\`
EOF

echo "Wrote $OUT"
