
# Projet Docker WordPress + phpMyAdmin + MySQL avec SSL

Ce projet configure un environnement WordPress avec phpMyAdmin et MySQL sur un conteneur Docker. Il utilise un certificat SSL auto-signé pour la sécurisation des connexions.
Prérequis

- Docker : assurez-vous que Docker est installé sur votre machine.
- Docker Compose (optionnel) : pour simplifier le déploiement multi-conteneurs si besoin.

## Structure du projet

````bash
.
├── Dockerfile
├── src
│   ├── wordpress.sql                 # Sauvegarde de la base de données MySQL pour WordPress
│   ├── examfabien.WordPress.2024-10-28.xml   # Export de configuration WordPress
├── run_docker.sh                     # Script pour automatiser le déploiement
└── README.md                          # Documentation du projet
````
## Installation et Configuration
### Étapes de déploiement

    Cloner le dépôt :

````bash

git clone https://github.com/votre-utilisateur/votre-projet.git
cd votre-projet
````

Construire l'image Docker : Construisez l'image avec la commande suivante :

````bash

docker build -t wordpress-ssl .
````
Démarrer le conteneur Docker : Utilisez le script run_docker.sh fourni pour lancer le conteneur avec les volumes :

````bash
    src/run_docker.sh
````
### Accéder à WordPress et phpMyAdmin :
        WordPress : http://localhost
        phpMyAdmin : http://localhost/phpmyadmin
        HTTPS : accédez à WordPress en HTTPS à https://localhost

## Détails des Volumes

Les données sont stockées de manière persistante grâce aux volumes Docker :

    wordpress_data : contient les fichiers WordPress.
    mysql_data : contient les données MySQL pour WordPress et phpMyAdmin.

## Scripts et Automatisation

Le script run_docker.sh exécute la commande suivante pour lancer le conteneur avec les volumes montés :

````bash

docker run -d -p 80:80 -p 443:443 -p 3306:3306 \
    -v wordpress_data:/var/www/html/wordpress \
    -v mysql_data:/var/lib/mysql \
    wordpress-ssl
````
## Personnalisation

    Nom du Site WordPress : dans le Dockerfile, changez --title="Your Site Title" pour personnaliser le nom de votre site.
    Données WordPress et SQL : modifiez les fichiers .xml et .sql dans le dossier src pour adapter le contenu à votre propre configuration.