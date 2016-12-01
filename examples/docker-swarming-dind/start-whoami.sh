#!/bin/bash
SERVICES_COUNT=$1
for i in $(seq $SERVICES_COUNT); do
docker service create \
    --name whoami${i} \
    --label traefik.port=80 \
    --network traefik-net \
    emilevauge/whoami
done
