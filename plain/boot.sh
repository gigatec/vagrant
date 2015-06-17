#!/usr/bin/env bash

# Import DB (if not exists)
dbimport

echo 'Frontend: http://localhost:8080/'
echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'
