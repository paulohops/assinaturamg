FROM php:8.2-apache

# 1. Instalar dependências da biblioteca GD
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar extensões PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli

# 3. SOLUÇÃO DEFINITIVA PARA MPM:
# Remove todos os links de MPM habilitados e garante que APENAS o prefork exista
RUN rm -f /etc/apache2/mods-enabled/mpm_* && \
    ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
    ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# 4. Habilitar mod_rewrite
RUN a2enmod rewrite

# 5. Configurar diretório de trabalho e porta do Railway
WORKDIR /var/www/html
COPY . .
RUN chown -R www-data:www-data /var/www/html

# Ajustar a porta para o Railway (Troca 80 pela variável $PORT)
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 6. Forçar o ServerName para evitar avisos inúteis
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80

# Usar o comando padrão da imagem oficial
CMD ["apache2-foreground"]
