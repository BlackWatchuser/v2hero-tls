FROM centos:latest

USER root
ENV DOMAIN=""
ENV EMAIL=""
ENV UUID1=""
ENV UUID2=""

# install v2ray
# CMD bash <(curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
COPY letsencrypt.tar.gz install_v.sh CentOS-Base.repo config.json entrypoint.sh /
CMD bash install_v.sh &>>/run.log 2>&1
CMD mv CentOS-Base.repo /etc/yum.repos.d/
CMD sed -i -e "s/\UUID1/$UUID1/g" -e "s/\UUID2/$UUID2/g" config.json && mv config.json /usr/local/etc/v2ray/config.json
CMD tar -xvf letsencrypt.tar.gz
CMD yum install nginx
CMD /letsencrypt/letsencrypt-auto-source/letsencrypt-auto certonly --standalone --email $EMAIL -d $DOMAIN

RUN chmod +x /entrypoint.sh && /entrypoint.sh &>/run.log 2>&1