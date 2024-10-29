# Projet Docker WordPress + phpMyAdmin + MySQL avec SSL

Ce projet configure un environnement WordPress avec phpMyAdmin et MySQL sur un conteneur Docker. Il utilise un certificat SSL auto-signé pour sécuriser les connexions.

## Prérequis

- **Docker** : Assurez-vous que Docker est installé sur votre machine.
- **Docker Compose** (optionnel) : Pour simplifier le déploiement multi-conteneurs si besoin.

## Structure du projet

. ├── Dockerfile ├── src │ ├── wordpress.sql # Sauvegarde de la base de données MySQL pour WordPress │ ├── examfabien.WordPress.2024-10-28.xml # Export de configuration WordPress ├── run_docker.sh # Script pour automatiser le déploiement └── README.md # Documentation du projet

bash


## Installation et Configuration

### Étapes de déploiement

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/votre-utilisateur/votre-projet.git
   cd votre-projet

    Construire l'image Docker : Construisez l'image avec la commande suivante :

    bash

docker build -t wordpress-ssl .

Démarrer le conteneur Docker : Utilisez le script run_docker.sh fourni pour lancer le conteneur avec les volumes :

bash

    chmod +x run_docker.sh
    ./run_docker.sh

    Accéder à WordPress et phpMyAdmin :
        WordPress : http://localhost
        phpMyAdmin : http://localhost/phpmyadmin
        HTTPS : Accédez à WordPress en HTTPS à https://localhost

Détails des Volumes

Les données sont stockées de manière persistante grâce aux volumes Docker :

    wordpress_data : Contient les fichiers WordPress.
    mysql_data : Contient les données MySQL pour WordPress et phpMyAdmin.

Commandes Utiles

    Vérifier les logs :

    bash

docker logs <container_id>

Accéder au conteneur en ligne de commande :

bash

    docker exec -it <container_id> /bin/bash

Scripts et Automatisation

Le script run_docker.sh exécute la commande suivante pour lancer le conteneur avec les volumes montés :

bash

docker run -d -p 80:80 -p 443:443 -p 3306:3306 \
    -v wordpress_data:/var/www/html/wordpress \
    -v mysql_data:/var/lib/mysql \
    wordpress-ssl

Personnalisation

    Nom du Site WordPress : Dans le Dockerfile, changez --title="Your Site Title" pour personnaliser le nom de votre site.
    Données WordPress et SQL : Modifiez les fichiers .xml et .sql dans le dossier src pour adapter le contenu à votre propre configuration.