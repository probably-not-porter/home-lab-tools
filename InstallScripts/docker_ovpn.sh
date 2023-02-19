#!/bin/bash
# Install OVPN server on Grayling, port 4310
docker run -d \
 --cap-add=NET_ADMIN \
 -p 4310:1194/udp \
 -p 9099:8080/tcp \
 -e HOST_ADDR=$(curl -s https://api.ipify.org) \
 --name ovpn \
 --restart=always \
 alekslitvinenk/openvpn