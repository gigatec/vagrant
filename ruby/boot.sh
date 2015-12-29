#!/usr/bin/env bash

if [ -f /vagrant/.vagrant/environment ]; then
	sed 's/\r//g' -i /vagrant/.vagrant/environment 2> /dev/null
	source /vagrant/.vagrant/environment 2> /dev/null
fi

export RAILS_ENV=${RAILS_ENV:-development}
echo "Loading Rails environment: $RAILS_ENV"

# Remount Dynamic data
mkdir -m 777 -p /vagrant_guest/public/tmp /vagrant_guest/public/log
mount -o bind /vagrant_guest/public/tmp /vagrant/public/tmp
mount -o bind /vagrant_guest/public/log /vagrant/public/log

# Import DB (if not exists)
rubyimport

# Run Rails server
rm -f /vagrant/public/tmp/pids/server.pid
su - vagrant -c "cd /vagrant/public; export RAILS_ENV=$RAILS_ENV; bundle exec rails s -d"

echo 'Frontend: http://localhost:3000/'
echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'