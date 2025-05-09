FROM node:18 AS build

RUN npm install \
    && npm run build

FROM php:8.2-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y apache2-utils ssl-cert\
    git unzip curl libzip-dev libpng-dev libonig-dev libxml2-dev zip openssl \
    && docker-php-ext-install pdo_mysql zip

# Salin konfigurasi Apache
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# Aktivasi virtual host SSL
RUN a2ensite default-ssl.conf

# Enable Apache rewrite module
RUN a2enmod ssl \
    && a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy full project (termasuk hasil build React di public/build)
COPY . .
COPY ./public/build/ /var/www/html/public/

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel: Clear and cache configs
RUN php artisan config:clear \
    && php artisan config:cache \
    && php artisan route:cache

# Set permissions
RUN chown -R www-data:www-data /var/www/html /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R o+w var/www/html/storage

EXPOSE 80
CMD ["apache2-foreground"]
