#!/bin/bash
echo
echo "________Actualizando sistema Operativo y añadiendo repositorios__________"
echo
apt-get update
add-apt-repository universe
apt-get update
echo
echo "________________________________________________"
echo
echo " INSTALANDO SERVIDOR WEB APACHE"
echo
apt-get install apache2
systemctl enable apache2
systemctl status apache2
sleep 10
echo
echo "_______________________________________________"
echo
echo " INSTALANDO PHP --- version 7.4 compatible WordPress"
echo
# Instalando php 7.4
add-apt-repository ppa:ondrej/php -y
apt update
apt upgrade
apt install php7.4 php7.4-common libapache2-mod-php7.4 php7.4-cli
systemctl restart apache2
apt install php7.4-fpm php7.4-common libapache2-mod-fcgid php7.4-cli php7.4-mysqli
a2enmod proxy_fcgi setenvif && sudo a2enconf php7.4-fpm
systemctl restart apache2
systemctl status php7.4-fpm
php -v

# Para instalar ultima version php (confirmar antes compatibilidad Wordpress)
# apt-get install -y php php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip,intl}
echo
echo
php -v
sleep 15
echo
echo "_______________________________________________"
echo
echo " INSTALANDO MYSQL SERVER ( MariaDB ) "
echo
apt install mariadb-server mariadb-client
systemctl enable --now mariadb
systemctl status mariadb
mysql_secure_installation
echo
echo "_______________________________________________"
echo
echo " Creando base de datos para WordPress"
echo
echo " 

CREATE USER 'foc_db'@'localhost' IDENTIFIED BY 'your_password';

CREATE DATABASE foc_db;

GRANT ALL PRIVILEGES ON foc_db.* TO 'foc_db'@'localhost';

FLUSH PRIVILEGES;

Exit;"
echo
mysql -u root -p
echo
echo "_______________________________________________"
echo
echo
echo " Descargando WordPress, instalando, preconfigurando "
echo
apt install wget unzip
wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/ /var/www/html/
rm latest.zip
chown www-data:www-data -R /var/www/html/wordpress/
# chmod -R 755 /var/www/html/wordpress/
#
echo " Blindamos definiendo correctamente permisos"
find /var/www/html/wordpress -type d -exec chmod 755 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
#
# Mostrarlos permisos en Formato Octal
# stat -c '%A %a %n' /var/www/html/wordpress/*
# stat -c '%A %a % U %n' /var/www/html/wordpress
#
sleep 15
echo
echo "Copiar para pegar a continuación

<VirtualHost *:80>

ServerAdmin admin@example.com

DocumentRoot /var/www/html/wordpress
ServerName example.com
ServerAlias www.example.com

<Directory /var/www/html/wordpress/>

Options FollowSymLinks
AllowOverride All
Require all granted

</Directory>

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>"
sleep 15
echo
nano /etc/apache2/sites-available/wordpress.conf
a2ensite wordpress.conf
a2enmod rewrite
a2dissite 000-default.conf
systemctl restart apache2