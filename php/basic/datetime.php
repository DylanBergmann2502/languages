<?php

// Print out timestamp
$currentTime = time();

echo $currentTime; echo "<br/>";
echo $currentTime + 5 * 24 * 60 * 60; echo "<br/>"; // 5 days later

// Working with datetime
// the first argument is the datetime format
// if the second argument is missing, time() is used

echo date("m/d/Y g:ia"); echo "<br/>";
echo date_default_timezone_get(); echo "<br/>";

date_default_timezone_set('UTC'); // Set it to a different timezone

echo date("m/d/Y g:ia"); echo "<br/>";
echo date_default_timezone_get(); echo "<br/>";

////////////////////////////////////////////////////////////////////////
// Create a datetime object
echo date("m/d/Y g:ia", mktime(0 , 0 , 0 , 4, 10, null)); echo "<br/>";

// Convert string representation of a datetime object into timestamp
echo date("m/d/Y g:ia", strtotime('2023-01-18 08:00:00')); echo "<br/>";

echo date("m/d/Y g:ia", strtotime('last day of february 2025')); echo "<br/>";

// Parsing datetime
$date = date("m/d/Y g:ia", strtotime('second friday of december')); echo "<br/>";



echo '<pre>';
print_r(date_parse($date));
echo '</pre>';
