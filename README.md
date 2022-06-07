# Introduction

Dockerfile to build a streaming radio container.  Uses alpine, mpd, icecast, nginx, php, sqlite, and rompr.

# Installation

Pull the latest version of the image from docker.

```
docker pull nulldev42/streaming-radio
```

Alternately you can build the image yourself.

```
docker build -t nulldev42/streaming-radio https://github.com/nulldev42/streaming-radio.git
```

# Quick Start

Run the image

```
docker run --name streaming-radio -d \
   --volume /yourpath/Music:/Music \
   --volume radio-config:/config \
   --volume mpd:/var/lib/mpd \
   --volume rompr-db:/srv/rompr/prefs \
   --volume rompr-albumart:/srv/rompr/albumart \
   --publish 80:80 \
   --publish 8002:8002
   zveronline/radio
```

This will start the container and you should now be able to browse the web interface on port 80 and icecast on port 8002.
Directory "Music" must contain your music files.

# Docker-compose template
```
version: '2'
services:
  streaming-radio:
    image: nulldev42/streaming-radio
    container_name: streaming-radio
    environment:
      ADMIN_PASSWORD: qwe123test
      BITRATE: 128
      ENCODER: ogg
      MOUNT: radio.ogg
      ICECAST_HOST: 127.0.0.1
      ICECAST_PASSWORD: qwe123
    volumes:
      - /yourpath/Music:/Music
      - radio-config:/config
      - mpd:/var/lib/mpd
      - rompr-db:/srv/rompr/prefs
      - rompr-albumart:/srv/rompr/albumart
    ports:
      - "80:80"
      - "8002:8002"
```
# Rompr screen
![ROMPR](https://fatg3erman.github.io/RompR/images/desktopskin.png)
