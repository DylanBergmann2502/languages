<?php

// You cannot instantiate objects from traits
// You cannot use traits in other traits or classes
trait LatteTrait {
    // You can define properties on traits
    // If you wanna override a trait property, it has to be compatible
    // Meaning: the visibility + type + default value have to match
    protected string $milkType = 'whole-milk';

    // You can make trait method private
    private function makeLatte() {
        echo static::class . ' is making latte with ' . $this->milkType; echo '<br/>';
    }
}
