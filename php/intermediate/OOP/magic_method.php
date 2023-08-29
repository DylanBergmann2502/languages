<?php

require_once './magic_methods/Invoice.php';

$invoice = new Invoice();

// Accessing a non-existing property will fall back to __get and __set
$invoice->amount = 15;
echo $invoice->amount; echo "<br/>";

var_dump(isset($invoice->amount)); echo "<br/>";
unset($invoice->amount);
var_dump(isset($invoice->amount)); echo "<br/>";

// Accessing a non-existing constant/static will result in an error
// Invoice::$amount;

// Calling a non-existing method will fall back to the __call magic method
$invoice->process(1, 2, 3); echo "<br/>";

// Calling a non-existing STATIC method will fall back to the __callStatic magic method
Invoice::process(1, 2, 3); echo "<br/>";

// String Representation
echo $invoice; echo "<br/>";

// Calling an object will execute __invoke
$invoice(); echo "<br/>";

// Var_dumping an object will execute __debugInfo method
var_dump($invoice); echo "<br/>";
