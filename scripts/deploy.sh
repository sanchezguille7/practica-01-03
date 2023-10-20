#!/bin/bash

#Muestra todos los comandos que se van ejecutadno
set -x

# Incluimos las variables
source .env

# Actualizamos los repositorios
apt update

# actualizamos los paquetes 
#apt upgrade -y

# Eliminamos descargar previas del repositorio
rm -rf /tmp/iaw-practica-lamp

# Clonamos el repositorioo fuente de la aplicacion
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

# Movemos el codigo fuentede la apicacion a /var/www/html
mv /tmp/iaw-practica-lamp/src/* /var/www/html

# Configuramos el arvhivo config.php de la aplicacion
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

# Importamos el script de base de datos
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

#Creamos el usuario de la base de datos y le asignamos privilegios
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'"