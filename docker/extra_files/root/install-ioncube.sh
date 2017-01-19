#!/usr/bin/env bash

# copy ioncube libs to php5 dir
cp ./ioncube/ioncube_loader_lin_5.6.so /usr/lib/php/20131226/

# copy php5 config
cp ./01-ioncube.ini /etc/php/5.6/fpm/conf.d/
cp ./01-ioncube.ini /etc/php/5.6/apache2/conf.d/

# restart apache
service apache2 restart
