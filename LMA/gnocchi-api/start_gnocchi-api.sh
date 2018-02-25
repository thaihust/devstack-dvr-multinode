#!/bin/bash

#!/bin/bash

# NOTE(pbourke): apache2  will not clean up after itself in some cases which
# results in the container not being able to restart. (bug #1489676, 1557036)

# Loading Apache2 ENV variables
. /etc/apache2/envvars
rm -rf /var/run/apache2/*

chown -R gnocchi.root /var/log/gnocchi/
chown -R gnocchi.root /var/lib/gnocchi/
chmod -R 775 /var/log/gnocchi/
chmod -R 775 /var/lib/gnocchi/

sed -i "s/localhost/$HOSTNAME/g" /etc/apache2/apache2.conf
sed -i "s|TRANSPORT_URL|$TRANSPORT_URL|g" /etc/gnocchi/gnocchi.conf
sed -i "s|GNOCCHI_PASS|$GNOCCHI_PASS|g" /etc/gnocchi/gnocchi.conf
sed -i "s|GNOCCHI_DBPASS|$GNOCCHI_DBPASS|g" /etc/gnocchi/gnocchi.conf
sed -i "s|MEMCACHED_SERVERS|$MEMCACHED_SERVERS|g" /etc/gnocchi/gnocchi.conf

/usr/sbin/apache2ctl -D FOREGROUND
