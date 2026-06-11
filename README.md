# meshpilot-infra — Server Inventory (aws-meshpilot)

Single source of truth for what runs on this box. Hand-maintained — update
whenever you add, remove, enable, or disable something. Live machine state
is auto-captured daily in [SNAPSHOT.md](SNAPSHOT.md) (do not edit that one).

**Host:** AWS EC2 — 3.22.91.135 (`ssh aws-meshpilot`, login `ubuntu`)
**Role:** Mesh Pilot digital-marketing stack (migrated from GCP, live since the 2026-06-09 cutover)
**Last reviewed:** 2026-06-11

---

## Quick status table

| Service | Port | Dir | Purpose |
|---|---|---|---|
| nginx | 80/443 | /etc/nginx | Reverse proxy for all public sites |
| postgresql@18-main | 5432 (localhost) | — | Primary database |
| mesh-pilot-web-next | 3001 (docker) | monorepo `apps/web-next` | Mesh Pilot frontend (Next.js 16) |
| mesh-pilot-mcp | 3108 | monorepo | Public MCP server (free-tier funnel) |
| glitch-signal | 3110/3111 | monorepo | Social media agent |
| grow-dashboard | 3113 | monorepo | Unified Meta ads dashboard (FastAPI) |
| cod-confirm | 3104 | monorepo | Voice AI COD confirmation |
| cod-confirm-relay | 3105 | monorepo | Twilio ConversationRelay backend |
| mesh-pilot-shopify-embed | 3120 (docker) | monorepo | Embedded Shopify app (Remix) |
| glitch-ads-bot | — | monorepo | Ads agent webhook receiver + Telegram bot |
| retell-vercel-bridge | 8910 | monorepo | Retell ↔ Vercel AI Gateway WS bridge |
| glitch-brain-mcp | 3107 | /home/ubuntu/glitch-brain-mcp | Central agent memory (brain MCP) |
| shopify-app | 3101 | /home/ubuntu/multi-store-theme-manager | Multi-Store Theme Manager |
| hydrogen-demo | — | /home/ubuntu (hydrogen-demo) | Hydrogen storefront demo |
| exotic-420-budz-medusa | 9000 | /srv/apps/cannabis-web-next | exotic420budz Medusa backend |
| exotic-420-budz | 3002 | /srv/apps/cannabis-web-next | exotic420budz Next.js storefront |
| cloudflared | — | /etc/cloudflared | Cloudflare Tunnel (exotic420budz.com) |

Monorepo = `/home/ubuntu/glitch-grow-ads-agent-private`
(repo `meshpilot-digital-marketing-stack`; Python via `uv`, 3.14).

## Public surface

| Host | Backend |
|---|---|
| meshpilot.app (+ api/apps/auth/brain/insights/mcp/media/shopify/signal subdomains) | nginx → local services |
| hydrogen.nuraveda.com | hydrogen-demo |
| exotic420budz.com (+ www/admin) | Cloudflare Tunnel → Medusa/Next |

TLS: Let's Encrypt, DNS-01 via Cloudflare. Full vhost configs are mirrored
in [nginx/](nginx/); systemd units (secrets redacted) in [systemd/](systemd/).

## Databases (Postgres 18, localhost)

`glitch_brain`, `shopify_app`, `glitch_social_media_agent`,
`meshpilot_shopify_embed`, `exotic420budz_medusa`.
Nightly backup: `~/backups/backup-postgres.sh` (cron 03:00 UTC).

## Operational cheatsheet

```bash
systemctl list-units --type=service --state=running | grep -E "mesh-pilot|glitch|grow|cod|exotic|hydrogen|shopify"
systemctl --failed
sudo ss -tlnp
sudo nginx -t && sudo systemctl reload nginx
journalctl -u <name> -f
```

Post-cutover watch log: `/var/log/meshpilot-watch/watch.log`.

## How this repo stays current

- `snapshot.sh` regenerates SNAPSHOT.md and re-mirrors nginx/systemd/cron
  configs from the live system.
- `sync.sh` (daily cron, 03:47 UTC) runs the snapshot, commits any drift,
  and pushes to both mirrors (GitHub `Nuraveda-Labs/meshpilot-infra`,
  GitLab `nuraveda-lab/meshpilot-infra`).
- This README is the only hand-edited file: when you add/remove/change a
  service, update the tables above and bump **Last reviewed**.
