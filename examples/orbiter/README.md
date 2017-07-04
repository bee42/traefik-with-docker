# Start orbiter to scale up and down

```
$ docker service create --name whoami --label orbiter=true emilevauge/whoami
$ ./start-orbiter.sh
$ curl -v -X POST http://127.0.0.1:8000/handle/autodetect_swarm/whoami/up
$ docker service ls
b0fdp2ty71co        whoami              replicated          2/2
$ curl -v -X POST http://127.0.0.1:8000/handle/autodetect_swarm/whoami/down              

```

## Links

* https://github.com/gianarb/orbiter

