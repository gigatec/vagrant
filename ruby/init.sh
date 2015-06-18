#!/usr/bin/env bash

# Mysql
# --------------------
# Ignore the post install questions
export DEBIAN_FRONTEND=noninteractive

# Copy custom commands to /usr/local/bin
sudo cp /vagrant/vagrant/bin/* /usr/local/bin
sudo chmod +x /usr/local/bin/*

# Custom Linux/Bash settings
echo 'alias dir="ls -al"' >> /etc/profile
echo 'alias root="sudo -i"' >> /etc/profile
echo 'cd /vagrant/public' >> /etc/profile

# Install imagemagick
echo 'Install imagemagick...'
apt-get install -y imagemagick libmagickwand-dev

# Install bundler & init project
su - vagrant -c 'cd /vagrant/public/; gem install bundler; rbenv rehash; bundle install'
