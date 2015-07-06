#!/usr/bin/env bash

# Create local.xml Symlink
cd /vagrant/public/$1/app/etc/
cp local.xml.vagrant local.xml

# Remount Dynamic data
mkdir -m 777 -p /vagrant_guest/public/$1/var
mount -o bind /vagrant_guest/public/$1/var /vagrant/$1/public/var

# Import DB (if not exists)
mageimport $1

# Output Magento links
# Get Magento settings
cd /vagrant/public/$1
if [ $(id -u) = "0" ]; then
	MAGE_PREFIX="$(su vagrant -c "magerun db:info prefix" 2> /dev/null)"
	MAGE_BACKEND="$(echo "Mage::getConfig()->getNode('admin/routers/adminhtml/args/frontName')->asArray()" | su vagrant -c "magerun -q -n dev:console" 2> /dev/null | sed -n 's/^=> "\([^"]*\)"/\1/gp')"
else
	MAGE_PREFIX="$(magerun db:info prefix 2> /dev/null)"
	MAGE_BACKEND="$(echo "Mage::getConfig()->getNode('admin/routers/adminhtml/args/frontName')->asArray()" | magerun -q -n dev:console 2> /dev/null | sed -n 's/^=> "\([^"]*\)"/\1/gp')"
fi

# run custom boot.sh if available
if [ -f "/vagrant/vagrant.boot.sh" ]; then
	dos2unix /vagrant/vagrant.boot.sh
	sh /vagrant/vagrant.boot.sh
fi

echo 'Magento Frontend: http://localhost:8080/'
echo 'Magento Backend: http://localhost:8080/'$MAGE_BACKEND'/'
echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'
