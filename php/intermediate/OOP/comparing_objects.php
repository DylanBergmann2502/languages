<?php

require_once './comparison/Invoice.php';
require_once './comparison/CustomInvoice.php';

$invoice1 = new Invoice(1, 'Invoice');
$invoice2 = new Invoice(true, 'Invoice');
$invoice3 = $invoice1;
$invoice4 = new CustomInvoice(1, 'Invoice');

// return true if 2 instances are of the same class and
// have the same properties and values
var_dump($invoice1 == $invoice2); echo "<br/>";     // True
var_dump($invoice1 == $invoice4); echo "<br/>";     // False

// return true if 2 objects refer to the same instance of the same class
var_dump($invoice1 === $invoice2); echo "<br/>";    // False
var_dump($invoice1 === $invoice3); echo "<br/>";    // True
var_dump($invoice1 === $invoice4); echo "<br/>";    // False

// Since invoice1 and invoice3 are pointing to the same object in the memory
// Changes in one will after the other
$invoice3->amount = 250;

var_dump($invoice1); echo "<br/>";
var_dump($invoice3); echo "<br/>";
