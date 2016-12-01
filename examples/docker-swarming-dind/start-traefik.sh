#!/bin/bash

docker network create --driver=overlay traefik-net"
docker service create \
  --name traefik \
  --constraint=node.role==manager \
  --publish 80:80 \
  --publish 8080:8080 \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  --network traefik-net \
  traefik:v1.1.0 \
  --docker \
  --docker.swarmmode \
  --docker.domain=traefik \
  --docker.watch \
  --web"
