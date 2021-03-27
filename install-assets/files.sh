# Add the following files for web structure and any other assets here

echo Provisioning log folder, private configuration file and application repositories...
date > /etc/vagrant_provisioned_at

# export DEBIAN_FRONTEND=noninteractive

mkdir /var/www/compasspoint-saas.com
cd /var/www/compasspoint-saas.com
mkdir private
cp /var/www/install-assets/config.php private
mkdir log
touch log/error.log
touch log/access.log
git clone https://github.com/CompassPointMedia/CPMSaaS.git public_html

