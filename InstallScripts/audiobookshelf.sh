#!/bin/bash
# Install dashy docker container on Logperch, port 4503

mkdir /etc/audiobookshelf
mkdir /etc/audiobookshelf/config
mkdir /etc/audiobookshelf/meta

docker run -d \
  -p 4503:80 \
  -e VIRTUAL_HOST=audiobookshelf.logperch.home \
  -v /etc/audiobookshelf/config:/config \
  -v /etc/audiobookshelf/meta:/metadata \
  -v /storage/media/audiobooks:/audiobooks \
  -v /storage/media/podcasts:/podcasts \
  --name audiobookshelf \
  -e TZ="America/Toronto" \
  ghcr.io/advplyr/audiobookshelf
