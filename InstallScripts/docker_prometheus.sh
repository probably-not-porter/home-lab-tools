#!/bin/bash
# Install prometheus docker container on Grayling, port 4302
mkdir /etc/prometheus/

docker run \
    -e VIRTUAL_HOST=prometheus.grayling.home \
    -p 4302:9090 \
    -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
    --name prometheus \
    --restart=always \
    prom/prometheus