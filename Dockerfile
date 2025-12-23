# Imagem PHP com Apache
FROM php:8.2-apache

# Instala extensões necessárias para GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Habilita mod_rewrite do Apache
RUN a2enmod rewrite

# Copia todo o projeto para o Apache
COPY . /var/www/html/

# Ajusta permissões
RUN chown -R www-data:www-data /var/www/html

# Expõe a porta padrão do Apache (80)
EXPOSE 80

# Comando para iniciar Apache
CMD ["apache2-foreground"]
