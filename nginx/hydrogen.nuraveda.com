map $http_upgrade $hydrogen_demo_conn_upg {
    default upgrade;
    ''      close;
}

server {
    listen 80;
    listen [::]:80;
    server_name hydrogen.nuraveda.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name hydrogen.nuraveda.com;

    ssl_certificate /etc/letsencrypt/live/hydrogen.nuraveda.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/hydrogen.nuraveda.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Strict-Transport-Security "max-age=31536000" always;

    client_max_body_size 20m;

    location / {
        proxy_pass http://127.0.0.1:3030;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $hydrogen_demo_conn_upg;
        proxy_read_timeout 86400;
    }
}
