# Práctica 01-03

Tercera práctica del modulo IAW

  

## Install lamp
Muestra todos los comandos que se van ejecutando

    set -x

  

 Actualizamos los repositorios

    apt update

  

Actualizamos los paquetes

    apt upgrade -y

  

### Instalamos el servidor web Apache

    apt install apache2 -y
  
### Instalar el sistema gestor de datos **MySQL**

    apt install mysql-server -y

  
### Instalamos **PHP**

    sudo apt install php libapache2-mod-php php-mysql -y

  
 Copiar el archivo de configuración de **Apache2**

    cp ../conf/000-default.conf /etc/apache2/sites-available

  
Reiniciamos **Apache2**

    systemctl restart apache2

  
Copiamos el archivo de prueba de **PHP**

    cp ../php/index.php /var/www/html

Modificamos el propietario de los archivos

    chown -R www-data:www-data /var/www/html

  

### --------------------------------------------------------------------------------

  

## Deploy

  

Muestra todos los comandos que se van ejecutado

    set -x

  

Incluimos las variables del archivo **.env**

    source .env

  

Actualizamos los repositorios

    apt update

  

Actualizamos los paquetes

    apt upgrade -y

  

Eliminamos descargar previas del repositorio

    rm -rf /tmp/iaw-practica-lamp

  

Clonamos el repositorio fuente de la aplicación

    git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/iaw-practica-lamp

  

Movemos el código fuente de la aplicación a **/var/www/html**

    mv /tmp/iaw-practica-lamp/src/* /var/www/html

  

Configuramos el archivo **config.php** de la aplicación

    sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php

    sed -i "s/username_here/$DB_USER/" /var/www/html/config.php

    sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

  

Modificamos el script de base de datos

    sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql

  

Importamos el script de base de datos

    mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

  

Creamos el usuario de la base de datos y le asignamos privilegios

    mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
    
    mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"
    
    mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'"

### --------------------------------------------------------------------------------
# .env
Configuramos las variables 

    DB_NAME=aplicacion
    
    DB_USER=usuario
    
    DB_PASSWORD=1234


### --------------------------------------------------------------------------------
# index.php
    <?php
    
    phpinfo();
    
    ?>

### --------------------------------------------------------------------------------
# 000-default.conf

    ServerSignature Off
    ServerTokens Prod
   
    <VirtualHost *:80>
    #ServerName www.example.com
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>

