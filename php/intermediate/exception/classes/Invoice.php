<?php

class Invoice {
    public function __construct( public Customer $customer) {}

    public function process(float $amount): void {
        if ($amount <= 0) {
            // The method clone on the Exception object is final => cannot clone it :>
            throw new \InvalidArgumentException('Invalid invoice amount');
            // throw InvoiceException::invalidAmount();
        }

        if (empty($this->customer->getBillingInfo())) {
            throw new MissingBillingInfoException();
            // In some code, people would prefer to throw an exception
            // by calling static methods
            // throw InvoiceException::missingBillingInfo();
        }

        echo 'Processing $' . $amount . ' invoice - ';

        sleep(1);

        echo 'OK'; echo '<br/>';
    }
}
