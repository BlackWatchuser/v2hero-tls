FROM centos:latest

ENV DOMAIN=""
ENV EMAIL=""
ENV UUID1=""
ENV UUID2=""

# install v2ray
CMD bash <(curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
ADD letsencrypt.tar.gz /root/letsencrypt.tar.gz
RUN cd /root && tar -xf letsencrypt.tar.gz
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh