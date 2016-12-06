#!/bin/bash
docker service create \
    --name whoami \
    --label traefik.port=80 \
    --network traefik-net \
    127.0.0.1:5000/emilevauge/whoami"

