#!/bin/bash

sed -i "s|TRANSPORT_URL|$TRANSPORT_URL|g" /etc/gnocchi/gnocchi.conf
sed -i "s|GNOCCHI_PASS|$GNOCCHI_PASS|g" /etc/gnocchi/gnocchi.conf
sed -i "s|GNOCCHI_DBPASS|$GNOCCHI_DBPASS|g" /etc/gnocchi/gnocchi.conf
sed -i "s|MEMCACHED_SERVERS|$MEMCACHED_SERVERS|g" /etc/gnocchi/gnocchi.conf

gnocchi-metricd --log-file=/var/log/gnocchi/gnocchi-metricd.log
