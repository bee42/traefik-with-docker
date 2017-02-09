#!/bin/bash

set -e

: NETWORK=${NETWORK:=prometheus}
if [ ! "$(docker network ls --filter name=$NETWORK -q)" ];then
  docker network create --driver=overlay --attachable $network
fi

if [ ! "$(docker service ls --filter name=prometheus -q)" ];then
  docker service create --network $NETWORK --name prometheus \
    --constraint=node.role==manager \
    --publish 9090:9090 \
    127.0.0.1:5000/bee42/prometheus
fi
