FROM centos:latest

USER root
ENV DOMAIN=""
ENV EMAIL=""
ENV UUID1=""
ENV UUID2=""

# install v2ray
CMD bash <(curl -L -s https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
COPY ./letsencrypt.tar.gz /root/
RUN cd /root/ && tar -xvf letsencrypt.tar.gz
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh &>/run.log 2>&1