# Use a imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instala dependências necessárias para GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Habilita mod_rewrite do Apache (opcional)
RUN a2enmod rewrite

# Copia o projeto para o Apache
COPY . /var/www/html/

# Ajusta permissões
RUN chown -R www-data:www-data /var/www/html

# Define variável de ambiente padrão para a porta (Railway vai sobrescrever)
ENV PORT 8080

# Configura Apache para escutar na porta definida por $PORT
RUN sed -i "s/80/${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Exponha a porta (Railway usa automaticamente $PORT)
EXPOSE ${PORT}

# Inicia o Apache
CMD ["apache2-foreground"]
