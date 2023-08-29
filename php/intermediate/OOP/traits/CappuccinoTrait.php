<?php

trait CappuccinoTrait {
    use LatteTrait;

    public function makeCappuccino() {
        echo static::class . ' is making cappuccino'; echo '<br/>';
    }

    // Overriding a method on the base class with trait
    // will result in the overridden version from the trait being called
    public function makeCoffee() {
        echo 'Making Coffee (UPDATED)'; echo '<br/>';
    }

    // Creating a conflict on AllInOneCoffeeMaker
    public function makeLatte() {
        echo static::class . ' is making latte (from the CappuccinoTrait)'; echo '<br/>';
    }
}
