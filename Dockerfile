FROM centos:latest

USER root
ENV DOMAIN=""
ENV EMAIL=""
ENV UUID1=""
ENV UUID2=""

WORKDIR /root
# install v2ray
# CMD bash <(curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
COPY letsencrypt.tar.gz /root/
COPY install_v.sh /root/
COPY CentOS-Base.repo /root/
COPY config.json /root/
COPY entrypoint.sh /root/
CMD bash install_v.sh
CMD mv CentOS-Base.repo /etc/yum.repos.d/
CMD sed -i -e "s/\UUID1/$UUID1/g" -e "s/\UUID2/$UUID2/g" config.json && mv config.json /usr/local/etc/v2ray/config.json
CMD tar -xvf letsencrypt.tar.gz
CMD yum install nginx
CMD /letsencrypt/letsencrypt-auto-source/letsencrypt-auto certonly --standalone --email $EMAIL -d $DOMAIN
RUN chmod +x /root/entrypoint.sh
RUN /root/entrypoint.sh