# apps.meshpilot.app — Mesh Pilot embedded Shopify app (self-hosted).
#
# Serves the React-Router (Remix) embedded admin app from the
# mesh-pilot-shopify-embed container on 127.0.0.1:3120. This is the
# application_url Shopify loads in the admin iframe; merchants who open
# the Mesh Pilot app land here. Kept on its own subdomain so the
# app's paths (/app /auth /webhooks /api /privacy /support /docs) never
# collide with the cockpit/marketing routes on the meshpilot.app apex.
#
# HTTP block carries the ACME challenge + redirects to HTTPS. The HTTPS
# server block is appended by `certbot --nginx` on first cert issue.

server {
    listen 80;
    listen [::]:80;
    server_name apps.meshpilot.app;

    location /.well-known/acme-challenge/ { root /var/www/certbot; }
    location / { return 301 https://$host$request_uri; }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name apps.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/apps.meshpilot.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/apps.meshpilot.app/privkey.pem;

    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    # NOTE: no X-Frame-Options / frame-ancestors DENY here — this app is
    # embedded in the Shopify admin iframe; the Remix app sets its own
    # CSP frame-ancestors for the merchant's shop + admin.shopify.com.

    access_log /var/log/nginx/apps-meshpilot.access.log;
    error_log  /var/log/nginx/apps-meshpilot.error.log;

    client_max_body_size 10m;

    location /.well-known/acme-challenge/ { root /var/www/certbot; }

    location / {
        proxy_pass http://127.0.0.1:3120;
        proxy_http_version 1.1;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host  $host;
        proxy_set_header Upgrade           $http_upgrade;
        proxy_set_header Connection        "upgrade";
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
    }
}
