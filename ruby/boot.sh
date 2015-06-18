#!/usr/bin/env bash

sed 's/\r//g' -i /vagrant/.vagrant/environment
source /vagrant/.vagrant/environment
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
