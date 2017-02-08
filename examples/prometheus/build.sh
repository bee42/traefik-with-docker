#!/bin/bash
IMAGE=prometheus
ACCOUNT=127.0.0.1:5000/bee42
TAG_LONG=0.1.0

DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`

docker build \
 -f Dockerfile \
 --build-arg BUILD_DATE=$DATE \
 --build-arg VCS_REF=`git rev-parse --short HEAD` \
 --build-arg VERSION=$(git describe --tags) \
 --build-arg VCS_URL=$(git config --get remote.origin.url) \
 --build-arg VCS_BRANCH=$(git rev-parse --abbrev-ref HEAD) \
 -t="${ACCOUNT}/$IMAGE" \
 -t="${ACCOUNT}/$IMAGE-$DATE" \
 -t="${ACCOUNT}/$IMAGE-$TAG_LONG" \
 .
