#!/bin/bash

set -e
docker run -it -d -p 5090:8080 -v /var/run/docker.sock:/var/run/docker.sock  julienbreux/docker-swarm-gui:latest

