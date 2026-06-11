#!/usr/bin/env bash
# Regenerates the snapshot, commits any changes, pushes to both mirrors.
# Intended for cron. Safe to run manually.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

./snapshot.sh >/dev/null

# Pick up any remote-side edits (e.g. README edited on GitHub) first
git pull --rebase origin main >/dev/null 2>&1 || true

if [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  GIT_AUTHOR_NAME="Tejas Karan Agrawal" \
  GIT_AUTHOR_EMAIL="help.nuraveda@gmail.com" \
  git commit -m "auto-sync: $(date -u +'%Y-%m-%d %H:%M UTC')"
fi

# Push even when there was nothing new to commit (covers a previously
# failed push). GitLab failure is non-fatal so GitHub still gets the sync.
git push origin main
git push gitlab main || echo "WARN: gitlab push failed at $(date -u +'%Y-%m-%dT%H:%M:%SZ')"

echo "Synced at $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
