#!/bin/bash
# Install dashy docker container on Grayling, port 80
docker run -d \
 -p 80:80 \
 -v /var/run/docker.sock:/tmp/docker.sock:ro \
 --name nginx \
 --restart=always \
 jwilder/nginx-proxy