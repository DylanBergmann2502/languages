<?php

require_once './classes/Transaction4.php';
require_once './classes/DB.php';

$transaction = new Transaction4(25, 'Transaction 1');

// Accessing public static properties
// var_dump(Transaction4::$count);
// var_dump($transaction::$count);

// Accessing private static properties
var_dump(Transaction4::getCount());
var_dump($transaction::getCount());

// Static helps with implementing singleton (in a wrong way :) )
// Or helps creating a class that does not need an object to work with
$db = DB::getInstance([]);
$db = DB::getInstance([]);
$db = DB::getInstance([]);

