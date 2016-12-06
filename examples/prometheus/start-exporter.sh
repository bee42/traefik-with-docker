#!/bin/bash
set -e

docker pull prom/node-exporter
docker pull prom/google/cadvisor:latest
docker tag prom/node-exporter \
 127.0.0.1:5000/prom/node-exporter
docker tag prom/google/cadvisor:latest \
 127.0.0.1:5000/prom/google/cadvisor:latest

docker service create --name node --mode global --network prometheus \
 --mount type=bind,source=/proc,target=/host/proc \
 --mount type=bind,source=/sys,target=/host/sys \
 --mount type=bind,source=/,target=/rootfs \
 127.0.0.1:5000/prom/node-exporter \
  -collector.procfs /host/proc \
  -collector.sysfs /host/proc \
  -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"

docker service create --name cadvisor --network prometheus --mode global \
  --mount type=bind,source=/,target=/rootfs \
  --mount type=bind,source=/var/run,target=/var/run \
  --mount type=bind,source=/sys,target=/sys \
  --mount type=bind,source=/var/lib/docker,target=/var/lib/docker \
  127.0.0.1:5000/google/cadvisor:latest
