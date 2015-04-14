#!/bin/bash

# just in case.
chown -R mysql:mysql /var/lib/mysql

mysqld_safe &

echo 'Waiting 10 secs for mysqld to come up'
sleep 10

/home/ralph/bin/ralph migrate
DJANGO_SETTINGS_MODULE=ralph.settings /home/ralph/bin/ralph make_demo_data -d assets_dc_assets -d relations
/home/ralph/bin/ralph collectstatic -l 
mysqladmin shutdown
