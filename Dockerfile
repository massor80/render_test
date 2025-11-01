# Use PHP 8.2 FPM as base image
FROM php:8.2-fpm

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install PHP dependencies (Laravel + others)
RUN composer install --no-dev --optimize-autoloader

# Generate app key (ignore if already present)
RUN php artisan key:generate || true

# Expose Render’s required port
EXPOSE 10000

# Start the Laravel server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
