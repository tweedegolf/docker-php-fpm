FROM php:5.6.28-fpm

ENV APCU_VERSION="4.0.11"

RUN curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update

# Install other PHP modules
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libpng12-dev \
        postgresql-server-dev-9.5 \
        libxslt1-dev \
        libbz2-dev \
        libgmp-dev \
        libicu-dev \
        imagemagick \
        libmagickwand-dev \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) \
        gd \
        opcache \
        pdo_pgsql \
        zip \
        bcmath \
        bz2 \
        calendar \
        ftp \
        gettext \
        gmp \
        intl \
        pdo_mysql \
        sockets \
        exif \
    && pecl install imagick \
    && pecl install apcu-$APCU_VERSION \
    && docker-php-ext-enable \
        imagick \
        apcu
