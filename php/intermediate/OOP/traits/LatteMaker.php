<?php
class LatteMaker extends CoffeeMaker {

    // Change visibility of a trait method
    use LatteTrait {
        LatteTrait::makeLatte as public;
    }
}
