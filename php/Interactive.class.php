<?php
/**
 * Class Interactive
 * @version 0.1
 *
 *  this has POTENTIAL to be an interactive script that, with some directions, a developer could inject a $steps array and have it work usably for them, but it's not there yet.  Get it there, and commit it to a code library
 *
 */


/*

[green or teal] Starting installation process!!
If you need to start installation over or change anything, see "Changes to Installation" in the README.md file
Creating tmp folder.. done
Creating mysql dump files.. done
Installing Vagrant box, I'll be back as soon as Vagrant is done..

[start]

 */



class Interactive
{
    /**
     * @var array $data     Associative array of user data
     */
    public $data = [];

    /**
     * @var array $steps
     */
    public $steps = [];

    public $validationErrorMessages = [
        'email' => 'Email not valid',
        'notBlank' => 'Value cannot be blank',
        'password' => 'Password must contain letters, numbers, at least one special character, and be 8 characters or more',
        'simpleDomainName' => 'Domain name must be a simple domain with no subdomain portion, containing a-z, 0-9 or a dash(-)',
    ];

    /**
     * Interactive constructor.
     * @param $steps array
     */
    public function __construct($steps)
    {
        $this->steps = $steps;
    }

    /**
     * Main execution method
     */
    public function execute()
    {
        $state = new stdClass();

        // Run through user interaction steps
        while (list($idx, $step) = $this->point($this->steps, $state)) {
            if (!empty($step['output'])) {
                $output = $step['output'];
                echo is_string($output) ? $this->render($output, $this->data) : $output($this->data);
                echo PHP_EOL;
            }
            if (!empty($step['prompt'])) {

                $state = new stdClass();
                $state->done = $this->dependency($step, $this->data);

                while (!$state->done) {

                    $state = $this->prompt($step, $idx, $state);

                }
            }
        }
        return $this->data;
    }

    /**
     * Handle user prompt
     *
     * @param $step
     * @param $idx
     * @param $state
     * @return mixed
     */
    public function prompt(&$step, $idx, $state)
    {
        // Handle default value first thing
        $default = null; # ie. no default value
        if (!empty($step['default'])) {
            $default = is_string($step['default']) ? $step['default'] : $step['default']($this->data);
        }

        // Handle user prompt
        $prompt = !empty($state->prompt) ? $state->prompt : $step['prompt'];

        echo is_string($prompt) ? $this->render($prompt, $this->data, $default) : $prompt($this->data);
        if (!empty($step['responses'])) {
            echo ' [' . implode('/', $step['responses']) . ']';
        }
        echo ': ';

        if (!empty($step['hidden'])) {
            $value = $this->prompt_silent();
        } else {
            $value = trim(fgets(STDIN));
        }

        // Assign default value if present and input is blank
        // Note default value will be handled by the same validation
        if (!strlen($value) && !is_null($default)) {
            $value = $default;
        }

        // Validate user response
        if (!empty($step['validate'])) {
            if (is_string($step['validate'])) {
                $a = explode(':', $step['validate']);
                $validator = array_shift($a);
                $call = 'validate' . ucfirst($validator);
                $format = $a;
                if (!method_exists($this, $call)) {
                    exit('SYSTEM ERROR: no validator `' . $validator . '` exists!');
                }
                $validation = $this->$call($value, $format);
            } else {
                $validation = $step['validate']($value);
            }

            // value can be true, false or null.  Use of null TBD
            if ($validation === false) {
                $state->done = false;
                if (!isset($state->prompt)) {
                    $state->prompt = rtrim($this->validationErrorMessages[$validator], '. ') . '. ' . $step['prompt'];
                }
                return $state;
            }
        }

        $this->data[!empty($step['id']) ? $step['id'] : $idx] = $value;

        // Handle confirm requests
        if (!empty($step['confirm'])) {
            if (!isset($state->original) ||
                ($state->original !== $value)) {

                $hadOriginal = isset($state->original);

                if (!isset($state->original)) {
                    $state->original = $value;
                }

                $state->done = false;

                $state->prompt = $hadOriginal && !empty($step['prompt_confirm_error']) ? $step['prompt_confirm_error'] :
                    (!empty($step['prompt_confirm']) ? $step['prompt_confirm'] : null);

                return $state;
            } else {

            }
        }

        $state->done = true;

        return $state;
    }

