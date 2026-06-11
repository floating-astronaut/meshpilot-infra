# auth.meshpilot.app — SHARED-login-native-meshpilot Option B.
#
# Mirrors /etc/nginx/sites-available/sso.glitchexecutor.com but on the
# meshpilot.app cookie scope so the dashboard at meshpilot.app/dashboard
# can read the session cookie. The Flask SSO at 127.0.0.1:6000 reads
# request.host and sets `Domain=.meshpilot.app` when the request arrives
# via this vhost; legacy callers still arrive via sso.glitchexecutor.com
# and continue to get `Domain=.glitchexecutor.com`.

server {
    listen 80;
    listen [::]:80;
    server_name auth.meshpilot.app;

    location /.well-known/acme-challenge/ { root /var/www/certbot; }
    location / { return 301 https://$host$request_uri; }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name auth.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/auth.meshpilot.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/auth.meshpilot.app/privkey.pem;

    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    access_log /var/log/nginx/auth-meshpilot.access.log;
    error_log  /var/log/nginx/auth-meshpilot.error.log;

    client_max_body_size 1m;

    location / {
        proxy_pass http://127.0.0.1:6000;
        proxy_http_version 1.1;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host  $host;
        proxy_read_timeout 30s;
        proxy_send_timeout 30s;
    }
}
