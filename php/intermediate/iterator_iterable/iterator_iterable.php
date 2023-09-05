<?php

require_once './classes/Collection.php';
require_once './classes/Invoice.php';
require_once './classes/InvoiceCollection.php';
require_once './classes/InvoiceCollection2.php';

foreach (new Invoice(25) as $key => $value) {
    echo $key . ' = ' . $value; echo '<br/>';
}

$invoiceCollection = new InvoiceCollection([new Invoice(15), new Invoice(25), new Invoice(50)]);
foreach ($invoiceCollection as $invoice) {
    var_dump($invoice);
    echo $invoice->id . ' - ' . $invoice->amount; echo '<br/>';
}

$invoiceCollection2 = new InvoiceCollection2([new Invoice(15), new Invoice(25), new Invoice(50)]);
foreach ($invoiceCollection2 as $invoice) {
    echo $invoice->id . ' - ' . $invoice->amount; echo '<br/>';
}

////////////////////////////////////////////////////////////////
// Type hinting for iterable
// iterable type is only available in PHP 8
// before that, we have to use union type like Collection|array|...
function foo (iterable $iterable) {
    foreach ($iterable as $i => $item) {
        echo $i; echo '<br/>';
    }
}
