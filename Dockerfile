FROM php:8.2-apache

# 1. Instala dependências do sistema para a biblioteca GD
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Configura e instala GD e extensões de banco de dados
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli

# 3. FIX RADICAL PARA "More than one MPM loaded"
# Removemos todos os arquivos de módulos MPM habilitados e forçamos apenas o prefork
RUN rm -f /etc/apache2/mods-enabled/mpm_* \
    && ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load \
    && ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf \
    && a2enmod rewrite

# 4. Configuração de ambiente
WORKDIR /var/www/html
COPY . .

# Ajuste de permissões (essencial para que o PHP possa gravar imagens via GD)
RUN chown -R www-data:www-data /var/www/html

# 5. Compatibilidade de Porta com o Railway
# O Apache por padrão usa a 80, o Railway exige que usemos a variável $PORT
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 6. Evita avisos de ServerName nos logs
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apache2-foreground"]
