#!/bin/sh
CID=$(docker ps -q --filter label=com.docker.swarm.service.name=debug)
docker exec -ti $CID sh
