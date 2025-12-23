FROM php:8.2-apache

# 1. Instala a biblioteca GD e dependências
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd

# 2. Correção do erro MPM (necessário para o Apache iniciar corretamente)
RUN a2dismod mpm_event || true && a2enmod mpm_prefork

# 3. Configura o diretório e copia os arquivos
WORKDIR /var/www/html
COPY . .

# 4. AJUSTE DE PERMISSÕES PARA AMBAS AS PASTAS
# Cria as pastas caso não existam e dá permissão total ao usuário www-data (Apache/PHP)
RUN mkdir -p /var/www/html/assinatura-onnet/output \
             /var/www/html/assinatura-sempre/output && \
    chown -R www-data:www-data /var/www/html/assinatura-onnet \
                               /var/www/html/assinatura-sempre && \
    chmod -R 775 /var/www/html/assinatura-onnet \
                 /var/www/html/assinatura-sempre

# 5. Ajuste de porta para o Render/Railway
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

CMD ["apache2-foreground"]
