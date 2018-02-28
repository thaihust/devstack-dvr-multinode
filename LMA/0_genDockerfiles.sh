#!/bin/bash

HTTP_PROXY=http://192.168.5.8:3128
HTTPS_PROXY=http://192.168.5.8:3128

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CONTAINER_DIRS=(
    ${DIR}/aodh-api
    ${DIR}/aodh-evaluator
    ${DIR}/aodh-listener
    ${DIR}/aodh-notifier
    ${DIR}/ceilometer
    ${DIR}/ceilometer-agent-central
    ${DIR}/ceilometer-agent-compute
    ${DIR}/ceilometer-agent-notification
    ${DIR}/ceilometer-collector
    ${DIR}/gnocchi
    ${DIR}/gnocchi-api
    ${DIR}/gnocchi-metricd
)

printf "Are you under a proxy?(y/n): "
read is_proxy

for dir in ${CONTAINER_DIRS[@]};
do
    cd $dir
    if [ $is_proxy == 'y' ] || [ $is_proxy == 'Y' ]; then
        sed -e "s|HTTP_PROXY|$HTTP_PROXY|g" -e "s|HTTPS_PROXY|$HTTPS_PROXY|g" sample.proxy > Dockerfile
    elif [ $is_proxy == 'n' ] || [ $is_proxy == 'N' ]; then
        cat sample > Dockerfile
    else
        echo "Invalid answer! Exit in 2s!!"
        sleep 2
        exit 1
    fi
done
