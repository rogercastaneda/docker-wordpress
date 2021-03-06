# install nginx alpine version
# https://hub.docker.com/r/unblibraries/nginx-php/
FROM unblibraries/nginx-php:alpine-php7

LABEL version="wp0.2"
LABEL description="Basic nginx image with ssl for wordpress projects"
LABEL maintainer="roger.castaneda@bonzzu.com"

# https://github.com/codecasts/php-alpine
# php-bcmath php-bz2 php-calendar php-ctype php-curl php-dba
# php-dom php-embed php-enchant php-exif php-ftp php-gd
# php-gettext php-gmp php-iconv php-imap php-intl php-json
# php-ldap php-litespeed php-mbstring php-mcrypt php-mysqli
# php-mysqlnd php-odbc php-opcache php-openssl php-pcntl
# php-pdo php-pdo_dblib php-pdo_mysql php-pdo_pgsql php-pdo_sqlite
# php-pear php-pgsql php-phar php-phpdbg php-posix php-pspell
# php-session php-shmop php-snmp php-soap php-sockets php-sqlite3
# php-sysvmsg php-sysvsem php-sysvshm php-tidy php-wddx php-xml
# php-xmlreader php-xmlrpc php-xsl php-zip php-zlib

# enabled by parent docker image
# php7 php7-fpm php7-json php7-zlib php7-xml php7-phar php7-iconv php7-mcrypt curl php7-curl php7-openssl php7-gd
RUN \
  apk add --update openssh openssl php7-ctype php7-pdo php7-pdo_mysql php7-zip php7-xml php7-simplexml php7-xmlreader php7-mbstring php7-apcu php7-xmlrpc php7-memcached php7-dom php7-common php7-fileinfo php7-tokenizer php7-xmlwriter php7-mysqli
RUN \
  apk add --update openssh openssl && \
  mkdir -p /etc/nginx/ssl && \
  openssl genrsa -out /etc/nginx/ssl/dummy.key 2048 && \
  openssl req -new -key /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.csr -subj "/C=GB/L=London/O=Company Ltd/CN=docker" && \
  openssl x509 -req -days 3650 -in /etc/nginx/ssl/dummy.csr -signkey /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.crt

# RUN apk add --no-cache mysql-client openssh-client rsync git 

WORKDIR /app
COPY conf/php/app-php.ini /etc/php7/conf.d/zz_app.ini
COPY conf/nginx-wp.conf /etc/nginx/conf.d/app.conf

# expose container port
EXPOSE 80 443
