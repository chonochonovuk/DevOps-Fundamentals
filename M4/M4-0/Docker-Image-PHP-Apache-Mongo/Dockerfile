FROM php:5-apache

RUN apt-get update
RUN apt-get install openssl libssl-dev libcurl4-openssl-dev
RUN pecl install mongo
RUN echo "extension=mongo.so" > /usr/local/etc/php/conf.d/mongo.ini

RUN sed -i 's#ErrorLog /proc/self/fd/2#ErrorLog "|$/bin/cat 1>\&2"#' /etc/apache2/apache2.conf
RUN sed -i 's#CustomLog /proc/self/fd/1 combined#CustomLog "|/bin/cat" combined#' /etc/apache2/apache2.conf
