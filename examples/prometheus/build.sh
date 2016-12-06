#!/bin/bash

docker build -t 127.0.0.1:5000/prometheus .
docker push 127.0.0.1:5000/prometheus
