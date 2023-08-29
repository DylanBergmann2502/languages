<?php

// The final keyword makes it that the class can no longer be inherited from/method overridden
final class ToasterPro extends Toaster{
    // If a property is set to public on the parent class
    // You cannot decrease its visibility on the child class
    // Instead you can enhance it (protected to public)
    // Public > Protected > Private
    // public int $size = 4;

    // By default, if you override a method, it won't call its parent
    public function __construct() {
        // If you wanna call the parent method, use "parent::method"
        // If the method on the parent class doesn't exist, it will return an error
        parent::__construct();
        $this->size = 4;
    }

    final public function toastBagel() {
        foreach ($this->slices as $i => $slice) {
            echo ($i + 1) . ": Toasting " . $slice . " with bagels option " . PHP_EOL;
        }
    }
}
