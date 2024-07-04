FROM alpine:3.20.1

ENV ROMPR_VERSION=2.15 \
ADMIN_PASSWORD=qwe123test \
HOSTNAME=localhost \
NAMESTREAM=radio \
DESCRIPTION=radio \
BITRATE=128 \
ENCODER=mp3 \
MOUNT=radio.mp3 \
ICECAST_HOST=127.0.0.1 \
ICECAST_PASSWORD=qwe123

COPY . .
ADD https://github.com/fatg3erman/RompR/releases/download/${ROMPR_VERSION}/rompr-${ROMPR_VERSION}.zip /tmp/rompr.zip

RUN apk add --update --no-cache wget unzip bash nano tzdata mpd icecast ncmpc supervisor nginx \
    diffutils composer logrotate \
    php83-fpm php83-sqlite3 php83-pdo php83-xml php83-gd php83-curl php83-json php83-mbstring php83-intl \
    php83-pdo_sqlite php83-fileinfo php83-simplexml \
#
&& cp /usr/share/zoneinfo/America/New_York /etc/localtime \
&& echo "America/New_York" > /etc/timezone \
&& apk del tzdata \
#
&& cd /tmp \
&& unzip rompr.zip \
&& mv rompr /srv/ \
&& rm -f rompr.zip \
&& mkdir -p /srv/rompr/prefs \
&& chown -R nginx:nginx /srv \
#
&& mkdir -p /etc/supervisor.d \
&& ln -sf /conf/supervisor/radio.ini /etc/supervisor.d/radio.ini \
&& ln -sf /conf/supervisor/icecast.ini /etc/supervisor.d/icecast.ini \
&& ln -sf /conf/supervisor/nginx.ini /etc/supervisor.d/nginx.ini \
&& ln -sf /conf/supervisor/php-fpm.ini /etc/supervisor.d/php-fpm.ini \
#
&& mkdir -p /etc/nginx/default.d \
&& ln -sf /etc/nginx/http.d /etc/nginx/conf.d \
&& ln -sf /conf/vhosts /etc/nginx/vhosts.d \
&& ln -sf /conf/nginx/nginx.conf /etc/nginx/nginx.conf \
&& ln -sf /conf/nginx/php-fpm.conf /etc/nginx/conf.d/php-fpm.conf \
&& ln -sf /conf/nginx/php.conf /etc/nginx/default.d/php.conf \
&& chown -R nginx:nginx /etc/nginx \
&& rm -f /etc/nginx/conf.d/default.conf \
&& mkdir /run/php-fpm
#
COPY commradioplugin.class.php /srv/rompr/streamplugins/classes/commradioplugin.class.php
#
#RUN chmod 755 /entrypoint.sh
RUN chown root:root /usr/bin/mpd

EXPOSE 80
EXPOSE 8002
VOLUME ["/var/lib/mpd", "/srv/rompr/prefs", "/srv/rompr/albumart", "/Music"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
ENTRYPOINT ["/entrypoint.sh"]
