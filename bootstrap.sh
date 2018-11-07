#!/bin/bash
cd /var/www/html
zcat /opt/project/bioportal.sql.gz | /usr/local/bin/drush sql-cli
chmod -R 755  sites/default
/bin/cp -Rf /opt/project/default/files sites/default/files
/bin/cp -Rf /opt/project/default/modules sites/default/modules
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
fi
if [ ! -d dashboard ]; then
    echo "Bioportal dashboard is missing ... linking bioportal dashboard"
    ln -s /opt/project/bioportal-dashboard dashboard 
fi
if [ ! -f customhtaccess ]; then
    echo "customhtaccess missing ... copying customhtaccess"
    cp /opt/project/customhtaccess .
    cp /opt/project/.htaccess
fi
if [ ! -f sitemap ]; then
    echo "Sitemap is missing ... linking to sitemap"
    ln -s /opt/project/bioportal_sitemap_generator/sitemap sitemap
fi
if [ ! -f sitemap-index.xml ]; then
    echo "Sitemap-index.xml is missing ... linking to sitemap-index.xml"
    ln -s /opt/project/bioportal_sitemap_generator/sitemap/sitemap-index.xml sitemap-index.xml 
fi
if [ ! -f library/bioportal-client/config/client.ini ]; then
    cp library/bioportal-client/config/client.ini.tpl library/bioportal-client/config/client.ini
fi
/usr/bin/yes | drush make --no-core /opt/project/bioportal.make
/usr/bin/yes | /usr/local/bin/drush en naturalis_theme
drush @none dl registry_rebuild-7.x
/usr/bin/yes | drush rr
/usr/bin/yes | drush cc all
