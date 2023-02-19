#!/bin/bash
# Install dashy docker container on Grayling, port 4301
mkdir /etc/dashy/

docker run -d \
  -e VIRTUAL_HOST=dash.grayling.home \
  -p 4301:80 \
  -v /etc/dashy/dashy.yml:/app/public/conf.yml \
  --name dashy \
  --restart=always \
  lissy93/dashy:latest