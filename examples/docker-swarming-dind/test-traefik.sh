#!/bin/bash
RUNS=$1

for i in $(seq "$RUNS"); do
  echo "Test Rule for: whoami$i.traefik"
  curl -H "Host: whoami$i.traefik" http://127.0.0.1
  echo "================================"
done

