# api.meshpilot.app — Mesh Pilot dashboard backend (FastAPI on :3113).
#
# Replaces ads.glitchexecutor.com as the canonical public API host.
# All /v1/* routes, OAuth callbacks, and webhook endpoints live here.

server {
    listen 80;
    listen [::]:80;
    server_name api.meshpilot.app;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    http2 on;
    listen [::]:443 ssl;
    server_name api.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/meshpilot.app-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app-0001/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Retell Custom-LLM WebSocket bridge.
    # Path: wss://api.meshpilot.app/llm-websocket/<call_id>
    # Server: 127.0.0.1:8910 (retell-vercel-bridge.service)
    location /llm-websocket/ {
        proxy_pass                     http://127.0.0.1:8910;
        proxy_http_version             1.1;
        proxy_set_header   Upgrade     $http_upgrade;
        proxy_set_header   Connection  "upgrade";
        proxy_set_header   Host        $host;
        proxy_set_header   X-Real-IP   $remote_addr;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }

    # Bridge health probe (HTTP)
    location = /retell-bridge-health {
        proxy_pass         http://127.0.0.1:8910/healthz;
        proxy_http_version 1.1;
    }

    location ~ ^/(openapi.json|docs|redoc)$ { return 404; access_log off; }
    location ~ ^/v1/auth/ { limit_req zone=auth burst=5 nodelay; proxy_pass http://127.0.0.1:3113; }
    location / {
        proxy_pass         http://127.0.0.1:3113;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_read_timeout 30s;
    }
}
