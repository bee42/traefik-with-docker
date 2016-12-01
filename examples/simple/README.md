# Træfɪk

start this simple traefik docker loadbalancer example

```
$ docker-compose up -d
$ curl -L -H Host:whoami.docker.localhost http://localhost
$ docker-compose scale whoami=3
$ curl -L -H Host:whoami.docker.localhost http://localhost
$ curl -L -H Host:whoami.docker.localhost http://localhost
$ docker-compose down
```
