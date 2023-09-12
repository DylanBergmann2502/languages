<?php

class SalesTaxService {
    public function calculate(float $amount, array $customer): float {
        return $amount*6.5/100;
    }
}
