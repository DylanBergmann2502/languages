<?php

// Precedence
$x = 3 + 5 * 5; // * has higher precedence than +

echo $x; echo "<br/>";

$x = true;
$y = false;

$z = $x && $y;
var_dump($z);       // false

$z = $x and $y;
var_dump($z);       // true

$z = ($x and $y);   // it's recommended to use ()
var_dump($z);       // false

// Associativity
$x = $y = 5; // "$y = 5" is evaluated first then "$x = $y"

