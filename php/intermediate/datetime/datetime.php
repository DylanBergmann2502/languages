<?php

$dateTime = new \DateTime();
$dateTime = new \DateTime('tomorrow', new DateTimeZone('Europe/Amsterdam'));
$dateTime = new \DateTime('9/1/2023 3:30PM');

var_dump($dateTime); echo '<br/>';

// Get the timezone
echo $dateTime->getTimezone()->getName(); echo '<br/>';

// Set the timezone
$dateTime->setTimezone(new DateTimeZone('Europe/Moscow'));

var_dump($dateTime); echo '<br/>';

// set Date and Time
// Because these methods always return a DateTime object
// you can chain them
$dateTime->setDate(2023, 10, 12)->setTime(2, 15);

// Format the datetime
echo $dateTime->format('m/d/Y g:i A'); echo '<br/>';

////////////////////////////////////////////////////////////////////////////
// Automatic recognition of time format
// m/d/y: US
// d/m/y: EU

// If you date is defined with "/" => PHP will turn it into US format
// If you date is defined with "-" or "." => PHP will turn it into EU format
$date = '15/5/2021 3:30PM';

// Instead of using string replace like this
// You can use createFromFormat
$dateTime = new DateTime(str_replace("/", ".", $date));
// Note that if you are using "new DateTime()" but only set the date without the time
// The time will automatically set to midnight
// But with "createFromFormat()", the time will be set to your local time
// Solution: use "setTime(0, 0)"
$dateTime = DateTime::createFromFormat('d/m/Y g:i A', $date);

var_dump($dateTime);
