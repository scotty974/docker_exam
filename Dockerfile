FROM debian:buster

# Définir le répertoire de travail
WORKDIR /app

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    mariadb-server \
    wget \
    curl \
    unzip \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et configurer WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mv wordpress /var/www/html/wordpress && \
    rm latest.tar.gz

# Télécharger et configurer phpMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz && \
    tar -xzvf phpMyAdmin-latest-all-languages.tar.gz && \
    mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin && \
    rm phpMyAdmin-latest-all-languages.tar.gz

# Générer un certificat SSL auto-signé
RUN mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/apache-selfsigned.key \
    -out /etc/ssl/certs/apache-selfsigned.crt \
    -subj "/C=FR/ST=State/L=City/O=Company/OU=Department/CN=localhost"

# Configurer Apache pour utiliser SSL
RUN a2enmod ssl && \
    a2ensite default-ssl

# Ajouter le fichier de sauvegarde de la base de données
COPY src/wordpress.sql /src/wordpress.sql



# Configurer Apache pour utiliser le certificat SSL
RUN echo '<VirtualHost *:443>\n\
    ServerAdmin admin@localhost\n\
    DocumentRoot /var/www/html\n\
    SSLEngine on\n\
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt\n\
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key\n\
    Alias /wordpress /var/www/html/wordpress\n\
    <Directory /var/www/html/wordpress>\n\
    AllowOverride All\n\
    Require all granted\n\
    </Directory>\n\
    Alias /phpmyadmin /var/www/html/phpmyadmin\n\
    <Directory /var/www/html/phpmyadmin>\n\
    AllowOverride All\n\
    Require all granted\n\
    </Directory>\n\
    DirectoryIndex index.php index.html\n\
    </VirtualHost>' > /etc/apache2/sites-available/default-ssl.conf

# Configurer MySQL et charger la base de données
# Configurer MySQL et charger la base de données
RUN service mysql start && \
    mysql -e "CREATE DATABASE wordpress;" && \
    mysql -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';" && \
    mysql -e "CREATE USER 'pma_user'@'%' IDENTIFIED BY 'pma_password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'pma_user'@'%';" && \
    mysql -e "FLUSH PRIVILEGES;" && \
    mysql -u root wordpress < /src/wordpress.sql

# Activer les modules nécessaires
RUN a2enmod rewrite


# Modifier les permissions du répertoire WordPress
RUN chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress

# Exposer les ports
EXPOSE 80 443 3306

# Démarrer Apache et MySQL
CMD service mysql start && service apache2 start && tail -f /dev/null
