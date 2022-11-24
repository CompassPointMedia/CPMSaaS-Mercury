<?php
/**
 * Class DatabaseTemplate
 *
 */

class DatabaseTemplate
{
    public $data = [];

    public static function validateTmpFolder() {
        if (!is_dir('./tmp')) {
            $result = mkdir('./tmp');
            if (!$result) {
                exit('unable to create directory tmp' . PHP_EOL);
            }
        }
        if (!is_writable('./tmp')) {
            exit('tmp folder is not writable' . PHP_EOL);
        }
    }

    public function __construct($data) {
        $this->data = $data;
    }

    public function execute() {
        $data = $this->data;
        $data['username'] = $this->generateUsernameFromFirstLast($data['firstName'], $data['lastName']);
        $data['passwordMd5'] = md5($data['password']);
        if ($data['otherUser']) {
            $data['userPasswordMd5'] = md5($data['userPassword']);
            $data['userUsername'] = $this->generateUsernameFromFirstLast($data['userFirstName'], $data['userLastName'], $data['username']);
        }

        // read the template
        $templateString = $this->read('sql-template.sql');
        $templateStringUninstall = $this->read('sql-template-uninstall.sql'); // not used but available if needed
        $variables = [
            'master-mysql-username' => $this->generateUsername(),
            'master-mysql-password' => $this->generatePassword(),
            'master-mysql-database' => $this->generateDbName('master'),  // This is the M value but it's not used in the subdomain

            'saas-account-username' => $this->generateUsername(),
            'saas-account-password' => $this->generatePassword(),

            'nwventures-username' => $this->generateUsername(),
            'nwventures-password' => $this->generatePassword(),
            'nwventures-database' => $this->generateDbName(),


            'user-account-username' => $this->generateUsername(),
            'user-account-password' => $this->generatePassword(),
            'user-account-database' => $this->generateDbName(),

            'user-unique-identifier-primary' => $this->generateUniqueIdentifier(),
            'user-unique-identifier-user' => $this->generateUniqueIdentifier(),
        ];


        // set template values
        foreach ($variables as $key => $value) {
            $templateString = str_replace('{' . $key . '}', $value, $templateString);
            $templateStringUninstall = str_replace('{' . $key . '}', $value, $templateStringUninstall);
        }
        $this->write('tmp/data-uninstall.sql', $templateStringUninstall);

        $includeFiles = [
            'data-master-mysql-database.sql',
            'data-nwventures-database.sql',
            'data-user-account-database.sql',
            'data-additional-user.sql',
        ];
        $includeString = [];

        foreach ($includeFiles as $includeFile) {

            // only add specs for the additional user if requested
            if ($includeFile === 'data-additional-user.sql' && $data['otherUser'] !== true) {
                continue;
            }

            $string = $this->read($includeFile);
            foreach ($data as $key => $value) {
                if (is_numeric($key)) continue;
                $sanitized = str_replace("'", "\\'", $value);
                $string = str_replace('{' . $key . '}', $sanitized, $string);
            }
            foreach ($variables as $key => $value) {
                $sanitized = str_replace("'", "\\'", $value);
                $string = str_replace('{' . $key . '}', $sanitized, $string);
            }
            $includeString[$includeFile] = $string;

            $insertLine = '-- import ' . $includeFile;
            $templateString = str_replace($insertLine, $insertLine . PHP_EOL . $string, $templateString);
        }
        $this->write('tmp/data-install.sql', $templateString);


        // Create the CodeIgniter config.php file which will contain the master MySQL user/password
        $configString = $this->read('config-template.php');
        foreach ($variables as $key => $value) {
            $configString = str_replace('{' . $key . '}', $value, $configString);
        }
        $this->write('tmp/config.php', $configString);


        // Create the /etc/hosts file with lines the user will need for local operations
        $hostsString = $this->read('hosts-template');
        foreach ($data as $key => $value) {
            $hostsString = str_replace('{' . $key . '}', $value, $hostsString);
        }
        $this->write('tmp/hosts', $hostsString);

        // Create the Apache .conf file
        $confString = $this->read('compasspoint-saas.com-template.conf');
        foreach ($data as $key => $value) {
            $confString = str_replace('{' . $key . '}', $value, $confString);
        }
        $this->write('tmp/compasspoint-saas.com.conf', $confString);

        // Create misc. files for bash to read
        $this->write('tmp/account', $this->data['accountIdentifier']);
        $this->write('tmp/domain', $this->data['baseDomain']);
    }

    public function generateDbName($type = '') {
        $str = $type === 'master' ? 'M0' : 'T0';
        $str .= rand(10, 99);
        $str .= strtoupper(substr(md5(rand()), 0, 5));
        return $str;
    }

    public function generateUsername() {
        return 'a' . substr(md5(rand()), 0, 8);
    }

    public function generatePassword() {
        return substr(md5(rand()), 0, 12);
    }

    public function generateUniqueIdentifier() {
        // Has same criteria for now
        return $this->generatePassword();
    }

    public function generateUsernameFromFirstLast($first, $last, $existing = '') {
        $first = preg_replace('/[^a-z]+/i', '', $first);
        $first = !empty(substr($first, 0, 1)) ? substr($first,0,1) : 'a';
        $last = preg_replace('/[^a-z]+/i', '', $last);
        $username = strtolower($first . $last);
        if ($username === $existing) {
            $username .= '2'; //good enough
        }
        return $username;
    }

    public function read($file) {
        return implode('', file('install-assets/' . $file));
    }

    public function write($file, $data) {
        $fp = fopen($file, 'w');
        $result = fwrite($fp, $data);
        fclose($fp);
        return $result;
    }
}
