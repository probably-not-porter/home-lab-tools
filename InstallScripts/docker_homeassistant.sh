#!/bin/bash
# Install home assistant docker container on Grayling, port 4308
mkdir /etc/homeassistant/

docker run -d \
  --name=homeassistant \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e VIRTUAL_HOST=assistant.grayling.home \
  -p 4308:8123 `#optional` \
  -v /etc/homeassistant:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/homeassistant:latest
