#!/bin/bash

set -e

die () {
    echo >&2 "$@"
    exit 1
}

if [ "$1" = "clean" ]; then
	# kill all running containers
	docker kill $(docker ps -q)
	docker images -q --filter "dangling=true" | xargs sudo docker rmi || true
	docker stop $(sudo docker ps -a -q) || true
fi

if [ "$#" -lt "2" ]; then
	die "Usage: build.sh [clean] [build <instance>]"
fi

instance="$2"
image_name=$instance

if [ "$instance" == "os" ]; then
	image_name="allegrogroup/ralph:latest"
fi
if [ "$instance" == "base" ]; then
    image_name="allegrogroup/ralph:base"
fi

if [ "$1" = "build" ]; then
	docker build -t="${image_name}" ${instance}
fi

if [ "$1" = "debug" ]; then
	docker run  --rm=true --name ${instance} -p 9000:9000 -t -i --volumes-from ${instance}_storage ${image_name} $3 $4 $5 $6 $7 $8
fi

if [ "$1" = "start" ]; then
	docker stop -t 1 ${instance}  2> /dev/null || true
	docker rm ${instance}  2>/dev/null || true
	docker run -d --name ${instance} --mac-address=02:42:ac:11:ff:ff -p 8000:8000 -t -i --volumes-from ${instance}_storage ${image_name} $3 $4 $5 $6 $7 $8
fi

if [ "$1" = "stop" ]; then
	docker ps a | grep $instance | awk '{print $1}' | xargs sudo docker stop 2>/dev/null
fi

if [ "$1" = "ps" ]; then
	docker ps
fi

if [ "$1" = "exec" ]; then
	docker exec -t -i ${instance} "/bin/bash"
fi

if [ "$1" = "upgrade" ]; then
	docker exec ${instance} su -c "/home/ralph/bin/ralph migrate" ralph
fi

if [ "$1" = "init" ]; then
    echo 'stopping processes...'
    docker stop ${instance}  2>/dev/null || true
    echo 'init storage...'
    docker run -i -t --name ${instance}_storage -v /var/lib/mysql -v /home/ralph/.ralph busybox /bin/sh -c "chown default /home/ralph; chown default /home/ralph/.ralph"
    echo 'init ralph...'
    docker run --rm=true --name ${instance} -i --volumes-from ${instance}_storage ${image_name} /bin/bash /home/ralph/init.sh
fi
