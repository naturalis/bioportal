#!/bin/bash
cd /var/www/html
/bin/cat /opt/project/bioportal.sql | /usr/local/bin/drush sql-cli
mkdir /var/www/html/sites/default/files
mkdir /var/www/html/sites/default/modules
/bin/cp -r /opt/project/sites/default/files/* sites/default/files/
/bin/cp -r /opt/project/sites/default/modules/* sites/default/modules/
/usr/bin/yes | drush make --no-core /opt/project/bioportal.make
/usr/bin/yes | /usr/local/bin/drush cc all
/usr/bin/yes | /usr/local/bin/drush en naturalis_theme
rm -rf sites/all
ln -s /opt/project/ndabio/all sites/all
if [ ! -d library ]; then
    echo "Library directory not found ... creating library"
    mkdir library
fi
if [ ! -d library/bioportal-client ]; then
    echo "Bioportal-client missing ... linking bioportal-client"
    ln -s /opt/project/bioportal-php-client library/bioportal-client
fi
if [ ! -d profiles/naturalis ]; then
    echo "Naturalis profile missing ... linking naturalis profile"
    ln -s /opt/project/drupal_naturalis_installation_profile/naturalis profiles/naturalis
    drush cc all
fi
if [ ! -d dashboard ]; then
    echo "Bioportal dashboard is missing ... linking bioportal dashboard"
    ln -s /opt/project/bioportal-dashboard dashboard 
fi
if [ ! -f customhtaccess ]; then
    echo "customhtaccess missing ... copying customhtaccess"
    cp /opt/project/customhtaccess .
fi
if [ ! -f sitemap ]; then
    echo "Sitemap is missing ... linking to sitemap"
    ln -s /opt/project/bioportal_sitemap_generator/sitemap sitemap
fi
if [ ! -f sitemap-index.xml ]; then
    echo "Sitemap-index.xml is missing ... linking to sitemap-index.xml"
    ln -s /opt/project/bioportal_sitemap_generator/sitemap/sitemap-index.xml sitemap-index.xml 
fi
/usr/bin/yes | drush cc all
