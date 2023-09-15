<?php

declare(strict_types=1);

class Invoice {
    public function __construct(
        protected SalesTaxCalculator $salesTaxCalculator
    ){}

    public function create(array $lineItems) {
        // calculate sub total
        $lineItemsTotal = $this->calculateLineItemsTotal($lineItems);

        // calculate sales tax
        $salesTax = $this->salesTaxCalculator->calculate($lineItemsTotal);

        $total = $lineItemsTotal + $salesTax;

        echo 'Sub Total: $' . $lineItemsTotal . PHP_EOL .
             'Sales Tax: $' . $salesTax . PHP_EOL .
             'Total: $' . $total . PHP_EOL;

        // Other stuff
    }

    public function calculateLineItemsTotal(array $items): float|int {
        return array_sum(
            array_map(
                fn($item) => $item['unitPrice']*$item['quantity'],
                $items
            )
        );
    }
}
