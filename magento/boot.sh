#!/usr/bin/env bash

# Create local.xml Symlink
cd /vagrant/public/app/etc/
cp local.xml.vagrant local.xml

# Clear magento cache
mageclean
