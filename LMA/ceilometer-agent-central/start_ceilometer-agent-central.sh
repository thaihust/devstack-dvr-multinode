#!/bin/bash

sed -i "s|TRANSPORT_URL|$TRANSPORT_URL|g" /etc/ceilometer/ceilometer.conf
sed -i "s|CEILOMETER_PASS|$CEILOMETER_PASS|g" /etc/ceilometer/ceilometer.conf
service ceilometer-agent-central start && tail -F /var/log/lastlog
#/etc/init.d/ceilometer-agent-central start
