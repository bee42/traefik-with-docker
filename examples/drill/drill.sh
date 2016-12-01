#!/bin/bash

docker service create --network traefik-net --name debug --mode global \
       bee42/drill sleep 1000000000
CID=$(docker ps -q --filter label=com.docker.swarm.service.name=debug)
docker exec -ti $CID sh
 
