#!/bin/bash

set -e
docker network create --driver=overlay prometheus 
docker service create --network prom --name prometheus \
       --publish 9090:9090 127.0.0.1:5000/prometheus

