FROM php:8.2-apache

# 1. Instala dependências do sistema para GD e utilitários
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 2. Configura e instala extensões PHP (GD inclusive)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli

# 3. FIX RADICAL PARA MPM: Remove fisicamente os arquivos de módulos conflitantes
# Isso garante que o Apache nem 'veja' o event ou worker.
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf && \
    rm -f /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf && \
    a2enmod mpm_prefork rewrite

# 4. Configuração de diretório e permissões
WORKDIR /var/www/html
COPY . .
RUN chown -R www-data:www-data /var/www/html

# 5. Ajuste de porta dinâmico para o Railway
# Usamos aspas simples no sed para que o PHP/Apache interprete a variável de ambiente $PORT
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 6. Garante que o ServerName não gere avisos extras
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apache2-foreground"]
