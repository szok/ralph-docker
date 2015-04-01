#!/bin/bash

set -e

branch='develop'

cd /home/ralph
. bin/activate
rm -rf sources
mkdir sources/
cd sources/
git clone https://github.com/allegro/ralph.git -b $branch
git clone https://github.com/allegro/ralph_assets.git -b $branch
git clone https://github.com/allegro/ralph_pricing.git -b $branch
git clone https://github.com/allegro/django-bob.git django_bob -b $branch
git clone https://github.com/quamilek/bob-ajax-selects.git -b $branch

for i in ralph_assets bob-ajax-selects django_bob ralph ralph_pricing
do
    echo "$i";
    cd /home/ralph/sources/$i;
    make install;
done

