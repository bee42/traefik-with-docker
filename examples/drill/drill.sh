#!/bin/bash

: NETWORK=${NETWORK:=traefik-net}
if [ ! "$(docker network ls --filter name=$NETWORK -q)" ];then
  docker network create --driver=overlay --attachable $NETWORK
fi

if [ ! $(docker ps -q --filter label=com.docker.swarm.service.name=debug-$NETWORK) ];then
  docker service create --network $NETWORK --name debug-$NETWORK --mode global \
       127.0.0.1:5000/bee42/drill sleep 1000000000
  sleep 2
fi

CID=$(docker ps -q --filter label=com.docker.swarm.service.name=debug-$NETWORK)
docker exec -ti $CID /bin/sh
