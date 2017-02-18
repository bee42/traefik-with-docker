#!/bin/bash

set -e

: NETWORK=${NETWORK:=monitoring}

if [ "$(docker service ls --filter name=grafana -q)" ];then
  echo "remove service grafana at network ${NETWORK}"
  docker service rm grafana
fi

if [ "$(docker service ls --filter name=alertmanager -q)" ];then
  echo "remove service alertmanager at network ${NETWORK}"
  docker service rm alertmanager
fi

if [ "$(docker service ls --filter name=prometheus -q)" ];then
  echo "remove service prometheus at network ${NETWORK}"
  docker service rm prometheus
fi

if [ "$(docker service ls --filter name=node-exporter -q)" ];then
  echo "remove service node-exporter at network ${NETWORK}"
  docker service rm node-exporter
fi

if [ "$(docker service ls --filter name=cadvisor -q)" ];then
  echo "remove service cadvisor at network ${NETWORK}"
  docker service rm cadvisor
fi

if [ "$(docker network ls --filter name=${NETWORK} -q)" ];then
  echo "remove overlay swarm network ${NETWORK}"
  docker network rm  ${NETWORK}
fi
