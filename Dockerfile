# Stage 1: Build frontend (Vite + React)
FROM node:18 AS frontend

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: PHP & Laravel
FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev libxml2-dev zip \
    openssl libapache2-mod-php \
    && docker-php-ext-install pdo_mysql zip

# Enable Apache mods
RUN a2enmod rewrite ssl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Setup working dir
WORKDIR /var/www/html

# Copy source code
COPY . .

# Copy Vite build
COPY --from=frontend /app/public/build /var/www/html/public/build

# Copy Apache config
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# OPTIONAL: Include SSL certificate (untuk lokal dev atau jika Railway dukung)
# COPY ./certs/your.crt /etc/ssl/certs/your.crt
# COPY ./certs/your.key /etc/ssl/private/your.key

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permission
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80 443

CMD ["apache2-foreground"]
