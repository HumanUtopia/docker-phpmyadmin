# Dockerfile for phpMyAdmin with PHP and Caddy2 on Alpine Linux

# Base image
FROM alpine:latest

# Install dependencies
RUN apk update && apk add --no-cache \
    php7 \
    php7-fpm \
    php7-json \
    php7-zlib \
    php7-xml \
    php7-phar \
    php7-intl \
    php7-mysqli \
    php7-mbstring \
    php7-session \
    caddy

# Download and setup phpMyAdmin
ARG VERSION
RUN wget https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-english.tar.gz \
    && tar -xzf phpMyAdmin-${VERSION}-english.tar.gz -C /var/www \
    && mv /var/www/phpMyAdmin-${VERSION}-english /var/www/phpmyadmin \
    && rm phpMyAdmin-${VERSION}-english.tar.gz

# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Caddy and PHP-FPM configuration
RUN mkdir -p /run/php

# Create a directory for phpMyAdmin
WORKDIR /var/www/phpmyadmin

# Expose port
EXPOSE 80

# Start Caddy and PHP-FPM
CMD ["sh", "-c", "php-fpm7 && caddy run --config /etc/caddy/Caddyfile --adapter caddyfile"]
