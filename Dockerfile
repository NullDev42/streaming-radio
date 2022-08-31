FROM alpine:3.16

ENV ROMPR_VERSION=1.61 \
ADMIN_PASSWORD=qwe123test \
HOSTNAME=localhost \
NAMESTREAM=radio \
DESCRIPTION=radio \
BITRATE=128 \
ENCODER=ogg \
MOUNT=radio.ogg \
ICECAST_HOST=127.0.0.1 \
ICECAST_PASSWORD=qwe123

COPY . .
ADD https://github.com/fatg3erman/RompR/releases/download/${ROMPR_VERSION}/rompr-${ROMPR_VERSION}.zip /tmp/rompr.zip

RUN apk add --update --no-cache wget unzip bash nano tzdata mpd icecast ncmpc supervisor nginx \
    diffutils composer logrotate \
    php81-fpm php81-sqlite3 php81-pdo php81-xml php81-gd php81-curl php81-json php81-mbstring php81-intl \
    php81-pdo_sqlite php81-fileinfo php81-simplexml php81-pdo_mysql \
#
&& cp /usr/share/zoneinfo/America/New_York /etc/localtime \
&& echo "America/New_York" > /etc/timezone \
&& apk del tzdata \
#
&& chmod 755 /entrypoint.sh \
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
&& mkdir /run/php-fpm \
#
&& ln -sf /conf/php/php.ini /etc/php81/php.ini \
&& ln -sf /conf/php/www.conf /etc/php81/php-fpm.d/www.conf \
&& chown -R nginx:nginx /etc/php81 \
#
&& chown root:root /usr/bin/mpd

EXPOSE 80
EXPOSE 8002
VOLUME ["/var/lib/mpd", "/srv/rompr/prefs", "/srv/rompr/albumart"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
ENTRYPOINT ["/entrypoint.sh"]