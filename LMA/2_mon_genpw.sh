#!/bin/bash

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
METRIC_NODE=lma-cluster

rm -rf ${CUR_DIR}/mon_vars
mkdir ${CUR_DIR}/mon_vars

AODH_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
AODH_DBPASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

CEILOMETER_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
CEILOMETER_DBPASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

GNOCCHI_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
GNOCCHI_DBPASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

PANKO_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
PANKO_DBPASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

GF_SECURITY_ADMIN_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

echo "AODH_PASS=${AODH_PASS}" >> ${CUR_DIR}/mon_vars/aodh.env
echo "AODH_DBPASS=${AODH_DBPASS}" >> ${CUR_DIR}/mon_vars/aodh.env

echo "CEILOMETER_PASS=${CEILOMETER_PASS}" >> ${CUR_DIR}/mon_vars/ceilometer.env
echo "CEILOMETER_DBPASS=${CEILOMETER_DBPASS}" >> ${CUR_DIR}/mon_vars/ceilometer.env

echo "GNOCCHI_PASS=${GNOCCHI_PASS}" >> ${CUR_DIR}/mon_vars/gnocchi.env
echo "GNOCCHI_DBPASS=${GNOCCHI_DBPASS}" >> ${CUR_DIR}/mon_vars/gnocchi.env

echo "PANKO_PASS=${PANKO_PASS}" >> ${CUR_DIR}/mon_vars/panko.env
echo "PANKO_DBPASS=${PANKO_DBPASS}" >> ${CUR_DIR}/mon_vars/panko.env

echo "GF_SECURITY_ADMIN_PASSWORD=${GF_SECURITY_ADMIN_PASSWORD}" >> ${CUR_DIR}/mon_vars/grafana.env
echo "GF_SERVER_ROOT_URL=http://grafana.vcsspace.com" >> ${CUR_DIR}/mon_vars/grafana.env
#echo "GF_INSTALL_PLUGINS=grafana-clock-panel,gnocchixyz-gnocchi-datasource" >> ${CUR_DIR}/mon_vars/grafana.env

echo "http_proxy=" >> ${CUR_DIR}/mon_vars/no_proxy.env
echo "https_proxy=" >> ${CUR_DIR}/mon_vars/no_proxy.env

echo "http_proxy=http://192.168.5.8:3128" >> ${CUR_DIR}/mon_vars/proxy.env
echo "https_proxy=http://192.168.5.8:3128" >> ${CUR_DIR}/mon_vars/proxy.env

echo "METRIC_NODE=${METRIC_NODE}" >> ${CUR_DIR}/mon_vars/metric_endpoint.env
