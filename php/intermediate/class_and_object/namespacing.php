<?php

require_once './classes/Transaction.php';
require_once './classes/namespace/Transaction.php';
require_once './classes/namespace/CustomerProfile.php';

// It's recommended to match namespace with the folder structure
var_dump(new Basic\Transaction(100, 'Transaction 1')); echo "<br/>";

////////////////////////////////////////////////////////////////
// Or you can use the "use" keyword to import classes from namespace
use Basic\Transaction as BasicTransaction;

var_dump(new BasicTransaction(100, 'Transaction 1')); echo "<br/>";

////////////////////////////////////////////////////////////////
// Use {} to import different classes from the same namespace
use Inner\{Transaction as InnerTransaction, CustomerProfile};

// Or like this still ok:
// use Inner; => Inner\Transaction

var_dump(new InnerTransaction()); echo "<br/>";

