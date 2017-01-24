#!/bin/sh

docker build -t 127.0.0.1:5000/bee42/drill .
docker push 127.0.0.1:5000/bee42/drill

