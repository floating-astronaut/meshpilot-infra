# Server Snapshot — aws-meshpilot (3.22.91.135)

**Auto-generated — do not edit.** Regenerated daily by `snapshot.sh` (committed by `sync.sh`).
Hand-maintained notes live in [README.md](README.md).

**Generated:** 2026-06-18 03:47:01 UTC
**Uptime:** up 1 week, 1 day, 17 hours, 24 minutes
**Load avg:** 0.09, 0.10, 0.42

## Running services (ours)

```
  cloudflared.service                            loaded active running Cloudflare Tunnel connector
  cod-confirm-relay.service                      loaded active running COD Confirm — Twilio ConversationRelay backend (international concierge LLM brain)
  cod-confirm.service                            loaded active running Mesh Pilot COD Confirm — voice AI COD confirmation service
  exotic-420-budz-medusa.service                 loaded active running Exotic 420 Budz Medusa backend
  exotic-420-budz.service                        loaded active running Exotic 420 Budz Next.js app
  glitch-ads-bot.service                         loaded active running Mesh Pilot Ads Agent — webhook receiver + Telegram bot
  glitch-brain-mcp.service                       loaded active running Glitch Brain MCP — central memory for Glitch Grow AI agents (streamable-HTTP on :3107)
  glitch-signal.service                          loaded active running Glitch Signal — monorepo social media agent
  grow-dashboard.service                         loaded active running Mesh Pilot Dashboard (FastAPI) — unified Meta ads view
  hydrogen-demo.service                          loaded active running Hydrogen D2C Starter — public demo at hydrogen.nuraveda.com
  mesh-pilot-mcp.service                         loaded active running Mesh Pilot public MCP server (free-tier funnel) — MCP-FUNNEL-4
  mesh-pilot-shopify-embed.service               loaded active running Mesh Pilot — embedded Shopify app (Remix) self-hosted container
  mesh-pilot-web-next.service                    loaded active running Mesh Pilot frontend — apps/web-next (Next.js 16) behind nginx
  retell-vercel-bridge.service                   loaded active running Retell ↔ Vercel AI Gateway WebSocket bridge
  shopify-app.service                            loaded active running Multi-Store Theme Manager (Shopify App)
```

## Inactive / stopped (ours)

```
glitch-amazon-sp-sqp-sync.service  [inactive]
mesh-pilot-docs-autosync.service  [failed]
mesh-pilot-influencer-discovery.service  [inactive]
mesh-pilot-influencer-engage.service  [inactive]
mesh-pilot-influencer-worker.service  [inactive]
```

## Failed services

```
● mesh-pilot-docs-autosync.service loaded failed failed Mesh Pilot — keep docs/ aligned with commit history (daily catch-up)
```

## Docker containers

```
NAMES                      IMAGE                             STATUS      PORTS
mesh-pilot-web-next        mesh-pilot-web-next:latest        Up 5 days   127.0.0.1:3001->3000/tcp
mesh-pilot-shopify-embed   mesh-pilot-shopify-embed:latest   Up 8 days   127.0.0.1:3120->3000/tcp
```

## Listening ports

```
*:3130                       proc=node
0.0.0.0:22                   proc=sshd
0.0.0.0:25                   proc=master
0.0.0.0:443                  proc=nginx
0.0.0.0:80                   proc=nginx
127.0.0.1:19999              proc=netdata
127.0.0.1:20241              proc=cloudflared
127.0.0.1:3001               proc=docker-proxy
127.0.0.1:3002               (v1
127.0.0.1:3030               proc=workerd
127.0.0.1:3101               proc=node
127.0.0.1:3104               proc=node
127.0.0.1:3105               proc=node
127.0.0.1:3107               proc=glitch-brain-mc
127.0.0.1:3108               proc=python
127.0.0.1:3110               proc=uvicorn
127.0.0.1:3111               proc=uvicorn
127.0.0.1:3113               proc=python
127.0.0.1:3120               proc=docker-proxy
127.0.0.1:33667              proc=workerd
127.0.0.1:41887              proc=node
127.0.0.1:4317               proc=otel-plugin
127.0.0.1:5432               proc=postgres
127.0.0.1:8080               proc=nginx
127.0.0.1:8125               proc=netdata
127.0.0.1:8910               proc=node
127.0.0.1:9000               proc=node
127.0.0.53%lo:53             proc=systemd-resolve
127.0.0.54:53                proc=systemd-resolve
172.17.0.1:5432              proc=postgres
[::]:22                      proc=sshd
[::]:25                      proc=master
[::]:443                     proc=nginx
[::]:80                      proc=nginx
```

## Nginx sites enabled

```
api.meshpilot.app
apps.meshpilot.app
auth.meshpilot.app
brain.meshpilot.app
default-deny
exotic420budz.com
hydrogen.nuraveda.com
insights.meshpilot.app
mcp.meshpilot.app
media.meshpilot.app
meshpilot.app
shopify.meshpilot.app
signal.meshpilot.app
```

## TLS certificates

