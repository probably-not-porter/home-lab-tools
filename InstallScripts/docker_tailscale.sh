#!/bin/bash
# Install tailscale docker
mkdir /var/lib/tailscale

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
  --env TS_AUTHKEY=GET_KEY_FROM_TAILSCALE \
  --env TS_EXTRA_ARGS=--advertise-exit-node \
  --env TS_ROUTES=192.168.0.0/24 \
  tailscale/tailscale
