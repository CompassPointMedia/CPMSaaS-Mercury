<?php
/**
 * Class ColorCode
 * @credit: https://codereview.stackexchange.com/questions/77490/printing-to-terminal-in-a-color
 * @also:
 */

class ColorCode{

    const CC_DARK_GRAY = "1;30";
    const CC_LIGHT_GRAY = "0;37";
    const CC_BLUE = "0;34";
    const CC_GREEN = "0;32";
    const CC_CYAN = "0;36";
    const CC_RED = "0;31";

    const CC_CLEAR = "0";
}

function echolor($text, $color) {
    $close = (strlen($color) ? "\033[" . ColorCode::CC_CLEAR . 'm' : '');
    $color = "\033[" . $color . 'm';
    echo $color . $text . $close;
}
