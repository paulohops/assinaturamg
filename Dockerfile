# Use a imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instala dependências necessárias para GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Habilita mod_rewrite do Apache (opcional, útil para URLs amigáveis)
RUN a2enmod rewrite

# Copia todo o conteúdo do projeto para o diretório padrão do Apache
COPY . /var/www/html/

# Define permissões corretas (opcional)
RUN chown -R www-data:www-data /var/www/html

# Expondo a porta padrão do Apache
EXPOSE 80

# Comando padrão para iniciar o Apache
CMD ["apache2-foreground"]
