<?php

declare(strict_types=1);

class Transaction2 {
    public ?Customer $customer = null;

    // Shortcut like this is called Property Promotion
    // Private won't allow type hint "callable"
    public function __construct(
        private float $amount,
        private string $description = 'hello'
    ) {
        // Accessing promoted properties
        echo $amount;
        echo $this->amount;
    }
}
