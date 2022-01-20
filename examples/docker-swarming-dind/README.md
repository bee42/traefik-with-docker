# start a local docker swarming DinD


```
# use this at Docker for Mac
# docker <= 18.09
# export DOCKER_ORCHESTRATOR=swarm
$ export DOCKER_STACK_ORCHESTRATOR=swarm
$ docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "59eb10f40b080bfc9a124092e20be0136d26a8c74bd3eb4be078332a012c1634",
        "Created": "2019-10-18T07:36:26.009159148Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
...
# <net work Gateway ip addrs bridge network>
$ export GATEWAY_IP=$(docker network inspect bridge |jq -r '.[] | .IPAM.Config|.[0].Gateway')
$ ./start-dind.sh --advertise-addr $GATEWAY_IP
$ ./start-traefik.sh
$ ./start-whoami.sh
```

start dind at private network interface

```shell
$ ./start-dind.sh --advertise-addr 10.14.0.11
```

Lookup and scale

```shell
$ docker service update --replicas 2  whoami1
$ docker service scale whoami1=3
$ curl -H Host:whoami1.traefik http://localhost
$ curl -H Host:whoami1.traefik http://localhost
```

stop the swarming DinD cluster

```
$ ./stop-dind.sh
```

## Links

* https://hub.docker.com/_/docker/
* https://github.com/swarmpit/swarmpit