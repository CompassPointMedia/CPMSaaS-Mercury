# Add the following config file to /etc/apache2/sites-available, enable it, and start apache

echo Configuring Apache2...
mv /var/www/tmp/compasspoint-saas.com.conf /etc/apache2/sites-available
a2ensite compasspoint-saas.com.conf

