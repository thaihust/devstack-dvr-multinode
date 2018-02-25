#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
METRIC_API_HOST=lma-cluster
ALARM_API_HOST=lma-cluster
REGION=North_VN
ROOT_DBPASS=4Mv2sqWnZDN4JXxhXxKGHOcgj5fbZsAl
METRICDB=gnocchi
ALARMDB=aodh
source ${DIR}/mon_vars/ceilometer.env
source ${DIR}/mon_vars/gnocchi.env
source ${DIR}/mon_vars/aodh.env
source ${DIR}/run_vars/openstackclient.env

function mysql_cli {
    mysql -uroot -p${ROOT_DBPASS} -e "$1"
}

# GNOCCHI
function create_db_metric {
    mysql_cli "DROP DATABASE ${METRICDB};"
    mysql_cli "CREATE DATABASE ${METRICDB} default character set utf8;"
    mysql_cli "GRANT ALL ON ${METRICDB}.* TO 'gnocchi'@'%' IDENTIFIED BY '${GNOCCHI_DBPASS}';"
    mysql_cli "GRANT ALL ON ${METRICDB}.* TO 'gnocchi'@'localhost' IDENTIFIED BY '${GNOCCHI_DBPASS}';"
    mysql_cli "FLUSH PRIVILEGES;"
}

function add_user_telemetry {
    openstack user create ceilometer --domain default --password ${CEILOMETER_PASS}
    openstack role add --project service --user ceilometer admin
    openstack service create --name ceilometer \
      --description "Telemetry" metering
    
    openstack user create gnocchi --domain default --password ${GNOCCHI_PASS}
    openstack service create --name gnocchi \
      --description "Metric Service" metric
    
    openstack role add --project service --user gnocchi admin
}

function create_endpoints_metric {
    IFS=' ' read -r -a metric_enps <<< "$(echo $(openstack endpoint list | grep metric | awk '{ print $2 }'))"
    for enp in ${metric_enps[@]}
    do
        openstack endpoint delete ${enp}
    done

    openstack endpoint create --region ${REGION} \
      metric public http://${METRIC_API_HOST}:8041
    openstack endpoint create --region ${REGION} \
      metric internal http://${METRIC_API_HOST}:8041
    openstack endpoint create --region ${REGION} \
      metric admin http://${METRIC_API_HOST}:8041
}

# AODH

function create_db_alarm {
    mysql_cli "DROP DATABASE ${ALARMDB};"
    mysql_cli "CREATE DATABASE ${ALARMDB} default character set utf8;"
    mysql_cli "GRANT ALL ON ${ALARMDB}.* TO 'aodh'@'%' IDENTIFIED BY '${AODH_DBPASS}';"
    mysql_cli "GRANT ALL ON ${ALARMDB}.* TO 'aodh'@'localhost' IDENTIFIED BY '${AODH_DBPASS}';"
    mysql_cli "FLUSH PRIVILEGES;"
}

function add_user_alarm {
    openstack user create aodh --domain default --password ${AODH_PASS}
    openstack role add --project service --user aodh admin
    openstack service create --name aodh \
      --description "Telemetry" alarming 
}

function create_endpoints_alarm {
    IFS=' ' read -r -a enps <<< "$(echo $(openstack endpoint list | grep alarming | awk '{ print $2 }'))"
    for enp in ${enps[@]}
    do
        openstack endpoint delete ${enp}
    done

    openstack endpoint create --region ${REGION} \
      alarming public http://${ALARM_API_HOST}:8042
    openstack endpoint create --region ${REGION} \
      alarming internal http://${ALARM_API_HOST}:8042
    openstack endpoint create --region ${REGION} \
      alarming admin http://${ALARM_API_HOST}:8042
}

# UTILS

function lma_metric {
    echo "Create metric db, user, endpoints"
    create_db_metric
    add_user_metric
    create_endpoints_metric
}

function lma_alarm {    
    echo " Create alarm db, user, endpoints"
    create_db_alarm
    add_user_alarm
    create_endpoints_alarm
}
