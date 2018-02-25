FROM ubuntu:16.04
MAINTAINER thangmv@vcs-team

ENV SERVICE="ceilometer"
ENV http_proxy="http://192.168.5.8:3128"
ENV https_proxy="http://192.168.5.8:3128"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y software-properties-common \
	&& add-apt-repository cloud-archive:ocata -y \
	&& apt update &&  apt install -y python-pymysql

RUN apt update \
        && apt install -y ceilometer-collector python-ceilometerclient python-gnocchiclient \
        && apt-get clean

COPY ceilometer.conf /etc/ceilometer/ceilometer.conf
COPY pipeline.yaml /etc/ceilometer/pipeline.yaml
COPY start_ceilometer-collector.sh  /usr/local/bin/start_ceilometer-collector.sh

RUN chmod +x /usr/local/bin/start_ceilometer-collector.sh

VOLUME ["/var/log/ceilometer", "/var/lib/ceilometer"]

#EXPOSE

USER root

CMD ["start_ceilometer-collector.sh"]
