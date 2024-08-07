# Streaming-Radio

Dockerfile to build a streaming radio container.  Uses alpine, mpd, icecast, nginx, php, sqlite, and rompr.

Included binary versions:

```text
Alpine    3.20.1
Mpd       0.23.15
Icecast   2.4.4
Nginx     1.26.1
Php       8.3.8
Rompr     2.15
```

## Installation

Pull the latest version of the image from docker.

```bash
docker pull nulldev42/streaming-radio
```

Alternately you can build the image yourself.

```bash
docker build -t nulldev42/streaming-radio https://github.com/nulldev42/streaming-radio.git
```

## Quick Start

Run the image

```bash
docker run --name streaming-radio -d \
   --volume /yourpath/Music:/Music \
   --volume /yourpath/mpd:/var/lib/mpd \
   --volume /yourpath/rompr-db:/srv/rompr/prefs \
   --volume /yourpath/rompr-albumart:/srv/rompr/albumart \
   --publish 80:80 \
   --publish 8002:8002
   nulldev42/streaming-radio
```

This will start the container and you should now be able to browse the web interface on port 80 and icecast on port 8002.
Directory "Music" must contain your music files.

## Docker-compose template

```docker-compose
version: '2'
services:
  streaming-radio:
    image: nulldev42/streaming-radio
    container_name: streaming-radio
    environment:
      ADMIN_PASSWORD: qwe123test
      HOSTNAME: localhost
      NAMESTREAM: radio
      DESCRIPTION: radio
      BITRATE: 128
      ENCODER: mp3
      MOUNT: radio.mp3
      ICECAST_HOST: 127.0.0.1
      ICECAST_PASSWORD: qwe123
    volumes:
      - /yourpath/Music:/Music
      - /yourpath/mpd:/var/lib/mpd
      - /yourpath/rompr-db:/srv/rompr/prefs
      - /yourpath/rompr-albumart:/srv/rompr/albumart
    ports:
      - "80:80"
      - "8002:8002"
```

## Rompr screen

![ROMPR](https://fatg3erman.github.io/RompR/images/desktopskin.png)
