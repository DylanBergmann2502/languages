<?php

$y = 0;

// require / include
include '.\file.php';   // "include" will only give a warning if file is not found

echo 'Hello World'; echo "<br/>";

require '.\file.php';   // "require" will stop the execution altogether if file is not found
echo "<br/>"; echo "<br/>";

////////////////////////////////////////////////////////////////
// require_once / include_once
// these 2 will only include the file once if it is not included already
require '.\file.php';
$x++;
echo $x; echo "<br/>";

require '.\file.php';
echo $x; echo "<br/>";
echo $y; echo "<br/>";

require_once '.\file.php';
require_once '.\file.php';

////////////////////////////////////////////////////////////////
// By default it will return 1 if the file exists or 0 if it doesn't
$z = include '.\file.php';

var_dump($z);
