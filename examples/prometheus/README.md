# Prometheus Swarm

**Experiment**

More info available about this idea and its configuration you can find in this post [Docker Daemon Metrics in Prometheus](https://medium.com/@basilio.vera/docker-swarm-metrics-in-prometheus-e02a6a5745a#.ei8n7eykb)

A sample image that can be used as a base for collecting Swarm mode metrics in Prometheus

## How to use it

You can configure the full system with the next commands, that create the Prometheus, Grafana and exporters services needed.

Please add your Slack Token!

__ToDo__: check running and setup slack Token

```
$ docker stack deploy --compose-file docker-compose.yml
$ docker service ls
```

Once everyting is running you just need to connect to grafana and import the [Docker Swarm & Container Overview](https://grafana.net/dashboards/609)

__ToDo__: remove Elasticsearch dependency

In case you don't have an Elasticsearch instance with logs and errors you could provide an invalid configuration. But I suggest you to have it correctly configured to get all the dashboard offers.

### Docker Engine Metrics

In case you have activated the metrics endpoint in your docker swarm cluster you could import the [Docker Engine Metrics](https://grafana.net/dashboards/1229) dashboard as well, which offers complementary data about the docker daemon itself.



## Links

* https://github.com/bvis/docker-node-exporter
