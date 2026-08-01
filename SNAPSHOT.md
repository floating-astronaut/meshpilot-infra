# Server Snapshot — aws-meshpilot (3.22.91.135)

**Auto-generated — do not edit.** Regenerated daily by `snapshot.sh` (committed by `sync.sh`).
Hand-maintained notes live in [README.md](README.md).

**Generated:** 2026-08-01 03:47:01 UTC
**Uptime:** up 7 weeks, 3 days, 17 hours, 24 minutes
**Load avg:** 1.05, 0.68, 0.77

## Running services (ours)

```
  cod-confirm.service                            loaded active running Mesh Pilot COD Confirm — voice AI COD confirmation service
  glitch-ads-bot.service                         loaded active running Mesh Pilot Ads Agent — webhook receiver + Telegram bot
  glitch-brain-mcp.service                       loaded active running Glitch Brain MCP — central memory for Glitch Grow AI agents (streamable-HTTP on :3107)
  glitch-signal.service                          loaded active running Glitch Signal — monorepo social media agent
  grow-dashboard.service                         loaded active running Mesh Pilot Dashboard (FastAPI) — unified Meta ads view
  mesh-pilot-litellm-proxy.service               loaded active running Mesh Pilot - OpenAI-compatible Bedrock shim (port 4000) for the Retell voice bridge
  mesh-pilot-mcp.service                         loaded active running Mesh Pilot public MCP server (free-tier funnel) — MCP-FUNNEL-4
  mesh-pilot-shopify-embed.service               loaded active running Mesh Pilot — embedded Shopify app (Remix) self-hosted container
  retell-vercel-bridge.service                   loaded active running Retell ↔ Vercel AI Gateway WebSocket bridge
  shopify-app.service                            loaded active running Multi-Store Theme Manager (Shopify App)
```

## Inactive / stopped (ours)

```
cloudflared.service  [inactive]
cod-confirm-relay.service  [inactive]
exotic-420-budz-medusa.service  [inactive]
exotic-420-budz.service  [inactive]
glitch-amazon-sp-sqp-sync.service  [inactive]
hydrogen-demo.service  [inactive]
mesh-pilot-crm-discovery.service  [failed]
mesh-pilot-crm-sheet-sync.service  [inactive]
mesh-pilot-influencer-discovery.service  [inactive]
mesh-pilot-influencer-engage.service  [inactive]
mesh-pilot-influencer-worker.service  [inactive]
mesh-pilot-web-next.service  [inactive]
```

## Failed services

```
● certbot.service                  loaded failed failed Certbot
● mesh-pilot-crm-discovery.service loaded failed failed Mesh Pilot — CRM lead pipeline (Places discovery + website enrichment + social search) for Glitch Budz
● mp-reclaim-static-videos.service loaded failed failed One-shot: reclaim static/social/videos after R2 cutover drain (T5c)
```

## Docker containers

```
NAMES                      IMAGE                             STATUS                  PORTS
mesh-pilot-shopify-embed   mesh-pilot-shopify-embed:latest   Up Less than a second   127.0.0.1:3120->3000/tcp
```

## Listening ports

