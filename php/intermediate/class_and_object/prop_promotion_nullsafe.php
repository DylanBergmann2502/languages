<?php
declare(strict_types=1);

require_once './classes/PaymentProfile.php';
require_once './classes/Customer.php';
require_once './classes/Transaction2.php';

$transaction = new Transaction2(100, 'Transaction 1'); echo "<br/>";

// Null-safe operator (?)
// If the operation reaches null at the null-safe operator,
// it will return immediately without finishing the rest of the operation
echo $transaction->customer?->paymentProfile->id; echo "<br/>";


