#!/bin/bash

# Start SSH
/etc/init.d/ssh start
#Start SNMPD
/usr/sbin/snmpd
# Start supervisor (mysql, gunicorn, rqworkers, mysql, redis)
/usr/bin/supervisord