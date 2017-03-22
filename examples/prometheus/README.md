# Prometheus Swarm

**Experiment**

More info available about this idea and its configuration you can find in this post [Docker Daemon Metrics in Prometheus](https://medium.com/@basilio.vera/docker-swarm-metrics-in-prometheus-e02a6a5745a#.ei8n7eykb)

A sample image that can be used as a base for collecting Swarm mode metrics in Prometheus

## How to use it

You can configure the full system with the next commands, that create the Prometheus, Grafana and exporters services needed.

Please add your Slack Token!

__ToDo__: check running and setup slack Token

```
$ ./build.sh
$ docker-compose build
$ docker-compose push
$ GF_PASSWORD=12345678 SLACK_TOKEN=xxx docker stack deploy --compose-file docker-compose.yml prometheus
$ docker service ls
```
If your need a attachable network it is currently not supported by docker-compose use an external network

* http://blog.alexellis.io/docker-stacks-attachable-networks/

Once everyting is running you just need to connect to grafana and import the [Docker Swarm & Container Overview](https://grafana.net/dashboards/609)

__ToDo__: remove Elasticsearch dependency

In case you don't have an Elasticsearch instance with logs and errors you could provide an invalid configuration. But I suggest you to have it correctly configured to get all the dashboard offers.

### Docker Engine Metrics

In case you have activated the metrics endpoint in your docker swarm cluster you could import the [Docker Engine Metrics](https://grafana.net/dashboards/1229) dashboard as well, which offers complementary data about the docker daemon itself.

## Setup Grafana

* https://github.com/grafana/grafana-docker
* https://grafana.net/plugins
* https://grafana.net/dashbords


```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  grafana/grafana
```

### Grafana Dashboards

| Link                               | description                                     |
|:-----------------------------------|:------------------------------------------------|
| https://grafana.net/dashboards/179 | Docker Basic dashbaord                          |
| https://grafana.net/dashboards/893 | This dashboard display Docker and system metric |

### Setup Grafana datasources

Use the grafana API to finish the setup!

* http://docs.grafana.org/reference/http_api/

ToDo:

* Check if datasoure available!
* Check first start, and only then configure!
* Setup this as start script
* Setup some default dashboards

```
echo 'Starting Grafana...'
/run.sh "$@" &
AddDataSource() {
  curl 'http://admin:${GF_SECURITY_ADMIN_PASSWORD}@127.0.0.1:3000/api/datasources' \
    -X POST \
    -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary \
    '{"name":"Prometheus","type":"prometheus","url":"http://prometheus:9090","access":"proxy","isDefault":true}'
}
until AddDataSource; do
  echo 'Configuring Grafana...'
  sleep 1
done
echo 'Done!'
wait
```

```

$ export GF_SECURITY_ADMIN_PASSWORD=12345678
$ mkdir -p dashboards
$ cd dashboards
$ curl "http://admin:${GF_SECURITY_ADMIN_PASSWORD}@127.0.0.1:3000/api/datasources" \
  -X POST \
  -H 'Content-Type: application/json;charset=UTF-8' \
  --data-binary \
  '{"name":"Prometheus","type":"prometheus","url":"http://prometheus:9090","access":"proxy","isDefault":true}'
$ curl -s https://grafana.net/api/dashboards/179/revisions/5/download >179.dashboard
$ vi 179.dashboard
# Add {"dashboard": {...}, "overwrite":false}
# replace ${DS_PROMETHEUS} with Prometheus
$ curl "http://admin:${GF_SECURITY_ADMIN_PASSWORD}@127.0.0.1:3000/api/dashboards/db" \
  -X POST \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -d @179.dashboard
```

__Warning__: Adjust Timeslot of dashboard to 2h!

The time between the dashboard user and the container / host appears to be different.

### Monitoring the Rate, Error and Duration of every service

* https://www.weave.works/prometheus-and-kubernetes-monitoring-your-applications/
  * PROM QL queries
  * Alertrules
  * Scraping from kubernetes service

* https://github.com/weaveworks/grafanalib
  * Generation of Grafana dashboards
  * RED Method

* http://www.brendangregg.com/usemethod.html

![](images/usemethod_flow.png)

## Prometheus

### cli

* https://github.com/prometheus-junkyard/prometheus_cli

__Warning__
```
$ docker run --rm -ti --network monitoring prom/prometheus-cli -server="http://prometheus:9090" metrics
```

## Links

* https://github.com/bvis/docker-node-exporter
* https://github.com/bvis/docker-prometheus-swarm
