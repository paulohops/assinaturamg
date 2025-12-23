FROM php:8.2-apache

# Instala as dependências de sistema necessárias para a GD
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Configura e instala a extensão GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd

# Copia os arquivos do projeto
WORKDIR /var/www/html
COPY . .
