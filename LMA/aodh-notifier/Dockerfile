FROM ubuntu:16.04
MAINTAINER thangmv@vcs-team

ENV SERVICE="aodh"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y software-properties-common \
	&& add-apt-repository cloud-archive:ocata -y \
	&& apt update &&  apt install -y python-pymysql

RUN apt update \
        && apt install -y aodh-api aodh-evaluator aodh-notifier aodh-listener aodh-expirer python-aodhclient \
        && apt-get clean

RUN apt update \
        && apt install -y python-memcache \
        && apt-get clean

COPY aodh.conf /etc/aodh/aodh.conf
COPY start_aodh.sh /usr/local/bin/start_aodh.sh

RUN chmod +x /usr/local/bin/start_aodh.sh \
	&& a2dissite 000-default.conf \
	&& echo > /etc/apache2/ports.conf \
	&& echo ServerName localhost >> /etc/apache2/apache2.conf

VOLUME ["/var/log/apache2", "/var/lib/aodh"]

EXPOSE 8042

USER root

CMD ["start_aodh.sh"]
