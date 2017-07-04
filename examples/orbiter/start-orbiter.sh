#!/bin/bash
set -e -x

if [ ! "$(docker ps  --filter name=orbiter -q)" ];then
  docker run -d -it --name orbiter \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ${PWD}/orbiter.yml:/etc/orbiter.yml \
    -p 8000:8000 gianarb/orbiter daemon
fi


