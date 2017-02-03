#!/bin/bash

set -e -x

if [ ! "$(docker ps --filter name=portainer -q)" ];then
  docker run -d -p 9000:9000 \
    --name portainer \
    -v /var/run/docker.sock:/var/run/docker.sock  \
   portainer/portainer
fi
