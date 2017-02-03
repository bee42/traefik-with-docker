#!/bin/bash

# create traefik-net network
network=traefik-net
if [ ! "$(docker network ls --filter name=$network -q)" ];then
  docker network create --driver=overlay --attachable $network
fi

if [ ! "$(docker service ls --filter name=traefik -q)" ];then
  docker service create \
    --name traefik \
    --constraint=node.role==manager \
    --publish 80:80 \
    --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --network $network \
   traefik:v1.1.2 \
    --docker \
    --docker.swarmmode \
    --docker.domain=traefik \
    --docker.watch \
    --web
fi
