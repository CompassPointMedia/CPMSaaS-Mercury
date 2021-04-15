# configure users in the MySQL database
mysql -u root -proot < /var/www/tmp/data-install.sql

# remove the install script (but leave the uninstall script in place for reference)
rm /var/www/tmp/data-install.sql
