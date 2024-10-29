#!/bin/bash
# build et run l'image automatiquement
docker build -t wordpress-ssl .
docker run -d -p 80:80 -p 443:443 -v wordpress_data:/var/www/html/wordpress -v mysql_data:/var/lib/mysql wordpress-ssl
