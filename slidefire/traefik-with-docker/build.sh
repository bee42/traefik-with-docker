#!/bin/bash
DECK=traefik-with-docker
TAG=docker-meetup-bochum_2016-12
docker build -t="infrabricks/$DECK" .
DATE=`date +'%Y%m%d%H%M'`
ID=$(docker inspect -f "{{.Id}}" infrabricks/$DECK)
docker tag $ID infrabricks/$DECK:$DATE
docker tag $ID infrabricks/$DECK:$TAG
#docker push infrabricks/$DECK
