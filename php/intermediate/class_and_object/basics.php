<?php
declare(strict_types=1);

require_once './classes/Transaction.php';

$transaction = new Basic\Transaction(100, 'Transaction 1');

var_dump($transaction); echo "<br/>";

// Accessing a property
// var_dump($transaction->amount); echo "<br/>";

// $transaction->amount = 16;

// var_dump($transaction->amount); echo "<br/>";

// Call a method
$transaction->addTax(8);
$transaction->applyDiscount(10);

$transaction->addTax(8)->applyDiscount(10);

var_dump($transaction->getAmount()); echo "<br/>"; echo "<br/>";

////////////////////////////////////////////////////////////////
// Creating and chaining and substituting
$class = 'Transaction';

$amount = (new $class(100, 'Transaction 1'))
    -> addTax(8)
    -> applyDiscount(10)
    -> getAmount();

var_dump($amount); echo "<br/>";

////////////////////////////////////////////////////////////////
// Json decoding
$str= '{"a":1,"b":2,"c":3,"d":4}';

$array = json_decode($str, true); // Passing true will turn json into associative array

var_dump($array); echo "<br/>";

$obj = json_decode($str); // Without true, it will return an object with json key becoming the property

var_dump($obj); echo "<br/>"; // stdClass

var_dump($obj->b); echo "<br/>";

////////////////////////////////////////////////////////////////
// Casting into object
$arr = [1,2,3];
$obj = (object) $arr;

var_dump($obj->{0}); echo "<br/>";

var_dump((object) 1); echo "<br/>";     // object(stdClass)#2 (1) { ["scalar"]=> int(1) }

var_dump((object) null); echo "<br/>";  //object(stdClass)#2 (0) { }
