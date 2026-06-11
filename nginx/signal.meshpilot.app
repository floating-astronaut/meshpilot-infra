# signal.meshpilot.app — Mesh Pilot social agent (FastAPI on :3111).
#
# Replaces signal.glitchexecutor.com as the canonical social-agent endpoint.
# Handles:
#   - TikTok OAuth start/callback
#   - Upload-Post inbound webhooks (/webhooks/upload_post/<secret>)
#   - Signed media fetch (/media/fetch)
#   - Background job dispatch (/jobs/*)

server {
    listen 80;
    listen [::]:80;
    server_name signal.meshpilot.app;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    http2 on;
    listen [::]:443 ssl;
    server_name signal.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/meshpilot.app-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app-0001/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Webhook bodies must arrive intact for HMAC verification
    client_max_body_size 20m;

    location / {
        proxy_pass         http://127.0.0.1:3111;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_read_timeout 60s;

        # SSE support for long-polling endpoints
        proxy_buffering off;
    }
}
