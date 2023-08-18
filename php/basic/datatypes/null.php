<?php
$x = null;

// when print sth out, null is converted into string => ""
echo $x; echo "<br/>";
var_dump($x); echo "<br/>";
var_dump(is_null($x)); echo "<br/>";
var_dump($x === null); echo "<br/>";

// unset a variable
$y = 123;
unset($y);
var_dump($y); echo "<br/>"; // Undefined variable $y
