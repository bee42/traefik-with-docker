#!/bin/bash

set -e -x

# create traefik-net network
network=traefik-net
if [ ! "$(docker network ls --filter name=$network -q)" ];then
    docker network --driver=overlay create $network
fi

docker pull emilevauge/whoami
docker tag emilevauge/whoami 127.0.0.1:5000/emilevauge/whoami
docker push 127.0.0.1:5000/emilevauge/whoami

: SERVICES_COUNT=${SERVICES_COUNT:=1}

if [ ! -z "$1" ] ; then
  SERVICES_COUNT=$1
fi

for i in $(seq $SERVICES_COUNT); do
docker service create \
    --name whoami${i} \
    --label traefik.port=80 \
    --network $network \
   127.0.0.1:5000/emilevauge/whoami
done
