#!/usr/bin/env bash

# Ignore the post install questions
export DEBIAN_FRONTEND=noninteractive

# Update Apt
# --------------------
echo 'Update Apt...'
apt-get update

echo "-- Install tools and helpers --"
apt-get install -y python-software-properties curl

echo "-- Install PPA's --"
add-apt-repository ppa:ondrej/php-7.0

# Install Apache & PHP
# --------------------
echo 'Install Apache & PHP...'
apt-get install -y vim
apt-get install -y git
apt-get install -y dos2unix
apt-get install -y apache2
apt-get install -y zip
apt-get install -y php7.0-cli php7.0-common libapache2-mod-php7.0 php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-gd php7.0-mysql php7.0-bz2 php-xml php7.0-soap php7.0-zip

# Install PHPMyAdmin
apt-get install -y phpmyadmin
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

php7enmod mcrypt

# Change Apache settings (User: vagrant, Group: vagrant)
sed -i 's/www-data/vagrant/g' /etc/apache2/envvars

# Change PHP settings (short_open_tag, ...)
sed 's/short_open_tag = Off/short_open_tag = On/g' -i /etc/php/7.0/apache2/php.ini
sed 's/^post_max_size.*$/post_max_size = 50M/g' -i /etc/php/7.0/apache2/php.ini
sed 's/^upload_max_filesize.*$/upload_max_filesize = 50M/g' -i /etc/php/7.0/apache2/php.ini
sed 's/^max_execution_time = .*/max_execution_time = 240/g' -i /etc/php/7.0/apache2/php.ini
sed 's/^; max_input_vars = .*/max_input_vars = 1500/g' -i /etc/php/7.0/apache2/php.ini

#sed 's/auto_prepend_file =.*/auto_prepend_file = custom_functions.php/g' -i /etc/php5/apache2/php.ini

# Copy custom PHP files to /usr/share/php
cp /vagrant/vagrant/php/* /usr/share/php

# Delete default apache web dir and symlink mounted vagrant dir from host machine
# --------------------
rm -rf /var/www/html
ln -fs /vagrant/public /var/www/html

# Install Composer
# --------------------
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
sudo chmod +x /usr/bin/composer

# Replace contents of default Apache vhost
# --------------------
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
NameVirtualHost *:8080
Listen 8080
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
<VirtualHost *:8080>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
EOF

# Activate XDebug
cat >> /etc/php5/apache2/php.ini <<EOF
[xdebug]
xdebug.remote_enable=1
xdebug.remote_host="172.28.128.1"
xdebug.remote_port=9000
xdebug.remote_handler="dbgp"
EOF

a2enmod rewrite
service apache2 restart

# Mysql
# --------------------
# Install MySQL quietly
echo 'Install MySQL...'
apt-get -q -y install mysql-server

# Activate mysql root user from outside
mysql -u root <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '';
FLUSH PRIVILEGES;
EOF

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

# install mailling softtware
apt-get install -y postfix courier-imap roundcube

# activate history page up/down in inputrc
sed 's/^# \(.*history-search.*\)$/\1/g' -i /etc/inputrc

# activate AllowNoPassword in phpmyadmin config
sed 's#// \(.*AllowNoPassword.*\)$#\1#g' -i /etc/phpmyadmin/config.inc.php

# create vagrant maildir
su vagrant -c 'maildirmake /home/vagrant/Maildir'

# modify postfix main.cf
cat >> /etc/postfix/main.cf << EOF
home_mailbox = Maildir/
mailbox_command =
virtual_maps = regexp:/etc/postfix/virtual-regexp
EOF

# create postfix virtual-regexp
cat > /etc/postfix/virtual-regexp << EOF
/.+@.+/ vagrant@localhost
EOF
postmap /etc/postfix/virtual-regexp

# disable postfix bouncing
sed 's/^.*bounce.*$/#\0/g' -i /etc/postfix/master.cf

# activate roundcube aliases
sed 's/^# *\(.*Alias.*\)$/\1/g' -i /etc/roundcube/apache.conf

# fix roundcube permissions
chown vagrant /etc/roundcube/ -R

# run custom init.sh if available
if [ -f "/vagrant/vagrant.init.sh" ]; then
	dos2unix /vagrant/vagrant.init.sh
	sh /vagrant/vagrant.init.sh
fi

# restart services
service apache2 restart
service postfix restart
service courier-imap restart
