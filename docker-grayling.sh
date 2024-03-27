#!/bin/bash
# Reset all containers on grayling

# ========== SETTINGS ============ #
DASHY_PORT=4301
DASHY_HOST="dash.grayling.home"

PROMETHEUS_PORT=4302
PROMETHEUS_HOST="prometheus.grayling.home"

GRAFANA_PORT=4303
GRAFANA_HOST="grafana.grayling.home"

PORTAINER_PORT=4304
PORTAINER_HOST="portainer.grayling.home"
# ================================ #

# Stop and remove all containers
docker ps -aq | xargs docker stop | xargs docker rm

# Nginx Proxy
docker run -d \
  -p 80:80 \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  --name nginx-proxy \
  --restart=always \
  jwilder/nginx-proxy

# Tailscale
mkdir /var/lib/tailscale # create directory
sudo docker run \
  -d \
  --name=tailscaled \
  -v /var/lib:/var/lib \
  -v /dev/net/tun:/dev/net/tun \
  -v /var/lib/tailscale:/var/lib/tailscale \
  -e TS_STATE_DIR=/var/lib/tailscale \
  --network=host \
  --cap-add=NET_ADMIN \
  --restart unless-stopped \
  --cap-add=NET_RAW \
  --env TS_AUTHKEY=$TAILSCALE_KEY \
  --env TS_EXTRA_ARGS=--advertise-exit-node \
  --env TS_ROUTES=192.168.0.0/24 \
  tailscale/tailscale

# Dashy
mkdir /etc/dashy/ # create directory
docker run -d \
  -e VIRTUAL_HOST=$DASHY_HOST \
  -p $DASHY_PORT:80 \
  -v /etc/dashy/dashy.yml:/app/public/conf.yml \
  --name dashy \
  --restart=always \
  lissy93/dashy:latest

# Prometheus
mkdir /etc/prometheus/ # create directory
docker run -d \
    -e VIRTUAL_HOST=$PROMETHEUS_HOST \
    -p $PROMETHEUS_PORT:9090 \
    -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
    --name prometheus \
    --restart=always \
    prom/prometheus

# Grafana
docker run -d \
  -p $GRAFANA_PORT:3000 \
  --name=grafana \
  -e "VIRTUAL_HOST=$GRAFANA_HOST,GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  --name grafana \
  --restart=always \
  grafana/grafana-enterprise

# portainer
docker run -d \
  -e VIRTUAL_HOST=$PORTAINER_HOST \
  -e VIRTUAL_PORT=9000 \
  -p $PORTAINER_PORT:9000 \
  -p 8000:8000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data portainer/portainer-ce:latest \
