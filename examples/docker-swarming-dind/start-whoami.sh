#!/bin/bash

set -e -x

# create traefik-net network

: NETWORK=${NETWORK:=traefik-net}
if [ ! "$(docker network ls --filter name=$NETWORK -q)" ];then
  docker network create --driver=overlay --attachable $NETWORK
fi


# pull image if not available
whoami=bee42/whoami:2.1.0
#if [ ! "$(docker images -q 127.0.0.1:5000/$whoami)" ];then
#  docker pull $whoami
#  docker tag $whoami 127.0.0.1:5000/$whoami
#  docker push 127.0.0.1:5000/$whoami
#fi

: SERVICES_COUNT=${SERVICES_COUNT:=1}

if [ ! -z "$1" ] ; then
  SERVICES_COUNT=$1
fi

for i in $(seq $SERVICES_COUNT); do
  if [ ! "$(docker service ls --filter name=whoami${i} -q)" ];then
    docker service create \
      --name whoami${i} \
      --label orbiter=true \
      --label traefik.port=80 \
      --label traefik.enable=true \
      --label traefik.backend.loadbalancer.method=drr \
      --network $NETWORK \
     $whoami
  fi
done
