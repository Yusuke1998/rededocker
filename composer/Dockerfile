FROM php:7.4-cli

RUN apt-get update && apt-get install -y \
    git libmcrypt-dev \
    && pecl install mcrypt-1.0.4 \
    && docker-php-ext-enable mcrypt

RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions http ssh2 gd imagick pdo_mysql zip pcntl @composer

RUN yes | pecl install ssh2-1.2 pecl_http