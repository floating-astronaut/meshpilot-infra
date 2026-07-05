# media.meshpilot.app — direct-to-origin host for signed video fetches.
#
# Gray-clouded DNS (not behind Cloudflare) so Upload-Post can pull videos
# >100 MB without hitting CF's proxy size ceiling.
#
# Scope is deliberately tiny: only /media/fetch is proxied to the SMA
# service. Every other path is closed with 444.

# Note: limit_req_zone is defined in media.glitchexecutor.com;
# reuse the same zone name until the old vhost is retired.

server {
    listen 80;
    listen [::]:80;
    server_name media.meshpilot.app;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name media.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/meshpilot.app-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app-0001/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Large video files — keep nginx from trying to buffer them.
    client_max_body_size 500m;
    proxy_buffering off;
    proxy_request_buffering off;

    # Only /media/fetch is allowed. Upstream FastAPI verifies the signed
    # HMAC token; nginx only enforces rate + path scope.
    # Twilio ConversationRelay WS — hosted here on a NON-Cloudflare (grey)
    # hostname because Twilio's resolver cached the CF IP of the old
    # shopify.meshpilot.app relay path (2026-07-03 demo debugging). Fresh
    # hostname = fresh DNS = Twilio reaches the origin. -> relay :3105.
    # cod-pipecat: Pipecat + Vobiz voice bot for COD confirmation. Hosted on
    # this grey-clouded host so Vobiz's WebSocket client reaches the origin
    # directly (same lesson as /relay/). Prefix stripped -> service sees
    # /health, /vobiz/answer, /vobiz/ws, /start.
    location /cod-pipecat/ {
        proxy_pass http://127.0.0.1:3106/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }

    location /relay/ {
        proxy_pass http://127.0.0.1:3105;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }

    location = /media/fetch {
        # limit_req zone=media_fetch  # zone def was in deleted media.glitchexecutor.com vhost # burst=20 nodelay;

        proxy_pass http://127.0.0.1:3111;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
    }

    # Marketing reference assets (AI influencer pipeline): read-only statics
    # served as stable URLs for generation refs (MuAPI images_list) and
    # HeyGen B-roll. Files land in /var/www/meshpilot-media/. Added 2026-07-05.
    location /assets/ {
        alias /var/www/meshpilot-media/;
        autoindex off;
        add_header Cache-Control "public, max-age=86400";
    }

    # Everything else — close the connection without a response.
    location / {
        return 444;
    }
}
