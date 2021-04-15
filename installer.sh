echo Running Mercury installer with PHP found at $(which php), version:
php --version
php ./php/install.php

echo Running vagrant up command, I will notify you when successfully completed...
vagrant up
echo vagrant up command completed, be sure and add the lines found in tmp/hosts to your /etc/hosts file
