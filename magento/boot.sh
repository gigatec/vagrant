#!/usr/bin/env bash

# Create local.xml Symlink
cd /vagrant/public/app/etc/
cp local.xml.vagrant local.xml

# Import DB (if not exists)
mageimport

# Output Magento links
# Get Magento settings
cd /vagrant/public/
if [ $(id -u) = "0" ]; then
	MAGE_PREFIX="$(su vagrant -c "magerun db:info prefix" 2> /dev/null)"
	MAGE_BACKEND="$(echo "Mage::getConfig()->getNode('admin/routers/adminhtml/args/frontName')->asArray()" | su vagrant -c "magerun -q -n dev:console" 2> /dev/null | sed -n 's/^=> "\([^"]*\)"/\1/gp')"
else
	MAGE_PREFIX="$(magerun db:info prefix 2> /dev/null)"
	MAGE_BACKEND="$(echo "Mage::getConfig()->getNode('admin/routers/adminhtml/args/frontName')->asArray()" | magerun -q -n dev:console 2> /dev/null | sed -n 's/^=> "\([^"]*\)"/\1/gp')"
fi

echo 'Magento Frontend: http://localhost:8080/'
echo 'Magento Backend: http://localhost:8080/'$MAGE_BACKEND'/'
echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'
