#!/bin/bash

echo "Ralph makeconf"
/home/ralph/bin/ralph makeconf

echo "Added additional settings to Ralph settings"
cat /root/additional-settings.py >>/home/ralph/.ralph/settings

mysql_install_db

virtualenv /home/ralph/ && /home/ralph/bin/pip install pip==1.5.6 && /home/ralph/bin/pip install setuptools==3.6 && mkdir /home/ralph/.ralph


mysqld_safe &

echo 'Waiting 10 secs for mysqld to come up'
sleep 10
echo "CREATE DATABASE ralph DEFAULT CHARACTER SET 'utf8'" | mysql
echo "GRANT ALL ON ralph.* TO ralph@'%' IDENTIFIED BY 'ralph'; FLUSH PRIVILEGES" | mysql

cd /home/ralph
. bin/activate
mkdir sources/
cd sources/

git clone https://github.com/allegro/ralph_assets.git -b develop
git clone https://github.com/quamilek/bob-ajax-selects.git -b develop
git clone https://github.com/allegro/django-bob.git -b develop
git clone https://github.com/allegro/ralph.git -b develop
git clone https://github.com/allegro/ralph_pricing.git -b develop


for i in ralph_assets bob-ajax-selects django-bob ralph ralph_pricing
do
    echo "$i";
    cd /home/ralph/sources/$i;
    make install;
done

/home/ralph/bin/ralph collectstatic --noinput

/home/ralph/bin/ralph syncdb --all --noinput
/home/ralph/bin/ralph migrate --fake
/home/ralph/bin/ralph createsuperuser ralph --noinput --user ralph --email ralph@allegrogroup.com
/home/ralph/bin/ralph shell < /root//createsuperuser.py
DJANGO_SETTINGS_MODULE=ralph.settings /home/ralph/bin/ralph make_demo_data
/home/ralph/bin/ralph collectstatic -l --noinput
# sync scrooge for last month
for i in {0..31}; do /home/ralph/bin/ralph scrooge_sync --today=`python -c "from datetime import timedelta, date; print(date.today() - timedelta(days=$i))"`; done
mysqladmin shutdown

chgrp -R ralph /home/ralph && chown -R ralph /home/ralph
