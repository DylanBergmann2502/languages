<?php

$paymentStatus = '1';

// Switch statement
switch($paymentStatus){ // switch does loose comparison
    case 1:
        echo 'paid'; echo "<br/>";
        break;

    case 2:
    case 3:
        echo 'Payment Declined'; echo "<br/>";

    case 4:
        echo 'Payment Pending'; echo "<br/>";
        break;

    default:    // default is optional in switch statement
        echo 'Unknown Payment Status'; echo "<br/>";
}

// Match Expression
// match expression can be assigned to a variable
// match expression does not need a break
// match expression is exhaustive => you must specify all possible cases
$paymentStatusDisplay = match($paymentStatus){  // match does strict comparison
    1 => 'paid',
    2, 3 => 'Payment Declined',
    4 => 'Payment Pending',
    default => 'Unknown Payment Status'
};

echo $paymentStatusDisplay; echo "<br/>";

// Difference between if/else and switch
// if/else execute the condition again and again for each condition
// switch only executes it once

function x() {
    sleep(3);

    echo 'Done'; echo "<br/>";

    return 3;
}

$x = x(); // pass the function to a variable will prevent it from being executed multiple times
if ($x == 1) {
    echo 1; echo "<br/>";
} elseif ($x == 2) {
    echo 2; echo "<br/>";
} elseif ($x == 3) {
    echo 3; echo "<br/>";
} else {
    echo 4; echo "<br/>";
}

switch(x()) {
    case 1:
        echo 1; echo "<br/>";
        break;
    case 2:
        echo 2; echo "<br/>";
        break;
    case 3:
        echo 3; echo "<br/>";
        break;
    default:
        echo 4; echo "<br/>";
}


