#!/bin/bash
DATE=`date +'%Y%m%d%H%M'`
ACCOUNT=infrabricks
DECK=traefik-with-docker
EDITION_TAG=docker-meetup-bochum_2016-12
if [ ! "x" == "x`docker ps -a | grep $DECK`" ]; then
  docker rm $DECK
fi

mkdir -p build
PWD=`pwd`
mkdir -p build/md
cp slides.md build/md
docker run -ti --rm -v $PWD/images:/opt/presentation/images -v  $PWD/build/md:/opt/presentation/lib/md -v $PWD/build:/build -p 8000:8000 rossbachp/presentation /bin/bash -c "grunt package && mv reveal-js-presentation.zip /build/$DECK.zip"
cd build
mkdir -p $DECK
cd $DECK
#you must have zip installed - apt-get install -y zip
unzip ../$DECK.zip
cd ..
tar czf slidefire.tar.gz $DECK
rm -rf build/$DECK.zip
rm -rf build/$DECK
rm -rf build/md

COPYDATE=`date +'%Y'`
cp ../LICENSE LICENSE
cat <<EOT >Dockerfile
FROM rossbachp/slidefire
MAINTAINER Peter Rossbach <peter.rossbach@bee42.com>
ADD LICENSE /etc/LICENSE
RUN echo "slidefire" >/etc/provisioned && date >>/etc/provisioned && echo >>/etc/provisioned && echo " Copyright ${COPYDATE} by <peter.rossbach@bee42.com> bee42 solutions gmbh" >>/etc/provisioned
EOT
cat >.dockerignore <<EOF
*.pdf
*.pdf_original
.DS_Store
EOF
docker build -t=$ACCOUNT/$DECK .
docker tag $ACCOUNT/$DECK $ACCOUNT/$DECK:$EDITION_TAG
docker tag $ACCOUNT/$DECK $ACCOUNT/$DECK:$DATE
