#!/bin/bash

# create traefik-net network
: NETWORK=${NETWORK:=traefik-net}
if [ ! "$(docker network ls --filter name=$NETWORK -q)" ];then
  docker network create --driver=overlay --attachable $NETWORK
fi

if [ ! "$(docker service ls --filter name=traefik -q)" ];then
# 1.2 feature
#    --web.metrics.prometheus \
#    --web.metrics.prometheus.buckets="100,300"

  docker service create \
    --name traefik \
    --constraint=node.role==manager \
    --publish 80:80 \
    --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --network ${NETWORK} \
   traefik:v1.3.1 \
     --accesslogsfile=/access.log \
     --checknewversion=false \
     --web \
     --web.metrics.prometheus \
     --web.metrics.prometheus.buckets="100,300" \
    --docker \
    --docker.exposedbydefault=false \
    --docker.swarmmode=true \
    --docker.domain=traefik \
    --docker.watch
fi