```
0.0.0.0:22                   proc=sshd
0.0.0.0:25                   proc=master
0.0.0.0:443                  proc=nginx
0.0.0.0:80                   proc=nginx
127.0.0.1:16459              proc=code-1b6a188127
127.0.0.1:19999              proc=netdata
127.0.0.1:3009               (v1
127.0.0.1:3101               proc=node
127.0.0.1:3104               proc=node
127.0.0.1:3107               proc=glitch-brain-mc
127.0.0.1:3108               proc=python
127.0.0.1:3110               proc=uvicorn
127.0.0.1:3111               proc=uvicorn
127.0.0.1:3113               proc=python
127.0.0.1:3114               proc=python
127.0.0.1:3120               proc=docker-proxy
127.0.0.1:4000               proc=python
127.0.0.1:4317               proc=otel-plugin
127.0.0.1:5432               proc=postgres
127.0.0.1:8125               proc=netdata
127.0.0.1:8910               proc=node
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
    Expiry Date: 2026-09-01 02:56:00+00:00 (VALID: 30 days)
  Certificate Name: auth.meshpilot.app
    Domains: auth.meshpilot.app
    Expiry Date: 2026-10-16 08:54:20+00:00 (VALID: 76 days)
  Certificate Name: hydrogen.nuraveda.com
    Domains: hydrogen.nuraveda.com
    Expiry Date: 2026-08-26 00:32:07+00:00 (VALID: 24 days)
  Certificate Name: meshpilot.app-0001
    Domains: *.meshpilot.app
    Expiry Date: 2026-09-06 01:10:44+00:00 (VALID: 35 days)
  Certificate Name: meshpilot.app
    Domains: meshpilot.app www.meshpilot.app
    Expiry Date: 2026-08-24 17:15:42+00:00 (VALID: 23 days)
```

## Postgres databases

```
glitch_brain  (226 MB)
glitch_social_media_agent  (8454 kB)
meshpilot_shopify_embed  (8358 kB)
meshpilot_v2_dev  (8190 kB)
postgres  (7678 kB)
shopify_app  (308 MB)
```

## Disk

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        77G   45G   32G  59% /
```

## Memory

```
               total        used        free      shared  buff/cache   available
Mem:            15Gi       5.9Gi       5.1Gi       1.4Gi       6.1Gi       9.5Gi
Swap:          4.0Gi       3.9Gi       145Mi
```

## Project directories

```
/home/ubuntu/.aws                              (not a git repo)
/home/ubuntu/.cache                            (not a git repo)
/home/ubuntu/.camoufox                         (not a git repo)
/home/ubuntu/.claude                           (not a git repo)
/home/ubuntu/.cloudflare                       (not a git repo)
/home/ubuntu/.codegraph                        (not a git repo)
/home/ubuntu/.codex                            (not a git repo)
/home/ubuntu/.config                           (not a git repo)
/home/ubuntu/.copilot                          (not a git repo)
/home/ubuntu/.cursor                           (not a git repo)
/home/ubuntu/.cursor-server                    (not a git repo)
/home/ubuntu/.docker                           (not a git repo)
/home/ubuntu/.dotnet                           (not a git repo)
/home/ubuntu/.gnupg                            (not a git repo)
/home/ubuntu/.heygen                           (not a git repo)
/home/ubuntu/.kimi                             (not a git repo)
/home/ubuntu/.kimi-code                        (not a git repo)
/home/ubuntu/.lazyweb                          (not a git repo)
/home/ubuntu/.local                            (not a git repo)
/home/ubuntu/.muapi                            (not a git repo)
/home/ubuntu/.npm                              (not a git repo)
/home/ubuntu/.scrape-venv                      (not a git repo)
/home/ubuntu/.ssh                              (not a git repo)
/home/ubuntu/.vscode-server                    (not a git repo)
/home/ubuntu/.wrangler                         (not a git repo)
/home/ubuntu/Generative-Media-Skills           git: git@github.com:SamurAIGPT/Generative-Media-Skills.git
/home/ubuntu/ad-batch-square                   (not a git repo)
/home/ubuntu/ad-batch-story                    (not a git repo)
/home/ubuntu/ad-batch-v2                       (not a git repo)
/home/ubuntu/admin                             (not a git repo)
/home/ubuntu/backups                           (not a git repo)
/home/ubuntu/glitch-brain-mcp                  git: git@github.com:floating-astronaut/glitch-brain-mcp.git
/home/ubuntu/glitch-grow-ads-agent-private     git: git@github.com:Nuraveda-Labs/meshpilot-digital-marketing-stack.git
/home/ubuntu/google-cloud-sdk                  (not a git repo)
/home/ubuntu/hero-banners                      (not a git repo)
/home/ubuntu/heygen-skills                     git: git@github.com:heygen-com/skills
/home/ubuntu/india-persona                     (not a git repo)
/home/ubuntu/jordan-hale-locked-set            (not a git repo)
/home/ubuntu/logs                              (not a git repo)
/home/ubuntu/meshpilot-infra                   git: git@github.com:Nuraveda-Labs/meshpilot-infra.git
/home/ubuntu/monad-gate-explainer              (not a git repo)
/home/ubuntu/mp-frontend                       (not a git repo)
/home/ubuntu/multi-store-theme-manager         git: git@github.com:floating-astronaut/multi-store-theme-manager.git
/home/ubuntu/nltk_data                         (not a git repo)
/home/ubuntu/p1-new-content                    (not a git repo)
/home/ubuntu/p1-stage                          (not a git repo)
/home/ubuntu/persona-india-candidates          (not a git repo)
/home/ubuntu/preview-shots                     (not a git repo)
/home/ubuntu/venvs                             (not a git repo)
/home/ubuntu/worktrees                         (not a git repo)


