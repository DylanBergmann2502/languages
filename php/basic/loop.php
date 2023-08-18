<?php

// while
$n = 0;

while($n < 15) {
    echo $n++;
}
echo "<br/>";

while(true) {
    if ($n < 15) {
        break;
    }
    echo $n++;
}
echo "<br/>";

while(true) {
    while($n > 10) {
        break 2;
    }
    echo $n++;
}; echo "<br/>";

// do-while
$n = 25;

do {        // guarantee to execute do block at least once
    echo $n++;
} while ($n < 15); echo "<br/>";

////////////////////////////////////////////////////////////////
// for
for ($n = 0; $n < 15; $n++) {
    echo $n;
}; echo "<br/>";

for ($n = 0; $n < 15; $n++):  // alternative syntax
    echo $n;
endfor ; echo "<br/>";

for ($n = 0; $n < 15; print $n, $n++) {}; echo "<br/>";
for ($n = 0; print $n, $n < 15; $n++) {}; echo "<br/>";

$text = 'Hello World';
// calling strlen() multiple times can cause performance issues
for ($n = 0, $length = strlen($text) ; $n < $length; $n++) {
    echo $text[$n]; echo "<br/>";
}

$array = ['a', 'b', 'c', 'd', 'e'];
for ($n = 0, $length = count($array); $n < $length; $n++) { // Same here
    echo $array[$n]; echo "<br/>";
}

////////////////////////////////////////////////////////////////////////
// foreach
$pL = ['php', 'java', 'python'];

foreach($pL as $key => $lang) { // $key => is optional if you ever need it
    echo $key . ': ' . $lang; echo "<br/>";
}

foreach($pL as $key => $lang): // alternative syntax
    echo $key . ': ' . $lang; echo "<br/>";
endforeach;

echo $lang; echo "<br/>"; // variables don't get destroyed after a foreach loop
unset($lang);             // recommended action after foreach loops

foreach($pL as &$lang) { // using & => change the original array
    $lang = 'php';
}

print_r($pL);
