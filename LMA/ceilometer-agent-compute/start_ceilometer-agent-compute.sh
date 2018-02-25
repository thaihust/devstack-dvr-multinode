#!/bin/bash

sed -i "s|TRANSPORT_URL|$TRANSPORT_URL|g" /etc/ceilometer/ceilometer.conf
sed -i "s|CEILOMETER_PASS|$CEILOMETER_PASS|g" /etc/ceilometer/ceilometer.conf

/usr/bin/ceilometer-polling --config-file=/etc/ceilometer/ceilometer.conf --polling-namespaces compute --log-file=/var/log/ceilometer/ceilometer-agent-compute.log

#service ceilometer-agent-compute start && tail -F /var/log/lastlog
