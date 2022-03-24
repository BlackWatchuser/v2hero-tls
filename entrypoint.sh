
# nginx conf
cat <<EOF >/etc/nginx/conf.d/v2ray.conf
server {
  listen                     443 ssl;
  ssl                        on;
  server_name                $domain_name;
  ssl_certificate            /etc/letsencrypt/live/$domain_name/fullchain.pem;
  ssl_certificate_key        /etc/letsencrypt/live/$domain_name/privkey.pem;
  ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers                HIGH:!aNULL:!MD5;

  location / {
    proxy_redirect           off;
    proxy_pass               http://127.0.0.1:42348;
    proxy_http_version       1.1;
    proxy_set_header         Upgrade $http_upgrade;
    proxy_set_header         Connection "upgrade";
    proxy_set_header         Host $http_host;
    proxy_set_header         X-Real-IP $remote_addr;
    proxy_set_header         X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  access_log                /var/log/nginx-v2ray-access.log;
  error_log                 /var/log/nginx-v2ray-error.log;
}
EOF


systemctl enable v2ray
systemctl restart v2ray
systemctl restart nginx

while true
do
  sleep 1
done