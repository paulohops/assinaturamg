# PHP + Apache
FROM php:8.2-apache

# Instala dependências GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Habilita mod_rewrite
RUN a2enmod rewrite

# Copia o projeto
COPY . /var/www/html/

# Ajusta permissões
RUN chown -R www-data:www-data /var/www/html

# Configura o Apache para escutar todas as interfaces
RUN sed -i 's/Listen 80/Listen 0.0.0.0:8080/' /etc/apache2/ports.conf

# Expõe porta 8080
EXPOSE 8080

# Inicia Apache
CMD ["apache2-foreground"]
