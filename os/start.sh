#!/bin/bash

#Start SNMPD
/usr/sbin/snmpd
# Start supervisor (mysql, gunicorn, rqworkers, mysql, redis)
/usr/bin/supervisord
