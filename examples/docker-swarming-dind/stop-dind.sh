#!/bin/bash
set -e -x
DOCKER_ORCHESTRATOR=swarm
: NUM_WORKERS=${NUM_WORKERS:=3}

if [ ! -z "$1" ] ; then
  NUM_WORKERS=$1
fi

for WORKER_NUMBER in $(seq ${NUM_WORKERS}); do
  if [ "$(docker ps -a --filter name=worker-${WORKER_NUMBER} -q)" ];then
    docker exec -ti worker-${WORKER_NUMBER} docker swarm leave
    sleep 3
    docker rm -f worker-${WORKER_NUMBER}
  fi
done

if [ "$(docker service ls --filter name=mirror_registry -q)" ];then
  docker service rm mirror_registry
fi

if [ "$(docker service ls --filter name=registry -q)" ];then
  docker service rm registry
fi

if [ "$(docker service ls --filter name=swarmpit_app -q)" ];then
  docker stack rm swarmpit
fi

if [ "$(docker ps --filter name=portainer -q)" ];then
  docker rm -f portainer
fi

if [ "$(docker ps --filter name=visualizer -q)" ];then
  docker rm -f visualizer
fi

sleep 5
docker swarm leave -f
