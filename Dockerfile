FROM php:8.2-apache

# 1. Instala a GD (Apenas o necessário)
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd

# 2. ÚNICA correção necessária: desativa o módulo conflitante que causa o erro AH00534
RUN a2dismod mpm_event && a2enmod mpm_prefork

# 3. Copia seus arquivos
WORKDIR /var/www/html
COPY . .
