#!/usr/bin/env bash

sed 's/\r//g' -i /vagrant/.vagrant/environment
source /vagrant/.vagrant/environment
export RAILS_ENV=${RAILS_ENV:-development}
echo "Loading Rails environment: $RAILS_ENV"

# Import DB (if not exists)
rubyimport

# Run Rails server
rm -f /vagrant/rails/tmp/pids/server.pid
su - vagrant -c "cd /vagrant/rails; export RAILS_ENV=$RAILS_ENV; bundle exec rails s -d"
