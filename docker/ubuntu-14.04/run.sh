#!/bin/sh

/etc/init.d/courier-authdaemon start
/etc/init.d/courier-imap start
/etc/init.d/postfix start
/etc/init.d/rsync start
/etc/init.d/mysql start
/etc/init.d/apache2 start
/etc/init.d/ondemand start
/etc/init.d/rc.local start

echo "Loading Docker System: ${DOCKER_SYSTEM}..."

case "$DOCKER_SYSTEM" in

wordpress)
	# Copy config file
	cp /vagrant/public/wp-config.php-vagrant /vagrant/public/wp-config.php

	# Import DB (if not exists)
	su - vagrant -c "wpimport"

	echo 'Frontend: http://localhost:8080/'
	echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
	echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'
	;;

magento)
	# Create local.xml Symlink
	cd /vagrant/public/$1/app/etc/
	cp local.xml.vagrant local.xml

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
	;;

*)
	# Import DB (if not exists)
	dbimport

	echo 'Frontend: http://localhost:8080/'
	echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
	echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'
	;;

esac

sleep infinity
