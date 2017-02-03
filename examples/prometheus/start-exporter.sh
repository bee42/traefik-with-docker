#!/bin/bash
set -e

network=prometheus
if [ ! "$(docker network ls --filter name=$network -q)" ];then
  docker network create --driver=overlay --attachable $network
fi

# pull image if not available
for image in "prom/node-exporter google/cadvisor:latest"; do
  if [ ! "$(docker images -q $image)" ];then
    docker pull $image
    docker tag $image 127.0.0.1:5000/$image
    docker push 127.0.0.1:5000/$image
  fi
done

if [ ! "$(docker service ls --filter name=node-exporter -q)" ];then

  docker service create --name node-exporter \
    --mode global \
    --network $network \
    --mount type=bind,source=/proc,target=/host/proc \
    --mount type=bind,source=/sys,target=/host/sys \
    --mount type=bind,source=/,target=/rootfs \
    127.0.0.1:5000/prom/node-exporter \
      -collector.procfs /host/proc \
      -collector.sysfs /host/proc \
      -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"
fi

if [ ! "$(docker service ls --filter name=cadvisor -q)" ];then

  docker service create --name cadvisor \
    --network $network
    --mode global \
    --mount type=bind,source=/,target=/rootfs \
    --mount type=bind,source=/var/run,target=/var/run \
    --mount type=bind,source=/sys,target=/sys \
    --mount type=bind,source=/var/lib/docker,target=/var/lib/docker \
    127.0.0.1:5000/google/cadvisor:latest
fi
