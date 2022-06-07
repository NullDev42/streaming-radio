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

#sed -i 's|max_execution_time = 30|max_execution_time = 60|' /etc/php8/php.ini
#sed -i 's|post_max_size = 8M|post_max_size = 256M|' /etc/php8/php.ini
#sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 10M|' /etc/php8/php.ini
#sed -i 's|max_file_uploads = 20|max_file_uploads = 200|' /etc/php8/php.ini
#sed -i 's|;sqlite3.defensive = 1|sqlite3.defensive = 1|' /etc/php8/php.ini

#sed -i 's|user = nobody|user = nginx|' /etc/php8/php-fpm.d/www.conf
#sed -i 's|group = nobody|group = nginx|' /etc/php8/php-fpm.d/www.conf
#sed -i 's|listen = 127.0.0.1:9000|listen = /run/php-fpm/www.sock|' /etc/php8/php-fpm.d/www.conf
#sed -i 's|;listen.group = nobody|listen.group = nginx  |' /etc/php8/php-fpm.d/www.conf
#sed -i 's|;listen.owner = nobody|listen.owner = nginx  |' /etc/php8/php-fpm.d/www.conf
#sed -i 's|;listen.mode = 0660|listen.mode = 0660|' /etc/php8/php-fpm.d/www.conf
#sed -i 's|pm.max_children = 5|pm.max_children = 50|' /etc/php8/php-fpm.d/www.conf
#sed -i 's|pm.max_spare_servers = 3|pm.max_spare_servers = 35|' /etc/php8/php-fpm.d/www.conf

sed -i 's|, GLOB_BRACE| |' /srv/rompr/includes/functions.php

if [ ! $ICECAST_HOST == 127.0.0.1 ]
then
rm -f /etc/supervisor.d/icecast.ini
fi
exec "$@"