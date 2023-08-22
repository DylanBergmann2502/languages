<?php

// If you wanna trigger a manual error => must use E_USER_* errors
trigger_error('Example Error', E_USER_WARNING);

echo 1; echo "<br/>";

function errorHandler(
    int $type,
    string $message,
    ?string $file = null,
    ?int $line = null
) {
    echo $type . ': ' . $message . ' in ' . $file . ' on line ' . $line;

    exit; // stop the script execution
}

error_reporting(E_ALL & ~E_WARNING);

echo $x; echo "<br/>"; // Suppress warning

set_error_handler('errorHandler', E_ALL);

echo $x; echo "<br/>";
