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

SCRIPT_PATH=$(dirname `which $0`)

instance="$2"
image_name=${DOCKER_IMAGE_NAME:="allegrogroup/ralph"}
docker_dest_port=${DOCKER_DEST_PORT:="8000"}
storage_name=${STORAGE_NAME:="${instance}_storage"}

if [ "$instance" == "os" ]; then
    tag=${DOCKER_OS_TAG:="latest"}
    image_name="${image_name}:${tag}"
fi
if [ "$instance" == "base" ]; then
    base_tag=${DOCKER_BASE_TAG:="base"}
    image_name="${image_name}:${base_tag}"
fi

if [ "$1" = "build" ]; then
    if [ "$instance" == "base" ]; then
        python ${SCRIPT_PATH}/build_files.py
    fi
	docker build -t="${image_name}" ${SCRIPT_PATH}/${instance}
    echo "Done"
fi

instance_name=${INSTANCE_NAME:="${instance}"}

if [ "$1" = "debug" ]; then
	docker run  --rm=true --name ${instance_name} -p 9000:9000 -t -i --volumes-from ${storage_name} ${image_name} $3 $4 $5 $6 $7 $8
fi

if [ "$1" = "start" ]; then
	docker stop -t 1 ${instance_name}  2> /dev/null || true
	docker rm ${instance_name}  2>/dev/null || true

    docker run -d --name ${instance_name} --mac-address=02:42:ac:11:ff:ff -p ${docker_dest_port}:8000 -t -i --volumes-from ${storage_name} ${image_name} $3 $4 $5 $6 $7 $8
fi

if [ "$1" = "stop" ]; then
	docker ps a | grep $instance_name | awk '{print $1}' | xargs sudo docker stop 2>/dev/null
fi

if [ "$1" = "ps" ]; then
	docker ps
fi

if [ "$1" = "exec" ]; then
	docker exec -t -i ${instance_name} "/bin/bash"
fi

if [ "$1" = "upgrade" ]; then
	docker exec ${instance_name} su -c "/home/ralph/bin/ralph migrate" ralph
fi

if [ "$1" = "init" ]; then
    cp os/init.sh test/init.sh
    echo 'stopping processes...'
    docker stop ${instance_name}  2>/dev/null || true
    echo 'init storage...'
    docker run -i -t --name ${storage_name} -v /Users/piotrjarolewski/allegro/ralph-docker/test:/home/ralph -v /var/lib/mysql -v /home/ralph/.ralph busybox /bin/sh -c "chown default /home/ralph; chown default /home/ralph/.ralph"
    echo 'init ralph...'
    docker run --rm=true --name ${instance_name} -i --volumes-from ${storage_name} ${image_name} /bin/bash /home/ralph/init.sh
    echo "Done"
fi
