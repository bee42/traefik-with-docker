# start a local docker swarming DinD


```
$ ./start-dind.sh
$ ./start-traefik.sh
$ ./start-whoami.sh
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
