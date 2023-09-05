<?php

$dateTime1 = new DateTime('5/25/2021 9:15 AM');
$dateTime2 = new DateTime('5/25/2021 9:14 AM');
$dateTime3 = new DateTime('3/15/2021 3:25 AM');

// Comparison
var_dump($dateTime1 < $dateTime2); echo '<br/>';    // false
var_dump($dateTime1 > $dateTime2); echo '<br/>';    // true
var_dump($dateTime1 == $dateTime2); echo '<br/>';   // false
var_dump($dateTime1 <=> $dateTime2); echo '<br/>';  // 1

// Time interval
// return a DateInterval object
$timeInterval = $dateTime1->diff($dateTime3);

var_dump($timeInterval); echo '<br/>';
echo $timeInterval->days; echo '<br/>';
echo $timeInterval->format('%Y years, %m months, %d days'); echo '<br/>';
echo $timeInterval->format('%R%a'); echo '<br/>';

////////////////////////////////////////////////////////////////////////////////
// Creating a new DateInterval must always start with 'P' and then the format
$interval = new DateInterval('P3M2D');

// Be careful when setting the interval flag
$interval->invert = 1;

$dateTime1->add($interval);

echo $dateTime1->format('m/d/Y g:i A'); echo '<br/>';

$dateTime1->sub($interval);

////////////////////////////////////////////////////////////////////////
// From To DateTime
// First way is to use "clone"
$from = new DateTime();
$to = (clone $from)->add(new DateInterval('P1M'));

echo $from->format('m/d/Y') . ' - ' . $to->format('m/d/Y'); echo '<br/>';

// Second way is to use DateTimeImmutable
// Note that to change the datetime of the DateTimeImmutable object
// You must assign it to a variable or it won't be changed
$from = new DateTimeImmutable();
$to = $from->add(new DateInterval('P1M'));

echo $from->format('m/d/Y') . ' - ' . $to->format('m/d/Y'); echo '<br/>';

////////////////////////////////////////////////////////////////
// DateTime period
// By default it will exclude the last day
$period = new DatePeriod(new DateTime('05/01/2021'),
                         new DateInterval('P3D'),
                         (new DateTime('05/31/2021'))->modify('+1 day'));

foreach ($period as $date) {
    echo $date->format('m/d/Y'); echo '<br/>';
}
