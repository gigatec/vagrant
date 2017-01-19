#!/bin/sh

/etc/init.d/courier-authdaemon start
/etc/init.d/courier-imap start
/etc/init.d/postfix start
/etc/init.d/mysql start
/etc/init.d/apache2 start
/etc/init.d/rc.local start

# Import DB (if not exists)
dbimport

echo 'Frontend: http://localhost:8080/'
echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'

cd /vagrant/public

if ! bundle exec rails s -p 3000 -b '0.0.0.0' -e development; then
	bundle install
	bundle exec rails s -p 3000 -b '0.0.0.0' -e development
fi
