<?php

class CappuccinoMaker extends CoffeeMaker {
    use CappuccinoTrait;

    // Method defined in the class will take precedence over the the one from the trait
    public function makeCappuccino()
    {
        echo 'Making Cappuccino (UPDATED)'; echo '<br/>';
    }
}
