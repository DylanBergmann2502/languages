<?php

use Illuminate\Database\Capsule\Manager as Capsule;

require_once './eloquent/InvoiceStatus.php';
require_once './eloquent/InvoiceItem.php';
require_once './eloquent/Invoice.php';

Capsule::connection()->transaction(function() {
    $invoice = new Invoice();

    $invoice->amount = 45;
    $invoice->invoice_number = '1';
    $invoice->status = InvoiceStatus::Pending;
    $invoice->due_date = (new \Carbon\Carbon())->addDays(10);

    $invoice->save();

    $items = [['Item 1', 1 , 15], ['Item 2', 2 , 7.5], ['Item 3', 4 , 3.75]];

    foreach ($items as [$description, $quantity, $unitPrice]) {
        $item = new InvoiceItem();

        $item->description = $description;
        $item->quantity = $quantity;
        $item->unit_price = $unitPrice;

        $item->invoice()->associate($invoice);

        $item->save();
    }
});

$invoiceId = 29;

Invoice::query()->where('id', $invoiceId)->update(['status' => InvoiceStatus::Paid]);

Invoice::query()->where('status', InvoiceStatus::Paid)->get()->each(function(Invoice $invoice) {
    // without casting beforehand, status is saved in the db as int
    echo $invoice->id . ', ' . $invoice->status->toString() . ', ' . $invoice->created_at->format('m/d/Y');

    $item = $invoice->items->first();

    $item->description = 'Foo bar';

    // using save() will save the current record
    // $item->save();

    $invoice->invoice_number = '3';

    // using push() will save the current record and all of its associated ones
    // in this case, it will save both $invoice and $item
    $invoice->push();

    $item->delete();
});
