#!/usr/bin/env bash

# Create local.xml Symlink
cd /vagrant/public/
#ln -fs $(find . -type d -name 'typo3_src-*' | sort -V | tail -1) typo3_src
ln -fs typo3_src/typo3 typo3
ln -fs typo3_src/index.php index.php

# TYPO3-DB import
typo3import

composer self-update
composer update

echo 'TYPO3 Frontend: http://localhost:8080/'
echo 'TYPO3 Backend: http://localhost:8080/typo3/'
echo 'PHPMyAdmin: http://localhost:8080/phpmyadmin/ (User: root, Pass: )'
echo 'Webmail: http://localhost:8080/roundcube/ (User: vagrant, Pass: vagrant, Host: localhost)'