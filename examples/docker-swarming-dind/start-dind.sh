#!/bin/bash
set -e -x

docker swarm init
SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER=$(docker info | grep -w 'Node Address' | awk '{print $3}')
: NUM_WORKERS=${NUM_WORKERS:=3}

if [ ! -z "$1" ] ; then
  NUM_WORKERS=$1
fi

for WORKER_NUMBER in $(seq ${NUM_WORKERS}); do
    docker run -d --privileged --name worker-${WORKER_NUMBER} --hostname=worker-${WORKER_NUMBER} -p ${WORKER_NUMBER}2375:2375 docker:1.13.0-rc2-dind
    docker --host=localhost:${WORKER_NUMBER}2375 swarm join \
    --token ${SWARM_TOKEN} \
    ${SWARM_MASTER}:2377
done

docker run -it -d -p 5080:8080 \
-v /var/run/docker.sock:/var/run/docker.sock \
manomarks/visualizer
