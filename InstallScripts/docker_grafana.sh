#!/bin/bash
# Install grafana docker container on Grayling, port 4303
docker run -d \
  -p 4303:3000 \
  --name=grafana \
  -e "VIRTUAL_HOST=grafana.grayling.home,GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  --name grafana \
  --restart=always \
  grafana/grafana-enterprise