#!/bin/bash
# Reset all containers on logperch

# ========== SETTINGS ============ #
JELLYFIN_PORT=4501
JELLYFIN_HOST="jellyfin.logperch.home"

AUDIOBOOKSHELF_PORT=4502
AUDIOBOOKSHELF_HOST="audiobookshelf.logperch.home"

#READARR_PORT=4503
#READARR_HOST="readarr.logperch.home"

#RADARR_PORT=4504
#RADARR_HOST="radarr.logperch.home"

#SONARR_PORT=4505
#SONARR_HOST="sonarr.logperch.home"

#NZBGET_PORT=4506
#NZBGET_HOST="nzbget.logperch.home"

KIWIX_PORT=4507
KIWIX_HOST="kiwix.logperch.home"

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

# Portainer Agent
docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest

# Audiobookshelf
mkdir /etc/audiobookshelf # create directory
mkdir /etc/audiobookshelf/config
mkdir /etc/audiobookshelf/meta
docker run -d \
  -p $AUDIOBOOKSHELF_PORT:80 \
  -e VIRTUAL_HOST=$AUDIOBOOKSHELF_HOST \
  -v /etc/audiobookshelf/config:/config \
  -v /etc/audiobookshelf/meta:/metadata \
  -v /storage/media/audiobooks:/audiobooks \
  -v /storage/media/podcasts:/podcasts \
  -v /storage/media/books:/books \
  --name audiobookshelf \
  -e TZ="America/Toronto" \
  ghcr.io/advplyr/audiobookshelf

# Jellyfin
mkdir /etc/jellyfin # create directory
mkdir /etc/jellyfin/config
mkdir /var/jellyfin/cache
docker run -d \
  --name jellyfin \
  -p $JELLYFIN_PORT:8096 \
  -e VIRTUAL_HOST=$JELLYFIN_HOST \
  --volume /etc/jellyfin/config:/config \
  --volume /var/jellyfin/cache:/cache \
  --mount type=bind,source=/storage/media,target=/media \
  --restart=unless-stopped \
  jellyfin/jellyfin

# NZBGet
#mkdir /etc/nzbget # create directory
#docker run -d \
#  --name=nzbget \
#  -e PUID=1000 \
#  -e PGID=1000 \
#  -e TZ=Europe/London \
#  -e VIRTUAL_HOST=$NZBGET_HOST \
#  -e NZBGET_USER=porter `#optional` \
#  -e NZBGET_PASS=nzb123 `#optional` \
#  -p $NZBGET_PORT:6789 \
#  -v /etc/nzbget:/config \
#  -v /storage/downloads:/downloads `#optional` \
#  --restart unless-stopped \
#  lscr.io/linuxserver/nzbget:latest

# Readarr
# mkdir /etc/readarr # create directory
# docker run -d \
#   --name=readarr \
#   -e PUID=1000 \
#   -e PGID=1000 \
#   -e TZ=Europe/London \
#   -e VIRTUAL_HOST=$READARR_HOST \
#   -p $READARR_PORT:8787 \
#   -v /etc/readarr:/config \
#   -v /storage/media/books:/books `#optional` \
#   -v /storage/downloads:/downloads `#optional` \
#   --restart unless-stopped \
#   lscr.io/linuxserver/readarr:develop

# Sonarr
# mkdir /etc/sonarr # create directory
# docker run -d \
#   --name=sonarr \
#   -e PUID=1000 \
#   -e PGID=1000 \
#   -e TZ=Etc/UTC \
#   -p $SONARR_PORT:8989 \
#   -e VIRTUAL_HOST=$SONARR_HOST \
#   -v /etc/sonarr:/config \
#   -v /storage/media/shows:/tv `#optional` \
#   -v /storage/downloads:/downloads `#optional` \
#   --restart unless-stopped \
#   lscr.io/linuxserver/sonarr:latest

# Radarr
# mkdir /etc/radarr # create directory
# docker run -d \
#   --name=radarr \
#   -e PUID=1000 \
#   -e PGID=1000 \
#   -e TZ=Europe/London \
#   -p $RADARR_PORT:7878 \
#   -e VIRTUAL_HOST=$RADARR_HOST \
#   -v /etc/radarr:/config \
#   -v /storage/media/movies:/movies `#optional` \
#   -v /storage/downloads:/downloads `#optional` \
#   --restart unless-stopped \
#   lscr.io/linuxserver/radarr:latest

# Kiwix
mkdir /storage/media/wiki # create directory
docker run -d \
  --name=kiwix \
  -p $KIWIX_PORT:8080 \
  -e VIRTUAL_HOST=$KIWIX_HOST \
  -e VIRTUAL_PORT=8080 \
  -v /storage/media/wiki:/data \
  --restart unless-stopped \
  ghcr.io/kiwix/kiwix-serve:latest \
  *.zim
