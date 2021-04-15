# Add the following files for web structure and any other assets here

echo Provisioning log folder, private configuration file and application repositories...
date > /etc/vagrant_provisioned_at

# export DEBIAN_FRONTEND=noninteractive

mkdir /var/www/compasspoint-saas.com
cd /var/www/compasspoint-saas.com

mkdir private

# place the config.php file in place with the master MySQL connection
mv /var/www/tmp/config.php /var/www/compasspoint-saas.com/private

mkdir log

touch log/error.log
touch log/access.log

git clone https://github.com/CompassPointMedia/CPMSaaS.git public_html

cd public_html
echo Running composer...
which composer
composer require box/spout:2.7


