#!/bin/bash

set -e

: NETWORK=${NETWORK:=monitoring}
if [ ! "$(docker network ls --filter name=${NETWORK} -q)" ];then
  echo "create overlay swarm network ${NETWORK}"
  docker network create --driver=overlay --attachable ${NETWORK}
fi

if [ ! "$(docker service ls --filter name=cadvisor -q)" ];then
  echo "start service cadvisor at network ${NETWORK}"
  docker \
    service create --name cadvisor \
    --mode global \
    --network ${NETWORK} \
    --constraint node.role==worker \
    --label com.docker.stack.namespace=${NETWORK} \
    --container-label com.docker.stack.namespace=${NETWORK} \
    --mount type=bind,src=/,dst=/rootfs:ro \
    --mount type=bind,src=/var/run,dst=/var/run:rw \
    --mount type=bind,src=/sys,dst=/sys:ro \
    --mount type=bind,src=/var/lib/docker/,dst=/var/lib/docker:ro \
    google/cadvisor:v0.24.1
fi

if [ ! "$(docker service ls --filter name=node-exporter -q)" ];then
  echo "start service node-exporter at network ${NETWORK}"
  docker \
    service create --name node-exporter \
    --mode global \
    --network ${NETWORK} \
    --constraint node.role==worker \
    --label com.docker.stack.namespace=${NETWORK} \
    --container-label com.docker.stack.namespace=${NETWORK} \
    --mount type=bind,source=/proc,target=/host/proc \
    --mount type=bind,source=/sys,target=/host/sys \
    --mount type=bind,source=/,target=/rootfs \
    --mount type=bind,source=/etc/hostname,target=/etc/host_hostname \
    -e HOST_HOSTNAME=/etc/host_hostname \
    basi/node-exporter \
    -collector.procfs /host/proc \
    -collector.sysfs /host/sys \
    -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)" \
    --collector.textfile.directory /etc/node-exporter/ \
    --collectors.enabled="conntrack,diskstats,entropy,filefd,filesystem,loadavg,mdadm,meminfo,netdev,netstat,stat,textfile,time,vmstat,ipvs"
fi

if [ ! "$(docker service ls --filter name=alertmanager -q)" ];then
  echo "start service alertmanager at network ${NETWORK}"
  docker \
    service create --name alertmanager \
    --network ${NETWORK} \
    --label com.docker.stack.namespace=${NETWORK} \
    --container-label com.docker.stack.namespace=${NETWORK} \
    --publish 9093:9093 \
    --constraint node.role==manager \
    -e "SLACK_API=https://hooks.slack.com/services/${SLACK_TOKEN}" \
    basi/alertmanager \
      -config.file=/etc/alertmanager/config.yml
fi

if [ ! "$(docker service ls --filter name=prometheus -q)" ];then
  echo "start service prometheus at network ${NETWORK}"
  docker \
    service create \
    --name prometheus \
    --network ${NETWORK} \
    --label com.docker.stack.namespace=${NETWORK} \
    --container-label com.docker.stack.namespace=${NETWORK} \
    --constraint node.role==manager \
    --publish 9090:9090 \
    127.0.0.1:5000/bee42/prometheus \
      -config.file=/etc/prometheus/prometheus.yml \
      -storage.local.path=/prometheus \
      -web.console.libraries=/etc/prometheus/console_libraries \
      -web.console.templates=/etc/prometheus/consoles \
      -alertmanager.url=http://alertmanager:9093
fi

if [ ! "$(docker service ls --filter name=grafana -q)" ];then
  echo "start service grafana at network ${NETWORK}"
  docker \
    service create \
    --name grafana \
    --network ${NETWORK} \
    --label com.docker.stack.namespace=${NETWORK} \
    --container-label com.docker.stack.namespace=${NETWORK} \
    --constraint node.role==manager \
    --publish 3000:3000 \
    -e "GF_SERVER_ROOT_URL=http://grafana" \
    -e "GF_SECURITY_ADMIN_PASSWORD=$GF_PASSWORD" \
    -e "PROMETHEUS_ENDPOINT=http://prometheus:9090" \
    basi/grafana
fi
