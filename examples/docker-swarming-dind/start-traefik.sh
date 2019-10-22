#!/bin/bash

# create traefik-net network
: NETWORK=${NETWORK:=traefik-net}
if [ ! "$(docker network ls --filter name=$NETWORK -q)" ];then
  docker network create --driver=overlay --attachable $NETWORK
fi

if [ ! "$(docker service ls --filter name=traefik -q)" ];then

  docker service create \
    --name traefik \
    --constraint=node.role==manager \
    --publish 80:80 \
    --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --network ${NETWORK} \
   traefik:v1.7.18 \
     --accesslogsfile=/access.log \
     --checknewversion=false \
     --api.dashboard=true \
     --metrics.prometheus \
     --metrics.prometheus.buckets= [0.1,0.3,1.2,5.0] \
    --docker \
    --docker.exposedbydefault=false \
    --docker.swarmmode=true \
    --docker.domain=traefik \
    --docker.watch
fi
