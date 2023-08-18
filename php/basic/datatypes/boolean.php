<?php

$isComplete = true;
$isNotComplete = false;
$isBool = false;
$isNotBool = [];

// int 0 -0 = false
// float 0.0 -0.0 = false
// '' = false
// '0' = false
// [] = false
// null = false

// When we print out a boolean value
// PHP automatically casts it into string
echo $isComplete; echo "<br/>";
echo $isNotComplete; echo "<br/>";

echo (string) $isComplete; echo "<br/>";
echo (string) $isNotComplete; echo "<br/>";

var_dump($isComplete);
var_dump((string) $isComplete); echo "<br/>";

var_dump($isNotComplete);
var_dump((string) $isNotComplete); echo "<br/>";

// Check if the variable is a boolean value
var_dump(is_bool($isBool));
var_dump(is_bool($isNotBool));
