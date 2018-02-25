#!/bin/bash

DOCKER_REGISTRY=ops-services-registry:4000
TAG=ocata
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GF_TAG=latest

METRIC_IMAGES=(
   gnocchi-metricd
   gnocchi-api
   gnocchi
   ceilometer
   ceilometer-collector
   ceilometer-agent-notification
   ceilometer-agent-compute
   ceilometer-agent-central
   aodh-api
)

function pull_image {
   for image in ${METRIC_IMAGES[@]}
   do
       docker pull ${DOCKER_REGISTRY}/${image}:${TAG}
   done
}

function delete_image {
   for image in ${METRIC_IMAGES[@]}
   do
       docker image remove ${DOCKER_REGISTRY}/${image}:${TAG}
   done
}

function start {
   for image in ${METRIC_IMAGES[@]}
   do
       docker start ${image}
   done
}

function stop {
   for image in ${METRIC_IMAGES[@]}
   do
       docker stop ${image}
   done
}

function delete {
   for image in ${METRIC_IMAGES[@]}
   do
       docker rm -f -v ${image}
   done
}

function run_compute_agent {
   docker run -d --name ceilometer-agent-compute --network=host --user root \
              -v /run:/run:shared \
              -v /var/log/ceilometer:/var/log/ceilometer \
              -v /var/lib/ceilometer:/var/lib/ceilometer \
              -v /etc/localtime:/etc/localtime \
              -v /root/openstack-in-docker/ceilometer/ceilometer.conf:/etc/ceilometer/ceilometer.conf \
              -v /root/openstack-in-docker/ceilometer/pipeline.yaml:/etc/ceilometer/pipeline.yaml \
              -v /root/openstack-in-docker/ceilometer/polling.yaml:/etc/ceilometer/polling.yaml \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/ceilometer.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/ceilometer-agent-compute:${TAG} \
              /usr/bin/ceilometer-polling --config-file=/etc/ceilometer/ceilometer.conf --polling-namespaces compute --log-file=/var/log/ceilometer/ceilometer-agent-compute.log
}

# COMPUTE NODES

function ceilometer_agent_compute {
   docker run -d --name ceilometer-agent-compute --network=host --user root \
              -v /run:/run:shared \
              -v /var/log/ceilometer:/var/log/ceilometer \
              -v /var/lib/ceilometer:/var/lib/ceilometer \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/ceilometer.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/ceilometer-agent-compute:${TAG}
}

# METRIC NODES

function gnocchi_api {
   docker run -d --name gnocchi-api --network=host --user root \
              -v /var/log/apache2:/var/log/apache2 \
              -v /var/log/gnocchi:/var/log/gnocchi \
              -v /var/lib/gnocchi:/var/lib/gnocchi \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/gnocchi.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/gnocchi-api:${TAG}
}

function gnocchi_metricd {
   docker run -d --name gnocchi-metricd --network=host --user gnocchi \
              -v /var/log/gnocchi:/var/log/gnocchi \
              -v /var/lib/gnocchi:/var/lib/gnocchi \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/gnocchi.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/gnocchi-metricd:${TAG}
}

function ceilometer_agent_central {
   docker run -d --name ceilometer-agent-central --network=host --user root \
              -v /var/log/ceilometer:/var/log/ceilometer \
              -v /var/lib/ceilometer:/var/lib/ceilometer \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/ceilometer.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/ceilometer-agent-central:${TAG}
}

function ceilometer_agent_notification {
   docker run -d --name ceilometer-agent-notification --network=host --user root \
              -v /var/log/ceilometer:/var/log/ceilometer \
              -v /var/lib/ceilometer:/var/lib/ceilometer \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/ceilometer.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/ceilometer-agent-notification:${TAG}
}

function ceilometer_collector {
   docker run -d --name ceilometer-collector --network=host --user root \
              -v /var/log/ceilometer:/var/log/ceilometer \
              -v /var/lib/ceilometer:/var/lib/ceilometer \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/ceilometer.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/ceilometer-collector:${TAG}
}

# AODH SERVICES
function aodh_api {
   docker run -d --name aodh_api --network=host --user root \
              -v /var/log/apache2:/var/log/apache2 \
              -v /var/lib/aodh:/var/lib/aodh \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/aodh.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/aodh-api:${TAG}
}

function aodh_evaluator {
   docker run -d --name aodh_evaluator --network=host --user root \
              -v /var/log/aodh:/var/log/aodh \
              -v /var/lib/aodh:/var/lib/aodh \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/aodh.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/aodh-evaluator:${TAG}
}

function aodh_listener {
   docker run -d --name aodh_listener --network=host --user root \
              -v /var/log/aodh:/var/log/aodh \
              -v /var/lib/aodh:/var/lib/aodh \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/aodh.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/aodh-listener:${TAG}
}

function aodh_notifier {
   docker run -d --name aodh_notifier --network=host --user root \
              -v /var/log/aodh:/var/log/aodh \
              -v /var/lib/aodh:/var/lib/aodh \
              -v /etc/localtime:/etc/localtime \
              --env-file="${DIR}/run_vars/general.env" \
              --env-file="${DIR}/mon_vars/aodh.env" \
              --env-file="${DIR}/mon_vars/no_proxy.env" \
              ${DOCKER_REGISTRY}/aodh-notifier:${TAG}
}

function grafana {
   docker rm -f -v grafana
   rm -rf /var/lib/grafana /var/log/grafana
   docker run \
     -d --network=host --user root \
     -p 3000:3000 \
     --name=grafana \
     --env-file="${DIR}/mon_vars/grafana.env" \
     -v /var/lib/grafana:/var/lib/grafana \
     -v /var/log/grafana:/var/log/grafana \
     -v /etc/localtime:/etc/localtime \
     grafana/grafana:${GF_TAG}
}
