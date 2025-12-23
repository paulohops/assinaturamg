# Usamos a imagem oficial do PHP com Apache
FROM php:8.2-apache

# 1. Instala dependências do sistema para a biblioteca GD
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Configura e instala a extensão GD e outras comuns (como pdo_mysql)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli

# 3. Habilita o mod_rewrite do Apache (comum para frameworks como Laravel/slim)
RUN a2enmod rewrite

# 4. Define o diretório de trabalho
WORKDIR /var/www/html

# 5. Copia os arquivos do seu projeto para o container
COPY . .

# 6. Ajusta as permissões para a pasta do servidor
RUN chown -R www-data:www-data /var/www/html

# 7. O Railway define a porta automaticamente, mas o Apache ouve a 80 por padrão.
# Se precisar mudar a porta do Apache para ler a variável $PORT do Railway:
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

EXPOSE 80

CMD ["apache2-foreground"]
