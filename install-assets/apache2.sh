# Add the following config file to /etc/apache2/sites-available, enable it, and start apache

echo Configuring Apache2...
cp /var/www/install-assets/compasspoint-saas.com.conf /etc/apache2/sites-available
cd /etc/apache2/sites-enabled
ln -s ../sites-available/compasspoint-saas.com.conf

cd ~

# yo-apache-start - see root/.bash_profile
# BUG/ISSUE: when I log into the box and type `service apache2 status` it shows exited
# However I can run this again at that point, and it works fine
source /etc/apache2/envvars && service apache2 restart && apache2 -V && apache2 -S && service apache2 status

