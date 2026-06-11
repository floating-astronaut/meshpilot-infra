# /etc/nginx/sites-available/mcp.meshpilot.app
#
# Public reverse proxy for the Mesh Pilot free-tier MCP server
# (mesh-pilot-mcp.service on 127.0.0.1:3108 — MCP-FUNNEL-4).
#
# The meshpilot.app zone is on Cloudflare (orange/proxied). Cloudflare
# provides the public edge TLS (Universal SSL); this origin answers CF on
# BOTH :80 and :443 so it works whether CF SSL mode is Flexible or Full.
# Streamable-HTTP needs long-lived connections + buffering off.
#
# NOTE (Cloudflare + MCP streaming): CF free-plan proxy buffers responses
# and times out long connections (~100s) and may bot-challenge API
# clients. If a remote MCP client (ChatGPT/Claude connector) misbehaves,
# set the mcp host to DNS-only (grey cloud) — the origin is otherwise
# identical.

map $http_upgrade $connection_upgrade { default upgrade; '' close; }

server {
    listen 80;
    listen [::]:80;
    server_name mcp.meshpilot.app;
    include snippets/mcp-meshpilot-proxy.conf;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name mcp.meshpilot.app;

    # CF Full mode doesn't validate the origin cert hostname; reuse the
    # existing meshpilot.app cert. (Switch to a dedicated/Origin-CA cert
    # for Full-strict later.)
    ssl_certificate     /etc/letsencrypt/live/meshpilot.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app/privkey.pem;

    include snippets/mcp-meshpilot-proxy.conf;
}
