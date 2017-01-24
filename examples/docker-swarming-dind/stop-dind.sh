#!/bin/bash
set -e -x

: NUM_WORKERS=${NUM_WORKERS:=3}

if [ ! -z "$1" ] ; then
  NUM_WORKERS=$1
fi

for WORKER_NUMBER in $(seq ${NUM_WORKERS}); do
    docker exec -ti worker-${WORKER_NUMBER} docker swarm leave
    docker rm -f worker-${WORKER_NUMBER}
done

docker service rm registry_mirror
docker service rm registry
docker rm -f visualizer
docker swarm leave -f
