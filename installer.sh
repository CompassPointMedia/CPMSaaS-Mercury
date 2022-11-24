php php/install.php


vagrant up

echo 'Copy the following to your /etc/hosts file:'
echo
cat tmp/hosts
echo

VAGRANT_IP=`grep -oE '192\.168\.[0-9]+\.[0-9]+' Vagrantfile`

if [[ -n $VAGRANT_IP ]]; then
  echo Attempting to restart Apache...
  echo '(if you check right now it is probably not running; help in solving this appreciated)'
  ssh root@$VAGRANT_IP service apache2 restart

fi

can_open=`which open`

if [[ -n $can_open ]]; then
    echo Opening application in default browser..
    my_domain=$(<tmp/domain)
    my_account=$(<tmp/account)
    open "http://$my_account.$my_domain/"
fi
