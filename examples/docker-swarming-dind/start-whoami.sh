#!/bin/bash
docker service create \
    --name whoami0 \
    --label traefik.port=80 \
    --network traefik-net \
    emilevauge/whoami
docker service create \
    --name whoami1 \
    --label traefik.port=80 \
    --network traefik-net \
    emilevauge/whoami"
