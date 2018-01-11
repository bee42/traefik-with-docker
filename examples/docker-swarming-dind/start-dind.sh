#!/bin/bash
set -e -x
export DOCKER_ORCHESTRATOR=swarm
DOCKER_WORKER_VERSION="17.12.0-ce-dind"

if [ "$(docker info --format '{{ json .Swarm }}' |jq '.NodeID')" == "\"\"" ];then
  docker swarm init $@
fi

SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER=$(docker info | grep -w 'Node Address' | awk '{print $3}')
: NUM_WORKERS=${NUM_WORKERS:=3}

mkdir -p $PWD/rdata

if [ ! "$(docker service ls --filter name=mirror_registry -q)" ];then
  docker service create --name mirror_registry \
   --detach=true \
   --constraint 'node.role == manager' \
   --mount type=bind,source=$PWD/rdata,target=/var/lib/registry \
   -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
   --publish 5001:5000 \
   registry:2

  sleep 5
fi

echo "Start swarm worker"

for WORKER_NUMBER in $(seq ${NUM_WORKERS}); do
  if [ ! "$(docker ps --filter name=worker-${WORKER_NUMBER} -q)" ];then
    docker run -d --privileged --name worker-${WORKER_NUMBER} \
      --hostname=worker-${WORKER_NUMBER} \
      -p ${WORKER_NUMBER}2375:2375 \
      docker:${DOCKER_WORKER_VERSION} \
      --storage-driver=overlay2 \
      --registry-mirror http://127.0.0.1:5001 \
      --metrics-addr 0.0.0.0:4999 \
      --experimental
    sleep 2
    docker --host=127.0.0.1:${WORKER_NUMBER}2375 swarm join \
      --token ${SWARM_TOKEN} \
      ${SWARM_MASTER}:2377
  fi
done

if [ ! "$(docker ps  --filter name=visualizer -q)" ];then
  docker run -it -d \
    -p 5080:8080 \
    --name visualizer  \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
     dockersamples/visualizer
fi

if [ ! "$(docker service ls --filter name=registry -q)" ];then
  docker service create --name registry \
    --detach=true \
    --constraint 'node.role == manager' \
    --publish 5000:5000 registry:2
fi
