<?php

require_once './classes/Transaction3.php';
require_once './classes/Status.php';

// Accessing a class constant at the class level
// echo Transaction3::STATUS_PAID; echo "<br/>";

// Accessing a class constant at the object level
$transaction = new Transaction3();

// echo $transaction::STATUS_PENDING; echo "<br/>";

// Class also has a constant "class" to refer to the class name (including namespace)
echo $transaction::class; echo "<br/>";


////////////////////////////////////////////////////////////////////////
$transaction->setStatus(Status::PAID);

var_dump($transaction); echo '<br/>';
