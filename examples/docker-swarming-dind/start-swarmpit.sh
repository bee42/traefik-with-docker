#!/bin/bash

set -e -x
DOCKER_ORCHESTRATOR=swarm
if [ ! "$(docker service ls --filter name=swarmpit_app -q)" ];then
  if [ ! -d swarmpit ]; then
    git clone https://github.com/swarmpit/swarmpit
  fi
  docker stack deploy -c swarmpit/docker-compose.yml swarmpit
fi
