#!/bin/bash
TAG=docker-meetup-bochum_2016-12
CID=$1
LOCATION="Docker Meetup Bochum 12/2016"
TITLE="Traefik wiht Docker"
docker exec -ti ${CID} /bin/bash -c "cd print ; ./print.sh /build/traefik_with_docker-${TAG}-PeterRossbach.pdf '${LOCATION}'"
docker exec -ti ${CID} /bin/bash -c "cd print ; ./exif.sh /build/traefik_with_docker-${TAG}-PeterRossbach.pdf '${TITLE}'"
