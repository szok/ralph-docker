#!/bin/sh

set -e

branch='develop'

instance="os"
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $dir

rm -rf ./sources
mkdir sources/
cd sources/
git clone https://github.com/allegro/ralph.git -b $branch
git clone https://github.com/allegro/ralph_assets.git -b $branch
git clone https://github.com/allegro/ralph_pricing.git -b $branch
git clone https://github.com/allegro/django-bob.git django_bob -b $branch
git clone https://github.com/quamilek/bob-ajax-selects.git -b $branch
cd ..
cp Makefile sources/

docker build -t='vi4m/ralph:latest' .