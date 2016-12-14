#!/bin/bash
set -e -x

docker swarm init $1
SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER=$(docker info | grep -w 'Node Address' | awk '{print $3}')
: NUM_WORKERS=${NUM_WORKERS:=3}

if [ ! -z "$2" ] ; then
  NUM_WORKERS=$2
fi

for WORKER_NUMBER in $(seq ${NUM_WORKERS}); do
    docker run -d --privileged --name worker-${WORKER_NUMBER} \
      --hostname=worker-${WORKER_NUMBER} \
      -p ${WORKER_NUMBER}2375:2375 docker:1.13.0-rc2-dind
    sleep 2
    docker --host=0.0.0.1:${WORKER_NUMBER}2375 swarm join \
      --token ${SWARM_TOKEN} \
      ${SWARM_MASTER}:2377
done

docker run -it -d -p 5080:8080 --name visualizer  \
-v /var/run/docker.sock:/var/run/docker.sock \
manomarks/visualizer

docker service create --name registry \
 --constraint 'node.role == manager' \
 --publish 5000:5000 registry:2
