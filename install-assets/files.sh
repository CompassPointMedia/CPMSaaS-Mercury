# Add the following files for web structure and any other assets here

echo Provisioning log folder, private configuration file and application repositories...
date > /etc/vagrant_provisioned_at

# export DEBIAN_FRONTEND=noninteractive

rm -rf /var/www/compasspoint-saas.com
mkdir /var/www/compasspoint-saas.com
cd /var/www/compasspoint-saas.com
mkdir private
cp /var/www/install-assets/config.php private
mkdir log
touch log/error.log
touch log/access.log
git clone https://github.com/CompassPointMedia/CPMSaaS.git public_html

# yo-apache-start - see root/.bash_profile
# BUG/ISSUE: when I log into the box and type `service apache2 status` it shows exited
# However I can run this again at that point, and it works fine
source /etc/apache2/envvars && service apache2 restart && apache2 -V && apache2 -S && service apache2 status


