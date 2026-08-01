# Mesh Pilot frontend — production apex vhost.
#
# Origin: docker container `mesh-pilot-web-next` (Next.js 16) on
# 127.0.0.1:3001, managed by `mesh-pilot-web-next.service`.
#
# TLS: dedicated Let's Encrypt cert for meshpilot.app + www.meshpilot.app
# (issued 2026-05-26 via certbot --manual --preferred-challenges dns;
# renewal is manual — re-run the same command before 2026-08-24).
#
# Live status: this vhost is installed and serving once the Cloudflare
# A record for meshpilot.app points at this server's public IP
# (136.115.184.123). Until then the apex still resolves to Vercel.
# Plan §14.4 documents the DNS swap step.

# Redirect apex → HTTPS, and www → apex over HTTPS.
server {
    listen 80;
    listen [::]:80;
    server_name meshpilot.app www.meshpilot.app;

    # Keep an HTTP-01 well-known location available for future
    # certbot renewals — currently this cert renews via DNS-01 (the
    # certbot installation doesn't have Cloudflare API creds yet),
    # but if/when an HTTP-01 plugin is set up this works too.
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    return 301 https://meshpilot.app$request_uri;
}

# www → apex over HTTPS
server {
    listen 443 ssl;
    http2 on;
    listen [::]:443 ssl;
    server_name www.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/meshpilot.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    return 301 https://meshpilot.app$request_uri;
}

server {
    listen 443 ssl;
    http2 on;
    listen [::]:443 ssl;
    server_name meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/meshpilot.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Security headers (Vercel set these too — keep parity).
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # 25 MB allows the cockpit's brand-asset uploads (logos, etc.)
    # to pass through without 413.
    client_max_body_size 25m;

    access_log /var/log/nginx/meshpilot.app.access.log;
    error_log  /var/log/nginx/meshpilot.app.error.log;

    # cod-confirm voice-agent service (Shopify orders/create webhook intake +
    # LiveKit tool webhooks). Mirrors shopify.glitchexecutor.com/cod-confirm/.
    # Trailing slash on both location and proxy_pass strips the /cod-confirm
    # prefix, so /cod-confirm/webhook/shopify/orders-create → :3104/webhook/...
    location /cod-confirm/ {
        proxy_pass         http://127.0.0.1:3104/;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }

    location ~* ^// { return 400; }
    location / {
        proxy_pass         http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        # Next can stream Ask responses; SSR may run long on cold
        # builds — give it 90s before nginx 504s.
        proxy_read_timeout 90s;
        proxy_send_timeout 30s;
    }
}
