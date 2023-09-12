<?php

require_once './classes/Invoice.php';

$invoice1 = new Invoice();

$map = new WeakMap();

// WeakMaps must have keys as objects
$map[$invoice1] = ['a' => 1, 'b' => 2];
// $map['hello'] = ['a' => 3, 'b' => 4];

// You cannot append to WeakMap nor access non-existing keys from it
// $map[] = ['a' => 3, 'b' => 4];
// $map[$invoice2] = ['a' => 3, 'b' => 4];

var_dump($map);                 echo '</br>';
var_dump($map[$invoice1]);      echo '</br>';
var_dump(count($map));          echo '</br>';

// Destroy invoice1 won't destroy invoice2
// Bc invoice2 still points to the same object
// $invoice2 = $invoice1;

echo 'Unsetting Invoice 1';     echo '</br>';
var_dump(count($map));          echo '</br>';
// Unsetting an object in the weakmap will make it garbage collected
unset($invoice1);
echo 'Unset Invoice 1';         echo '</br>';
var_dump(count($map));          echo '</br>';

// var_dump($invoice2); echo '</br>';

