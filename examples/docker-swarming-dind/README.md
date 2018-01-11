# start a local docker swarming DinD


```
# use this at Docker for Mac
$ export DOCKER_ORCHESTRATOR=swarm
$ ./start-dind.sh
$ ./start-traefik.sh
$ ./start-whoami.sh
```

start dind at private network interface

```
$ ./start-dind.sh --advertise-addr 10.14.0.11
```

Lookup and scale

```
$ docker service update --replicas 2  whoami0
$ docker service scale whoami0=4 whoami1=3
$ curl -H Host:whoami0.traefik http://localhost
$ curl -H Host:whoami1.traefik http://localhost
```

stop the swarming DinD cluster

```
$ ./stop-dind.sh
```

## Links

* https://hub.docker.com/_/docker/
* https://github.com/swarmpit/swarmpit