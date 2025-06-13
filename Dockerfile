# Gunakan official PHP image sebagai base
FROM php:8.2-fpm

# Set direktori kerja
WORKDIR /var/www

# Instal dependensi yang dibutuhkan
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev

# Bersihkan cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instal ekstensi PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Instal Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Salin file proyek
COPY . .

# Set permission
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port 9000 untuk PHP-FPM
EXPOSE 9000

# Jalankan PHP-FPM
CMD ["php-fpm"]
