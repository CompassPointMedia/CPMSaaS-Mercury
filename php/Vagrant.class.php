<?php
/**
 * Class Vagrant
 *
 */

class Vagrant
{
    /**
     * @comment NOTE!! Don't change this unless you change it in the Vagrantfile as well!
     * @var string $baseIpAddress
     */
    public static $baseIpAddress = '192.168.33.201';

    public function execute($data) {
        if ($data['baseIpAddress'] != self::$baseIpAddress) {
            echo 'Updating Vagrantfile IP address..' . PHP_EOL;
            $this->changeVagrantfileIpAddress($data['baseIpAddress']);
        }
    }

    public function changeVagrantfileIpAddress($ip) {
        $string = implode('', file('Vagrantfile'));
        $string = str_replace(self::$baseIpAddress, $ip, $string);
        $fp = fopen('Vagrantfile', 'w');
        fwrite($fp, $string);
        fclose($fp);
    }
}
