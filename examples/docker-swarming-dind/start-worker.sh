#!/bin/bash

set -e -x

if [ ! -z "$1" ] ; then
  WORKER_NUMBER=$1
else
  echo "usage: $0 <number of new worker node"
  exit 1
fi

SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER=$(docker info | grep -w 'Node Address' | awk '{print $3}')

docker run -d --privileged --name worker-${WORKER_NUMBER} \
  --hostname=worker-${WORKER_NUMBER} \
  -p ${WORKER_NUMBER}2375:2375 docker:1.13.0-rc2-dind
docker --host=localhost:${WORKER_NUMBER}2375 swarm join \
  --token ${SWARM_TOKEN} \
  ${SWARM_MASTER}:2377

exit 0
