<?php

// Return statement
function sum(int $x, int $y) {
    $z = $x + $y;
    return $z;
}

$x = sum(5,10);
echo $x; echo "<br/>";

// return; // return if put in the global scope will stop the execution of the script

echo 'Hello World';
