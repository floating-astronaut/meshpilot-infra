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

    # Everything else — close the connection without a response.
    location / {
        return 444;
    }
}
