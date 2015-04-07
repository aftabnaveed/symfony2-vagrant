#! /usr/bin/env bash
 
# Variables
APPENV=local
DBHOST=localhost
DBNAME=symfony2
DBUSER=symfony2
DBPASSWD=symfony2

apt-get update

echo "Installing nginx..."
apt-get install nginx -y > /dev/null 

echo "Configuring Nginx"
cp /vagrant/provision/config/localhost /etc/nginx/sites-available/localhost
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
#rm -rf /etc/nginx/sites-available/default
service nginx restart

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

#silent the mysql password prompt and serve that from config
apt-get install debconf-utils -y > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

echo "Installing MYSQL Server..."
apt-get install mysql-server -y > /dev/null

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"

#some time resolv.conf would save local dns we don't want that as that might not work
#echo "Copying resolv.conf..."
#cp /vagrant/provision/config/resolv.conf /etc/

echo "Configuring PHP5"
apt-get install php5-fpm -y > /dev/null

apt-get install php5-cli -y > /dev/null

apt-get install php5-curl -y > /dev/null

echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer


echo "Configuring Demo Project..."
cd /vagrant/
composer create-project symfony/framework-standard-edition demo --no-interaction


