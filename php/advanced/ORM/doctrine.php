<?php

require_once './doctrine/InvoiceStatus.php';
require_once './doctrine/Invoice.php';
require_once './doctrine/InvoiceItem.php';

$items = [['Item 1', 1 , 15], ['Item 2', 2 , 7.5], ['Item 3', 4 , 3.75]];

$invoice = (new Invoice())
    ->setAmount(45)
    ->setInvoiceNumber('1')
    ->setStatus(InvoiceStatus::Pending)
    ->setCreatedAt(new \DateTime());

foreach ($items as [$description, $quantity, $unitPrice]) {
    $item = (new InvoiceItem())
        ->setDescription($description)
        ->setQuantity($quantity)
        ->setUnitPrice($unitPrice);

    $invoice->addItem($item);
}

