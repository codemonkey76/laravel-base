FROM php:7.4-fpm-alpine

ENV GID=1000
ENV UID=1000
ENV USER=shane

# Install required php extensions
RUN docker-php-ext-install pdo pdo_mysql pcntl
RUN apk add --update --no-cache autoconf g++ make
RUN pecl install redis
RUN docker-php-ext-enable redis

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Get latest node
RUN apk add --update npm

# Install bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

RUN addgroup -g $GID -S $USER && \
	adduser -u $UID -S $USER -G $USER -s /bin/bash

USER $USER
COPY ./profile/.profile /home/shane/.profile
WORKDIR /var/www
