FROM php:5.5-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql mysql mysqli

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release?api_version%5B%5D=87
##ENV DRUPAL_VERSION 6.35
##ENV DRUPAL_MD5 a42564ab163f5c93ac82df8cfd6f1c13
ENV DRUPAL_VERSION 6.25
ENV DRUPAL_MD5 5a6862a944c956493fa52acdaf0621b9

RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
    && echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
    && tar -xz --strip-components=1 -f drupal.tar.gz \
    && rm drupal.tar.gz \
    && chown -R www-data:www-data sites
