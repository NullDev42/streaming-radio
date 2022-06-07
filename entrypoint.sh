#!/bin/bash
set -e

if [ ! -d /var/lib/mpd/playlists ]
then
mkdir -p /var/lib/mpd/playlists
fi

if [ ! -d /config ]
then
  mkdir -p /config
  cp /conf/radio.conf /config/
  cp /conf/icecast.xml /config/
fi

sed -i s/ADMIN_PASSWORD/$ADMIN_PASSWORD/g /config/icecast.xml
sed -i s/HOSTNAME/$HOSTNAME/g /config/icecast.xml
sed -i s/NAMESTREAM/$NAMESTREAM/g /config/radio.conf
sed -i s/DESCRIPTION/$DESCRIPTION/g /config/radio.conf
sed -i s/BITRATE/$BITRATE/g /config/radio.conf
sed -i s/ENCODER/$ENCODER/g /config/radio.conf
sed -i s/MOUNT/$MOUNT/g /config/radio.conf
sed -i s/ICECAST_HOST/$ICECAST_HOST/g /config/radio.conf
sed -i s/ICECAST_PASSWORD/$ICECAST_PASSWORD/g /config/radio.conf

sed -i 's|, GLOB_BRACE| |' /srv/rompr/includes/functions.php

if [ ! $ICECAST_HOST == 127.0.0.1 ]
then
rm -f /etc/supervisor.d/icecast.ini
fi
exec "$@"