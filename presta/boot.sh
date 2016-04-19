#!/usr/bin/env bash

# Activate Vagrant Config
cd /vagrant/public/config/
cp settings.inc.php.vagrant settings.inc.php
cd /vagrant/public
cp ../private/htaccess.vagrant .htaccess

# Remount Dynamic data
mkdir -m 777 -p /vagrant_guest/public/cache
#mkdir -m 777 /vagrant/public/cache
mount -o bind /vagrant_guest/public/cache /vagrant/public/cache

# Import DB (if not exists)
presimport $1

# run custom boot.sh if available
if [ -f "/vagrant/vagrant.boot.sh" ]; then
	dos2unix /vagrant/vagrant.boot.sh
	sh /vagrant/vagrant.boot.sh
fi

echo 'Presta Frontend: http://localhost:8080/'
echo 'Presta Backend: http://localhost:8080/gigatec-admin/'
echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'
