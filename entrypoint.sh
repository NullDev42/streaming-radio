#!/bin/sh
set -e

if [ -d /etc/php83 ]
then
  ln -sf /conf/php/php.ini /etc/php83/php.ini
  ln -sf /conf/php/www.conf /etc/php83/php-fpm.d/www.conf
  chown -R nginx:nginx /etc/php83
fi

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

sed -i '/;user=chrism                     ; setuid to this UNIX account at startup; recommended if root/c user=root' /etc/supervisord.conf

if [ ! $ICECAST_HOST == 127.0.0.1 ]
then
  rm -f /etc/supervisor.d/icecast.ini
fi

chown -R nginx:nginx /srv/rompr

# disable icecast status & admin pages
rm -f /usr/share/icecast/web/*
exec "$@"