domain_name=$DOMAIN
email=$EMAIL
# yum epel
cat >/etc/yum.repos.d/CentOS-Base.repo <<'EOF'
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-$releasever - Base - mirrors.aliyun.com
#failovermethod=priority
baseurl=https://mirrors.aliyun.com/centos/$releasever/BaseOS/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/BaseOS/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/BaseOS/$basearch/os/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras - mirrors.aliyun.com
#failovermethod=priority
baseurl=https://mirrors.aliyun.com/centos/$releasever/extras/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/extras/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/extras/$basearch/os/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus - mirrors.aliyun.com
#failovermethod=priority
baseurl=https://mirrors.aliyun.com/centos/$releasever/centosplus/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/centosplus/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/centosplus/$basearch/os/
gpgcheck=1
enabled=0
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official

[PowerTools]
name=CentOS-$releasever - PowerTools - mirrors.aliyun.com
#failovermethod=priority
baseurl=https://mirrors.aliyun.com/centos/$releasever/PowerTools/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/PowerTools/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/PowerTools/$basearch/os/
gpgcheck=1
enabled=0
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official


[AppStream]
name=CentOS-$releasever - AppStream - mirrors.aliyun.com
#failovermethod=priority
baseurl=https://mirrors.aliyun.com/centos/$releasever/AppStream/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/AppStream/$basearch/os/
        http://mirrors.aliyuncs.com/centos/$releasever/AppStream/$basearch/os/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official
EOF

cat <<EOF >/usr/local/etc/v2ray/config.json
{
  "inbounds": [
  {
    "listen": "127.0.0.1",
    "port": 42348,
    "protocol": "vmess",
    "tag": "proxy",
    "settings": {
      "clients": [
        {"id": "$UUID1", "email": "justsoso", "level": 0, "alterId": 64},
        {"id": "$UUID2", "email": "justsoso1", "level": 0, "alterId": 64}
      ]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/"
      }
    }
  }
  ],

  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }],

  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  }
}
EOF

# tls
/root/letsencrypt/letsencrypt-auto-source/letsencrypt-auto certonly --standalone --email $email -d $domain_name

# install nginx
yum install nginx

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

systemctl restart v2ray
systemctl enable v2ray
systemctl restart nginx

while true
do
  sleep 1
done