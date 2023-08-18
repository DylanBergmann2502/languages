<?php

$x = 13.5;
$y = 13.5e-3;
$max = PHP_FLOAT_MAX;
$inf = PHP_FLOAT_MAX * 2;

var_dump($x);
var_dump($y);
var_dump($max); echo "<br/>";

echo floor((0.1 + 0.7) * 10); // 7.9999999991118 => 7
echo ceil((0.1 + 0.2) * 10);  // 3.0000000000004 => 4
echo "<br/>";

echo log(-1);
echo $inf; echo "<br/>";

var_dump(is_nan(log(-1)));
var_dump(is_finite($inf));
var_dump(is_infinite($inf)); echo "<br/>";

$a = (float) 'fsadsa';
$b = (float) 15;
var_dump($a);
var_dump($b);
