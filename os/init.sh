#!/bin/bash

echo "Ralph makeconf"
/home/ralph/bin/ralph makeconf

echo "Added additional settings to Ralph settings"
cat /home/ralph/additional-settings.py >>/home/ralph/.ralph/settings

mysql_install_db

mysqld_safe &

echo 'Waiting 10 secs for mysqld to come up'
sleep 10
echo "CREATE DATABASE ralph DEFAULT CHARACTER SET 'utf8'" | mysql
echo "GRANT ALL ON ralph.* TO ralph@'%' IDENTIFIED BY 'ralph'; FLUSH PRIVILEGES" | mysql

/home/ralph/bin/ralph syncdb --all --noinput
/home/ralph/bin/ralph migrate --fake
/home/ralph/bin/ralph createsuperuser ralph --noinput --user ralph --email ralph@allegrogroup.com
/home/ralph/bin/ralph shell < /home/ralph/createsuperuser.py
DJANGO_SETTINGS_MODULE=ralph.settings /home/ralph/bin/ralph make_demo_data
/home/ralph/bin/ralph collectstatic -l --noinput
# sync scrooge for last month
for i in {0..31}; do /home/ralph/bin/ralph scrooge_sync --today=`python -c "from datetime import timedelta, date; print(date.today() - timedelta(days=$i))"`; done
mysqladmin shutdown

chgrp -R ralph /home/ralph && chown -R ralph /home/ralph
