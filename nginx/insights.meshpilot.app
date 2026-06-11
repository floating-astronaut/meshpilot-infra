# insights.meshpilot.app — Mesh Pilot ads-bot webhook receiver (FastAPI on :3110).
#
# Replaces insights.glitchexecutor.com as the canonical insights endpoint.

server {
    listen 80;
    listen [::]:80;
    server_name insights.meshpilot.app;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    http2 on;
    listen [::]:443 ssl;
    server_name insights.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/meshpilot.app-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app-0001/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Webhook bodies must arrive intact for HMAC verification
    client_max_body_size 2m;

    location / {
        proxy_pass         http://127.0.0.1:3110;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_read_timeout 60s;
    }
}
