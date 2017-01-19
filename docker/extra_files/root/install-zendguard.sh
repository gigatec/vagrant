#!/usr/bin/env bash

# copy ioncube libs to php5 dir
cp ./zendguard/zend-loader-php5.6-linux-x86_64/ZendGuardLoader.so /usr/lib/php/20131226/
cp ./zendguard/zend-loader-php5.6-linux-x86_64/opcache.so /usr/lib/php/20131226/

# copy php5 config
cp ./01-zendguard.ini /etc/php/5.6/fpm/conf.d/
cp ./01-zendguard.ini /etc/php/5.6/apache2/conf.d/

# restart apache
service apache2 restart
