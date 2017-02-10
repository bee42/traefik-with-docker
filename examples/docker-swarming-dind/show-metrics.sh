#!/bin/bash
docker run --rm --network=host alpine   sh -c 'apk add --no-cache -q curl && curl localhost:4999/metrics'
