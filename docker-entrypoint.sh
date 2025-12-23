#!/bin/bash
# Substitui a porta do Apache com a variável $PORT
sed -i "s/80/${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Inicia o Apache
apache2-foreground