```

## Crontab (ubuntu)

```
*/30 * * * * /home/ubuntu/glitch-grow-ads-agent-private/scripts/urban_watch.sh >> /home/ubuntu/.local/state/glitch-ads-bot/logs/urban-watch.log 2>&1
30 6 * * 0 /home/ubuntu/glitch-grow-ads-agent-private/scripts/reap-test-residue.sh >> /home/ubuntu/.local/state/glitch-grow/test-reaper.log 2>&1
# DISABLED 2026-07-23 (vobiz 402 insufficient balance) 35 4 * * * cd /home/ubuntu/glitch-grow-ads-agent-private/apps/cod_confirm && set -a && . /home/ubuntu/glitch-grow-ads-agent-private/.env && set +a && node scripts/sync-vobiz-recordings.mjs --days 2 >> /tmp/vobiz-sync.log 2>&1
35 5 * * * cd /home/ubuntu/glitch-grow-ads-agent-private && .venv/bin/python scripts/sync_twilio_recordings.py --days 2 >> /tmp/twilio-sync.log 2>&1
*/2 * * * * /home/ubuntu/meshpilot-watch.sh
15 */2 * * * cd /home/ubuntu/glitch-grow-ads-agent-private && .venv/bin/dotenv -f .env.grow-dashboard run -- .venv/bin/dotenv -f .env run -- .venv/bin/python scripts/plan_aware_watch.py >> /home/ubuntu/.local/state/glitch-ads-bot/logs/plan-aware-watch.log 2>&1
# Mirror sync (2026-06-10): replaces old-box glitch-infra/sync.sh. Ads intraday, full nightly.
0 */6 * * * /home/ubuntu/glitch-grow-ads-agent-private/scripts/sync_mirrors.sh ads >> /home/ubuntu/.local/state/glitch-ads-bot/logs/sync-mirrors.log 2>&1
30 3 * * * /home/ubuntu/glitch-grow-ads-agent-private/scripts/sync_mirrors.sh full >> /home/ubuntu/.local/state/glitch-ads-bot/logs/sync-mirrors.log 2>&1
0 3 * * * /home/ubuntu/backups/backup-postgres.sh
47 3 * * * cd /home/ubuntu/meshpilot-infra && bash sync.sh >> /home/ubuntu/meshpilot-infra/sync.log 2>&1
*/2 * * * * /home/ubuntu/ge-trade-watch.sh >> /home/ubuntu/.ge-trade-watch.cron.log 2>&1
17 * * * * curl -s -X POST -H "X-Drip-Secret: $(cat /home/ubuntu/.buildaiempire_drip_secret)" https://buildaiempire.com/api/drip >> /home/ubuntu/logs/buildaiempire-drip.log 2>&1 # buildaiempire_drip
0 4 * * 0 cd /home/ubuntu/glitch-grow-ads-agent-private && /usr/bin/python3 scripts/refresh_meta_token.py >> /home/ubuntu/.local/state/glitch-ads-bot/logs/meta-token-refresh.log 2>&1
```
