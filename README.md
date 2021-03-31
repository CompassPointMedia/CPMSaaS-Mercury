# CPMSaaS-Mercury
Vagrant and soon Docker installer for CPMSaaS

This installer does the following:
* Pulls Vagrant box inflectionpoint/throwaway2 (still in development, final box name will be different)
* Creates the folder structure for the CPMSaaS application
    * Creates the same structure dictated by `/etc/apache2/sites-available/compasspoint-saas.com.conf`
    * Adds a `/var/www/compasspoint-saas.com/private/config.php` file (located in `install-assets/config.php` in this repository)
    * Clones the CPMSaaS repository from https://github.com/CompassPointMedia/CPMSaaS
    * Runs composer, specifically to install box/spout which is needed for Excel file exports
    * Starts Apache2 gracefully with /etc/apache2/envvars loaded correctly
    

### Known Issues
For some reason `service apache2 restart` shows successful in the files.sh script output, but logging in 
    
### Usage

Just run `vagrant up`.
Then, copy the lines from `install-assets/hosts` to your computer's `/etc/hosts` file.
Then, log in:
    ssh root@192.168.33.103
and start Apache2 (see Known Issues above) with `yo-apache-start`


### Additional Information

Read the README file for https://github.com/CompassPointMedia/CPMSaaS
