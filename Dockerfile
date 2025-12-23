# Imagem oficial PHP + Apache
FROM php:8.2-apache

# Instala dependências GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        gettext-base \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Habilita mod_rewrite
RUN a2enmod rewrite

# Copia projeto
COPY . /var/www/html/

# Permissões
RUN chown -R www-data:www-data /var/www/html

# Porta padrão (Railway sobrescreve)
ENV PORT 8080

# Substitui a porta do Apache em tempo de execução
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expõe a porta dinâmica
EXPOSE 8080

# Usa nosso entrypoint customizado
ENTRYPOINT ["docker-entrypoint.sh"]
