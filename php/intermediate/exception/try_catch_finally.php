<?php

require_once './classes/Customer.php';
require_once './classes/MissingBillingInfoException.php';
require_once './classes/InvoiceException.php';
require_once './classes/Invoice.php';

$invoice = new Invoice(new Customer());

try {
    $invoice->process(25);
}
// In PHP 8, if you don't interact with the error object $e, you can just omit it
catch (MissingBillingInfoException|\InvalidArgumentException $e) {
    echo $e->getMessage(); echo '<br/>';
} finally {
    echo 'Finally block'; echo '<br/>';
}

////////////////////////////////////////////////////////////////////////
// try catch finally and the return statement
function process() {
    $invoice = new Invoice(new Customer(['foo' => 'bar']));

    // The return statement of try/catch will be executed
    // after the finally block has been executed
    // If the finally block has a return statement of its own,
    // then the return statement from try/catch will be executed
    // but the return value will still be of the finally's
    try {
        $invoice->process(25);
        return true;
    } catch (\Exception $e) {
        echo $e->getMessage(); echo '<br/>';
        return false;
    } finally {
        echo "finally block"; echo '<br/>';
        return -1;
    }
}

