<?php
/**
 * steps remaining on this:
 * 1. need colors and detection of shell
 * 2. place the SQL outputter in a remote location for loading current configuration
 */
require 'php/Interactive.class.php';
require 'php/DatabaseTemplate.class.php';
require 'php/Vagrant.class.php';
require 'php/ColorCode.class.php';

$baseIpAddress = Vagrant::$baseIpAddress;


/**
 * @version: 0.1.01  First-ever interview; creates user, account and extra user if desired
 */
$steps = [
    'introduction' => [
        'output' => 'Welcome to the Mercury installer!  I\'ll be guiding you through the setup process
This is going to gather information to set up your data management account, provision an inflectionpoint/<better-name-here> Vagrant box, and then set the database in MySQL.
Please be sure you\'ve read the "Installation Instructions" in the README.md file first.' . PHP_EOL,
    ],
    [
        'prompt' => 'Continue?',
        'responses' => ['y','n'],
        'validate' => function ($value) {
            if (!strlen(trim($value))) {
                return true;
            }
            if (!in_array(strtolower(substr($value, 0, 1)), ['y', 1,])) {
                echo PHP_EOL . 'exiting..' . PHP_EOL;
                exit(0);
            }
            return true;
        },
    ],
    [
        'output' => 'Ok, here we go..',
    ],
    [
        'id' => 'baseIpAddress',
        'prompt' => 'Enter an IP address for your Vagrant box, should start with 192.168 ($__default_value)',
        'validate' => 'ipAddress',
        'default' => $baseIpAddress,
    ],
    [
        'id' => 'baseDomain',
        'prompt' => 'Enter a base domain name for your application for your /etc/hosts file ($__default_value)',
        'validate' => 'simpleDomainName',
        'default' => 'compasspoint-saas-vagrant-local.com',
    ],
    [
        'id' => 'firstName',
        'prompt' => 'Your first name',
        'validate' => 'notBlank',
    ],
    [
        'id' => 'lastName',
        'prompt' => 'Your last name',
        'validate' => 'notBlank',
    ],
    [
        'id' => 'email',
        'prompt' => 'Your email',
        'validate' => 'email',
    ],
    [
        'id' => 'password',
        'prompt' => 'Create a password',
        'prompt_confirm' => 'Re-type password',
        'prompt_confirm_error' => 'Passwords do not match! Re-type password',
        'confirm' => true,
        'hidden' => true,
        'validate' => 'password',
    ],
    [
        'output' => PHP_EOL . 'OK, Welcome $firstName $lastName <$email>!\\nI am now going to set up an account for you.  It could be your own name, or your company name.',
    ],
    'accountName' => [
        'id' => 'accountName',
        'prompt' => 'Your account name ($firstName $lastName)',
        'default' => function ($data) {
            return $data['firstName'] . ' ' . $data['lastName'];
        },
    ],
    [
        'id' => 'accountIdentifier',
        'prompt' => 'Your account identifier. Letters, numbers and dashes only, cannot start or end with a dash ($__default_value)',
        'default' => function ($data) {
            $accountIdentifier = strtolower($data['accountName']);
            $accountIdentifier = preg_replace('/[^-0-9a-z]*/', '', $accountIdentifier);
            $accountIdentifier = trim($accountIdentifier, '-');
            $accountIdentifier = substr($accountIdentifier, 0, 30);
            return $accountIdentifier;

        },
        'validate' => 'notBlank',
    ],
    [
        'id' => 'accountDescription',
        'prompt' => '(Optional) A brief description of your account or company (what it does, goals, etc.)'
    ],
    'otherUser' => [
        'id' => 'otherUser',
        'prompt' => 'Would you like to create another (non-admin) user in <$accountIdentifier>?',
        'responses' => ['y', 'n'],
        'validate' => function (&$value) {
            if (!strlen(trim($value))) {
                $value = true;
                return;
            }
            if (!in_array(strtolower(substr($value, 0, 1)), ['y', 1,])) {
                $value = false;
                return;
            }
            $value = true;
        },
    ],
    [
        'id' => 'userFirstName',
        'prompt' => 'Their first name',
        'dependency' => [
            'key' => 'otherUser',
            'value' => true,
        ],
        'validate' => 'notBlank',
    ],
    [
        'id' => 'userLastName',
        'prompt' => 'Their last name',
        'dependency' => [
            'key' => 'otherUser',
            'value' => true,
        ],
        'validate' => 'notBlank',
    ],
    [
        'id' => 'userEmail',
        'prompt' => 'Their email',
        'dependency' => [
            'key' => 'otherUser',
            'value' => true,
        ],
        'validate' => 'email',
    ],
    [
        'id' => 'userPassword',
        'prompt' => 'Create their password',
        'prompt_confirm' => 'Re-type password',
        'prompt_confirm_error' => 'Passwords do not match! Re-type password',
        'confirm' => true,
        'hidden' => true,
        'dependency' => [
            'key' => 'otherUser',
            'value' => true,
        ],
        'validate' => 'password',
    ],
    'summary' => [
        'id' => 'summary',
        'prompt' => function ($data) {
            $prompt = PHP_EOL . "Here is the information you are creating:" . PHP_EOL;

            $list = [];
            $pad = 0;
            foreach ($data as $n => $v) {
                if (is_numeric($n) || in_array($n, ['otherUser', 'summary'])) {
                    continue;
                }
                $label = ucfirst($n);
                $label = preg_replace('/([a-z])([A-Z])/', '$1 $2', $label);
                $pad = max($pad, strlen($label));
                $list[$label] = $v;
            }
            foreach ($list as $label => $value) {
                $prompt .= str_pad($label, $pad, ' ', STR_PAD_LEFT) . ': ';
                if (stristr($label, 'password')) {
                    $prompt .= '(hidden)';
                } else if (is_bool($value)) {
                    $prompt .= ($value ? 'Yes' : 'No');
                } else if (!strlen($value)) {
                    $prompt .= '(none)';
                } else {
                    $prompt .= $value;
                }
                $prompt .= PHP_EOL;
            }

            $prompt .= 'Is this information correct?';
            return $prompt;
        },
        'responses' => ['y','n'],
        'validate' => function ($value) {
            if (!strlen(trim($value))) {
                return true;
            }
            if (!in_array(strtolower(substr($value, 0, 1)), ['y', 1,])) {
                echo PHP_EOL . 'exiting..' . PHP_EOL;
                exit(0);
            }
            return true;
        },
    ]
];

// validate this first
DatabaseTemplate::validateTmpFolder();

// get the defaults for dev testing if present
$defaults = [];
$defaultsFile = 'install-assets/defaults.json';
if (file_exists($defaultsFile)) {
    echolor(PHP_EOL . "*** Entering defaults values mode for dev testing; this is because you have file install-assets/defaults.json present ***" . PHP_EOL . PHP_EOL, ColorCode::CC_CYAN);
    $defaults = implode('', file($defaultsFile));
    $defaults = json_decode($defaults, true);
}

$interactive = new Interactive($steps, $defaults);
$data = $interactive->execute();

// print_r($data);

// echo json_encode($data) . PHP_EOL;

$vagrant = new Vagrant();
$vagrant->execute($data);

$template = new DatabaseTemplate($data);
$template->execute();

echolor("Completed MySQL and Apache file asset creation.." . PHP_EOL . PHP_EOL, ColorCode::CC_GREEN);


