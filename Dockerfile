FROM php:8.2-apache

# 1. Instala dependências do sistema para GD
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Instala extensões PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli

# 3. CORREÇÃO DO ERRO MPM: Desativa event/worker e ativa prefork
RUN a2dismod mpm_event mpm_worker || true && a2enmod mpm_prefork

# 4. Habilita o mod_rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY . .
RUN chown -R www-data:www-data /var/www/html

# Ajuste de porta para o Railway
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

EXPOSE 80

CMD ["apache2-foreground"]
