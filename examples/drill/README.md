debug

```
$ docker service create --network app --name debug --mode global \
       alpine sleep 1000000000
$ CID=$(docker ps -q --filter label=com.docker.swarm.service.name=debug)
$ docker exec -ti $CID sh
> apk add --update curl apache2-utils drill
> drill app2
> ping app2
> drill tasks.app2
```
