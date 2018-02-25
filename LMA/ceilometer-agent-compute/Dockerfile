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
	&& apt-get install -y ceilometer-agent-compute \
        && apt-get clean

COPY ceilometer.conf /etc/ceilometer/ceilometer.conf
COPY pipeline.yaml /etc/ceilometer/pipeline.yaml
COPY polling.yaml /etc/ceilometer/polling.yaml 
COPY start_ceilometer-agent-compute.sh  /usr/local/bin/start_ceilometer-agent-compute.sh

RUN chmod +x /usr/local/bin/start_ceilometer-agent-compute.sh

VOLUME ["/var/log/ceilometer", "/var/lib/ceilometer"]

#EXPOSE

USER root

CMD ["start_ceilometer-agent-compute.sh"]