```
  Certificate Name: apps.meshpilot.app
    Domains: apps.meshpilot.app
    Expiry Date: 2026-09-01 02:56:00+00:00 (VALID: 74 days)
  Certificate Name: auth.meshpilot.app
    Domains: auth.meshpilot.app
    Expiry Date: 2026-08-17 04:34:33+00:00 (VALID: 60 days)
  Certificate Name: hydrogen.nuraveda.com
    Domains: hydrogen.nuraveda.com
    Expiry Date: 2026-08-26 00:32:07+00:00 (VALID: 68 days)
  Certificate Name: meshpilot.app-0001
    Domains: *.meshpilot.app
    Expiry Date: 2026-09-06 01:10:44+00:00 (VALID: 79 days)
  Certificate Name: meshpilot.app
    Domains: meshpilot.app www.meshpilot.app
    Expiry Date: 2026-08-24 17:15:42+00:00 (VALID: 67 days)
```

## Postgres databases

```
exotic420budz_medusa  (18 MB)
glitch_brain  (128 MB)
glitch_social_media_agent  (8454 kB)
meshpilot_shopify_embed  (8358 kB)
postgres  (7678 kB)
shopify_app  (155 MB)
```

## Disk

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        48G   38G  9.7G  80% /
```

## Memory

```
               total        used        free      shared  buff/cache   available
Mem:            15Gi       6.7Gi       4.8Gi       1.1Gi       5.3Gi       8.7Gi
Swap:          4.0Gi       2.0Gi       2.0Gi
```

## Project directories

```
/home/ubuntu/.cache                            (not a git repo)
/home/ubuntu/.claude                           (not a git repo)
/home/ubuntu/.config                           (not a git repo)
/home/ubuntu/.docker                           (not a git repo)
/home/ubuntu/.kimi                             (not a git repo)
/home/ubuntu/.kimi-code                        (not a git repo)
/home/ubuntu/.lazyweb                          (not a git repo)
/home/ubuntu/.local                            (not a git repo)
/home/ubuntu/.npm                              (not a git repo)
/home/ubuntu/.ssh                              (not a git repo)
/home/ubuntu/admin                             (not a git repo)
/home/ubuntu/backups                           (not a git repo)
/home/ubuntu/glitch-brain-mcp                  git: git@github.com:floating-astronaut/glitch-brain-mcp.git
/home/ubuntu/glitch-grow-ads-agent-private     git: git@github.com:Nuraveda-Labs/meshpilot-digital-marketing-stack.git
/home/ubuntu/hydrogen-d2c-starter              git: (no remote)
/home/ubuntu/meshpilot-infra                   git: git@github.com:Nuraveda-Labs/meshpilot-infra.git
/home/ubuntu/multi-store-theme-manager         git: git@github.com:floating-astronaut/multi-store-theme-manager.git
/srv/apps/cannabis-web-next                    git: git@github.com:glitch-exec-labs/glitch-budz.git

```

## Crontab (ubuntu)

```
*/30 * * * * /home/ubuntu/glitch-grow-ads-agent-private/scripts/urban_watch.sh >> /home/ubuntu/.local/state/glitch-ads-bot/logs/urban-watch.log 2>&1
30 6 * * 0 /home/ubuntu/glitch-grow-ads-agent-private/scripts/reap-test-residue.sh >> /home/ubuntu/.local/state/glitch-grow/test-reaper.log 2>&1
35 4 * * * cd /home/ubuntu/glitch-grow-ads-agent-private/apps/cod_confirm && set -a && . /home/ubuntu/glitch-grow-ads-agent-private/.env && set +a && node scripts/sync-vobiz-recordings.mjs --days 2 >> /tmp/vobiz-sync.log 2>&1
35 5 * * * cd /home/ubuntu/glitch-grow-ads-agent-private && .venv/bin/python scripts/sync_twilio_recordings.py --days 2 >> /tmp/twilio-sync.log 2>&1
*/2 * * * * /home/ubuntu/meshpilot-watch.sh
15 */2 * * * cd /home/ubuntu/glitch-grow-ads-agent-private && .venv/bin/dotenv -f .env.grow-dashboard run -- .venv/bin/dotenv -f .env run -- .venv/bin/python scripts/plan_aware_watch.py >> /home/ubuntu/.local/state/glitch-ads-bot/logs/plan-aware-watch.log 2>&1
# Mirror sync (2026-06-10): replaces old-box glitch-infra/sync.sh. Ads intraday, full nightly.
0 */6 * * * /home/ubuntu/glitch-grow-ads-agent-private/scripts/sync_mirrors.sh ads >> /home/ubuntu/.local/state/glitch-ads-bot/logs/sync-mirrors.log 2>&1
30 3 * * * /home/ubuntu/glitch-grow-ads-agent-private/scripts/sync_mirrors.sh full >> /home/ubuntu/.local/state/glitch-ads-bot/logs/sync-mirrors.log 2>&1
0 3 * * * /home/ubuntu/backups/backup-postgres.sh
47 3 * * * cd /home/ubuntu/meshpilot-infra && bash sync.sh >> /home/ubuntu/meshpilot-infra/sync.log 2>&1
```
