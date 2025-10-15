# Use a base PHP image with Apache or Nginx (e.g., php:8.2-apache or php:8.2-fpm for Nginx)
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip

# Install PHP extensions required by Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql

# Enable Apache mod_rewrite (if using Apache)
RUN a2enmod rewrite

# Copy custom Apache configuration if needed (e.g., for virtual host setup)
# COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Copy your Laravel application code into the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install project dependencies
RUN composer install --no-dev --optimize-autoloader

# Set appropriate permissions for storage and bootstrap/cache directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80 (or your chosen port)
EXPOSE 80
