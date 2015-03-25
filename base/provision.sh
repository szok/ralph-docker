#!/bin/bash
set -e

apt-get update
#workaround for broken docker chfn pam authorization - see more details here: https://github.com/docker/docker/issues/6345

ln -s -f /bin/true /usr/bin/chfn

apt-get install -y python2.7 python-virtualenv python-dev build-essential libbz2-dev libfreetype6-dev libgdbm-dev libxft-dev curl
apt-get install -y libjpeg-dev libldap2-dev libltdl-dev libmysqlclient-dev libreadline-dev libsasl2-dev libsqlite3-dev
apt-get install -y libssl-dev libxslt1-dev ncurses-dev zlib1g-dev libmemcached-dev
apt-get install -y libcap2-bin
apt-get install -y vim-nox git
apt-get install -y ssh
apt-get install -y snmp snmpd
apt-get install -y dmidecode
apt-get install -y sudo

DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server mysql-server libmysqlclient-dev libmysqld-dev
DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server apache2 supervisor
# for scrooge
DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc-dev unixodbc-bin unixodbc freetds-dev

# there are 2 ways to install pip
# 1. Recommended by pip:
#    curl https://bootstrap.pypa.io/get-pip.py >/tmp/get-pip.py
#    python /tmp/get-pip.py
# 2. the second way used in production currently is to rely only 
#    on virtualenv, and install pip only in the virtualenv with some fixes.
#    pip install -U pip==1.5.6
#    pip install setuptools==3.6
# Currently we use the second solution, so we don't have pip here but in Dockerfile

