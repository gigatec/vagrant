#!/bin/sh

/etc/init.d/courier-authdaemon start
/etc/init.d/courier-imap start
/etc/init.d/postfix start
/etc/init.d/rsync start
/etc/init.d/mysql start
/etc/init.d/apache2 start
/etc/init.d/ondemand start
/etc/init.d/rc.local start

/bin/sh /vagrant/vagrant/wordpress/boot.sh

sleep infinity
