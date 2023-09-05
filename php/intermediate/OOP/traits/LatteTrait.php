<?php

// You cannot instantiate objects from traits
// You cannot use traits in other traits or classes
trait LatteTrait {
    // You can define properties on traits
    // If you wanna override a trait property, it has to be compatible
    // Meaning: the visibility + type + default value have to match
    protected string $milkType = 'whole-milk';

    public static int $x = 1;

    // You can make trait method private
    private function makeLatte() {
        echo static::class . ' is making latte with ' . $this->milkType; echo '<br/>';
    }

    // Trait allows the existence of abstract methods
    // But not recommended to use
    // abstract public function getMilkType();

    // Traits can have static properties and methods
    public static function foo(){
        echo "bar"; echo '<br/>';
    }
}
