#!/bin/bash

docker service create --network traefik-net --name debug --mode global \
       127.0.0.1:5000/bee42/drill sleep 1000000000
CID=$(docker ps -q --filter label=com.docker.swarm.service.name=debug)
docker exec -ti $CID sh
 
