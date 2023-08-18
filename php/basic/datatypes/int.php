<?php
$x = 5;
$y = 0x2A; // hex number
$z = 055; // octo-number

$max = PHP_INT_MAX;            // int(9223372036854775807)
$maxPlusOne = PHP_INT_MAX + 1; // float(9.223372036854776E+18)

echo $x, $y, $z; echo "<br/>";
echo var_dump($max); echo "<br/>";
echo var_dump($maxPlusOne); echo "<br/>";

$a = (int) true;            // 1
$b = (int) false;           // 0
$c = (int) 5.98;            // 5
$d = (int) '5.99';          // 5
$e = (int) '85sadaslkd';    // 85
$f = (int) 'test';          // 0


var_dump($a);
var_dump($b);
var_dump($c);
var_dump($d);
var_dump($e);
var_dump($f); echo "<br/>";

// Use is_int() to check if a sth is an integer
$g = 2_000_000_000;
$h = 2.000;

var_dump(is_int($g));
var_dump(is_int($h));

