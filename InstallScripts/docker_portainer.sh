#!/bin/bash
# Install portainer docker container on Grayling, port 4304

docker run -d \
  -e VIRTUAL_HOST=portainer.grayling.home \
  -e VIRTUAL_PORT=9000 \
  -p 4304:9000 \
  -p 8000:8000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data portainer/portainer-ce:latest \