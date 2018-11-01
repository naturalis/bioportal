#!/bin/bash
cd /var/www/drupal
if [ ! -d library ]; then
    echo "Library directory not found"
    mkdir library
fi
if [ ! -d library/bioportal-client ]; then
    echo "bioportal-client missing"
    ln -s /opt/git/bioportal-php-client library/bioportal-client
fi
if [ ! -d profiles/naturalis ]; then
    echo "naturalis profile missing"
    ln -s /opt/git/drupal_naturalis_installation_profile/naturalis profiles/naturalis
    #drush cc all
fi
if [ ! -f customhtaccess ]; then
    echo "customhtaccess missing"
    cp /root/customhtaccess .
fi
