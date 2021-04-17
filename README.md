### Short and Simple Instructions

1. Make sure `installer.sh` in the root directory is executable.  `chmod a-x installer.sh` should work if needed.
2. Run `./installer.sh` and follow the prompts
3. On your local machine, copy the lines from `tmp/hosts` into your computer's /etc/hosts file

You can now go to http://youraccount.yourdomain.com/ and log in with the email and password you created!
NOTE: see Known Bugs below on starting Apache

### Known Bugs

Okay, I pretty much give up for now.  I have not been able to reliably start Apache so you can just /GO/ to your URL.  You'll probably to log into your box (as root with password `root`), and type `yo-apache-start`.  If you have a solution to this (to start Apache on initial provisioning, and also every time `vagrant up` is called), please let me know!

### More Detail
There is actually quite a bit that happens during the install process.  This installer does the following:
* Gets the Vagrant box inflectionpoint/<need-a-better-name> which is a ready-to-go Vagrant box for CodeIgniter 4.  See ___ for more details on the box
* Adds an Apache configuration file `/etc/apache2/sites-available/compasspoint-saas.com.conf`
* Creates the same structure dictated by that file in /var/www/compasspoint-saas.com
* Creates three databases:
	* A Control database which runs CompassPoint SAAS
	* The Northwest Ventures Database which has some basic tables with sample data[1]
	* Your user database based on your interview during the install process
* Creates internal MySQL users with permissions to the specific account databases (one database = one account = one subdomain currently)
* Creates a `config.php` file in the `private` folder; this contains the "master" MySQL connection to the Control database and all the account databases
* Creates the `hosts` file; add these lines to your `/etc/hosts` for local testing on your computer.  NOTE: since CompassPoint SAAS uses subdomains to determine the account, you can't get to a specific account by simply accessing http://<base-ip-address>

### About Provisioning
The above scripts for setting up Apache and MySQL are one-offs; if there was a problem creating the VM, you may need to rebuild your box, or manually fix the problem.  Note that there is a script in Vagrantfile set to run always, that (re)starts Apache2 each time you enter `vagrant up`.  There's also a shortcut command `yo-apache-start` when you log in as root found in `.bash_profile`.

### Requirements
Running the installer requires PHP.  Probably ANY version of PHP.  No database, just PHP.  Go on, hold your nose and install it if you don't have it, you can uninstall it afterward; it was easiest for me to write the content manipulation needed in PHP (which I can do in my sleep) vs. say Python.

### Additional Information

Read the README file for https://github.com/CompassPointMedia/CPMSaaS


Footnotes:
[1] As of 4/15/2021, there is not much data or examples at all; more useful data and structure will be added in the future
