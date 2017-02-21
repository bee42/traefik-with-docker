# check

```
$ echo "bee42" | docker secret create my_secret -
$ docker stack deploy --compose-file=docker-compose.yml ìndex
$ docker exec -ti index.1.xxx /bin/sh
> cd /run/secrets/
> ls
my_secret
>  cat my_secret
bee42
> exit
```
