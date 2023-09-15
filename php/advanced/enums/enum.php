<?php

require_once './classes/InvoiceStatusTrait.php';
require_once './classes/InvoiceStatusInterface.php';
require_once './classes/Color.php';
require_once './classes/InvoiceStatusEnum.php';

var_dump(InvoiceStatusEnum::Paid, gettype(InvoiceStatusEnum::Paid));        echo '</br>';

// In this way, you access the enum -> access the case -> name/value
var_dump(InvoiceStatusEnum::Paid->name, InvoiceStatusEnum::Paid->value);    echo '</br>';

// In this way, you have a value -> access the enum case
echo InvoiceStatusEnum::tryFrom(1)->toString();                             echo '</br>';

// Enum has a built-in cases() method to get access to all the enum cases
var_dump(InvoiceStatusEnum::cases());                                       echo '</br>';

// Check if the enum exists
var_dump(enum_exists(InvoiceStatusEnum::class));                            echo '</br>';
