<?php

require_once './object_cloning/Invoice.php';
require_once './serialization/Invoice2.php';

// serialization: converting a value into a string
// deserialization: converting a string to its php form

echo serialize(true);                   echo '<br/>';
echo serialize(1);                      echo '<br/>';
echo serialize(2.5);                    echo '<br/>';
echo serialize('hello world');          echo '<br/>';
echo serialize([1,2,3]);                echo '<br/>';
echo serialize(['a' => 1, 'b' => 2]);   echo '<br/>';

print_r(unserialize(serialize(['a' => 1, 'b' => 2])));   echo '<br/>';

// When serializing an object, the class name and its properties will be serialized,
// class methods; however, won't be serialized

$invoice = new Invoice();
echo serialize($invoice); echo '<br/>';

// Deserializing an object will return a new one
// Cloning is called shallow cloning
// Serializing and deserializing is called deep cloning
$invoice2 = unserialize(serialize($invoice));

var_dump($invoice, $invoice2, $invoice === $invoice2); echo '<br/>';

//////////////////////////////////////////////////////////////////////////////////////////
// Overriding the serialization and deserialization of a class
$invoice = new Invoice2(25, '2532412321');

$invoice2 = unserialize(serialize($invoice));

var_dump($invoice2); echo '<br/>';
