#!/bin/bash

# NOTE(pbourke): apache2  will not clean up after itself in some cases which
# results in the container not being able to restart. (bug #1489676, 1557036)

# Loading Apache2 ENV variables
. /etc/apache2/envvars
rm -rf /var/run/apache2/*

sed -i "s/localhost/$HOSTNAME/g" /etc/apache2/apache2.conf
sed -i "s|TRANSPORT_URL|$TRANSPORT_URL|g" /etc/aodh/aodh.conf
sed -i "s|AODH_PASS|$AODH_PASS|g" /etc/aodh/aodh.conf 
sed -i "s|AODH_DBPASS|$AODH_DBPASS|g" /etc/aodh/aodh.conf 

/usr/sbin/apache2ctl -D FOREGROUND
