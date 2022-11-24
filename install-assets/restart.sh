
sleep 5

# KNOWN ISSUE: when I log into the box and type `service apache2 status` it shows exited
# However I can run `vagrant up` again at that point, and it starts fine

echo "----- Start restart script -----"
source /etc/apache2/envvars

service apache2 restart

apache2 -V

apache2 -S

service apache2 status

echo "----- End restart script -----"