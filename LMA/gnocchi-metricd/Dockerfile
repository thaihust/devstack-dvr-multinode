FROM ubuntu:16.04
MAINTAINER thangmv@vcs-team

ENV SERVICE="gnocchi"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y software-properties-common \
	&& add-apt-repository cloud-archive:ocata -y

RUN apt update && apt install -y python-pip python-pymysql python-memcache \
	&& apt clean

RUN apt update && apt install -y gnocchi-metricd gnocchi-common gnocchi-metricd python-gnocchi

COPY gnocchi.conf /etc/gnocchi/gnocchi.conf
COPY start_gnocchi-metricd.sh /usr/local/bin/start_gnocchi-metricd.sh

RUN chmod +x /usr/local/bin/start_gnocchi-metricd.sh

VOLUME ["/var/log/gnocchi", "/var/lib/gnocchi"]

USER gnocchi

CMD ["start_gnocchi-metricd.sh"]