    /**
     * Currently no different than a foreach loop but designed to eventually move pointer based on state
     * for example, "Dependent child record set up.  Would you like to add another (y/n)?"
     * .. y would let them repeat those specific steps
     *
     * @param $steps
     * @return array|bool
     */
    public function point(&$steps)
    {
        $result = current($steps);
        $key = key($steps);
        if (!$result) {
            return false;
        }

        //where do we go from here?
        if (false) {
            //some exotic place
        } else {
            $next = next($steps);
        }
        return [$key, $result];
    }

    /**
     * Horribly named method, and doesn't allow for much.  Def needs rework
     * @param $step
     * @param $data
     * @return bool
     */
    public function dependency($step, $data)
    {
        if (!empty($step['dependency'])) {
            $dependency = $step['dependency'];
            if ($data[$dependency['key']] !== $dependency['value']) {
                return true;
            }
        }
        return false;
    }

    /**
     * This could be richer, for now just moves everything to the left with no respect for levels
     * @param $text
     * @param $level
     * @return string
     */
    public function indent($text, $level = 0)
    {
        $out = [];
        $text = trim($text);
        $text = explode("\n", $text);
        foreach ($text as $line) {
            $out[] = ltrim($line);
        }
        return implode("\n", $out);
    }

    /**
     * @param $string
     * @param $vars
     * @param null $default
     * @return string
     */
    public function render($string, $vars, $default = null)
    {
        $output = '';
        extract($vars);
        if (!is_null($default)) {
            $__default_value = $default;
        }
        $eval = '$output = "' . str_replace('"', '\\"', $string) . '";';
        eval ($eval);
        return $output;
    }

    /**
     * @return string|void
     */
    public function prompt_silent() {
        $prompt = ' ';
        if (preg_match('/^win/i', PHP_OS)) {
            $vbscript = sys_get_temp_dir() . 'prompt_password.vbs';
            file_put_contents(
                $vbscript, 'wscript.echo(InputBox("'
                . addslashes($prompt)
                . '", "", "password here"))');
            $command = "cscript //nologo " . escapeshellarg($vbscript);
            $password = rtrim(shell_exec($command));
            unlink($vbscript);
            return $password;
        } else {
            $command = "/usr/bin/env bash -c 'echo OK'";
            if (rtrim(shell_exec($command)) !== 'OK') {
                trigger_error("Can't invoke bash");
                return;
            }
            $command = "/usr/bin/env bash -c 'read -s -p \""
                . addslashes($prompt)
                . "\" mypassword && echo \$mypassword'";
            $password = rtrim(shell_exec($command));
            echo "\n";
            return $password;
        }
    }

    public function validateEmail($value, $format = [])
    {
        return filter_var($value, FILTER_VALIDATE_EMAIL);
    }

    public function validateNotBlank($value, $format = [])
    {
        return strlen(trim($value)) > 0;
    }

    public function validatePassword($value, $format = [])
    {
        $number = preg_replace('/[^0-9]+/', '', $value);
        $alpha = preg_replace('/[^a-zA-Z]+/', '', $value);
        $special = preg_replace('/[a-zA-Z0-9]+/', '', $value);
        return !(strlen($number) < 1 || strlen($alpha) < 1 || strlen($special) < 1 || strlen($value) < 8);
    }

    public function validateSimpleDomainName($value, $format = [])
    {
        return (bool) preg_match('/^[-a-z0-9]+\.[a-z]+$/i', $value);
    }

}