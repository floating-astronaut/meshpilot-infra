# brain.meshpilot.app — Mesh Pilot Brain MCP (streamable-HTTP / SSE on :3107).
#
# Replaces brain.glitchexecutor.com as the canonical brain endpoint.

server {
    listen 80;
    server_name brain.meshpilot.app;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name brain.meshpilot.app;

    ssl_certificate     /etc/letsencrypt/live/meshpilot.app-0001/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/meshpilot.app-0001/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://127.0.0.1:3107;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Streamable-HTTP / SSE
        proxy_buffering off;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
