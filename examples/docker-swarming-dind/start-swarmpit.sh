#!/bin/bash

set -e -x
export DOCKER_ORCHESTRATOR=swarm
if [ ! "$(docker service ls --filter name=swarmpit_app -q)" ];then
  docker stack deploy -c docker-compose-stack-swarmpit.yml swarmpit
fi
