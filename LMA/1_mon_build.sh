#!/bin/bash

REGISTRY=ops-services-registry:4000
TAG=ocata

MON_SRV=(
    ceilometer
    ceilometer-agent-central
    ceilometer-agent-compute
    ceilometer-agent-notification
    ceilometer-collector
    gnocchi
    gnocchi-api
    gnocchi-metricd
)

ALARM_SRV=(
    aodh-notifier
    aodh-listener
    aodh-evaluator
    aodh-api
)

for service in ${MON_SRV[*]}
do
    docker build -t ${REGISTRY}/${service}:${TAG} ${service}/
    docker push ${REGISTRY}/${service}:${TAG}
done

for service in ${ALARM_SRV[*]}
do
    docker build -t ${REGISTRY}/${service}:${TAG} ${service}/
    docker push ${REGISTRY}/${service}:${TAG}
done
