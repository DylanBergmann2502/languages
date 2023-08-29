<?php

require_once '../class_and_object/classes/Transaction.php';
use Basic\Transaction;

$transaction = new Transaction(25, 'Transaction 1');

// Using ReflectionProperty to bypass encapsulation
$reflectionProperty = new ReflectionProperty(Transaction::class, 'amount');

$reflectionProperty->setAccessible(true);
$reflectionProperty->setValue($transaction, 125);

var_dump($reflectionProperty->getValue($transaction));

// Footnote: Objects instantiated from the same class can access each other


