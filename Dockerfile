# Dockerfile for phpMyAdmin with PHP and Caddy2 on Alpine Linux

# Base image
FROM alpine:latest

# Install dependencies
RUN apk update && apk add --no-cache \
    php8 \
    php8-fpm \
    php8-json \
    php8-zlib \
    php8-xml \
    php8-phar \
    php8-intl \
    php8-mysqli \
    php8-mbstring \
    php8-session \
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
