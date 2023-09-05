<?php

require_once './object_cloning/Invoice.php';

$invoice = new Invoice();

// "clone" copies the properties of the original object
// but the new one points to a new object in the memory
$invoice2 = clone $invoice;

var_dump($invoice, $invoice2); echo '<br/>';
