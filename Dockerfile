# Imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instala dependências para GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Habilita mod_rewrite do Apache
RUN a2enmod rewrite

# Copia o projeto para o diretório padrão do Apache
COPY . /var/www/html/

# Ajusta permissões
RUN chown -R www-data:www-data /var/www/html

# Define porta padrão (Railway sobrescreve)
ENV PORT 8080

# Configura Apache para escutar na porta definida por $PORT
RUN sed -i "s/80/${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Expõe a porta dinâmica
EXPOSE ${PORT}

# Comando para iniciar Apache
CMD ["apache2-foreground"]
