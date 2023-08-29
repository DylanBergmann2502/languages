<?php

class AllInOneCoffeeMaker extends CoffeeMaker {

    // To result trait conflicts, use "insteadof" operator
    use LatteTrait {
        LatteTrait::makeLatte insteadof CappuccinoTrait;
        LatteTrait::makeLatte as public;
    }
    // Or to alias it
    use CappuccinoTrait {
        CappuccinoTrait::makeLatte as makeOriginalLatte;
    }
}
