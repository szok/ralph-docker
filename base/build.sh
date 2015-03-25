#!/bin/bash

set -e

instance="base"
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t $instance $dir/