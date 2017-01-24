#!/bin/bash
set -e -x

docker swarm init $1
SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER=$(docker info | grep -w 'Node Address' | awk '{print $3}')
: NUM_WORKERS=${NUM_WORKERS:=3}

if [ ! -z "$2" ] ; then
  NUM_WORKERS=$2
fi

mkdir -p $PWD/rdata

docker service create --name registry_mirror \
 --constraint 'node.role == manager' \
 --mount type=bind,source=$PWD/rdata,target=/var/lib/registry \
 -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
 --publish 5001:5000 \
 registry:2

sleep 5

echo "Start swarm worker"

for WORKER_NUMBER in $(seq ${NUM_WORKERS}); do
    docker run -d --privileged --name worker-${WORKER_NUMBER} \
      --hostname=worker-${WORKER_NUMBER} \
      -p ${WORKER_NUMBER}2375:2375 \
      docker:1.13.0-dind \
      --registry-mirror http://127.0.0.1:5001
    sleep 2
    docker --host=127.0.0.1:${WORKER_NUMBER}2375 swarm join \
      --token ${SWARM_TOKEN} \
      ${SWARM_MASTER}:2377
done

docker run -it -d -p 5080:8080 --name visualizer  \
-v /var/run/docker.sock:/var/run/docker.sock \
manomarks/visualizer

docker service create --name registry \
 --constraint 'node.role == manager' \
 --publish 5000:5000 registry:2
