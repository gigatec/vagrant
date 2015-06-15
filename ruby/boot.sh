#!/usr/bin/env bash

source /vagrant/.vagrant/environment
export RAILS_ENV=${RAILS_ENV:-development}
echo "Loading Rails environment: $RAILS_ENV"

# Import DB (if not exists)
rubyimport

# Run Rails server
su - vagrant -c "cd /vagrant/rails; export RAILS_ENV=$RAILS_ENV; bundle exec rails s -d"