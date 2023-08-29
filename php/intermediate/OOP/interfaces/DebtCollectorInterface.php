<?php

// An interface can extend from multiple interfaces
interface DebtCollectorInterface extends AnotherInterface {
    // You cannot have properties in an interface
    // But you can have constants, and these interface constants cannot be overridden
    public const MY_CONST = 1;

    // All methods declared in the interface must be public
    public function collect(float $owedAmount): float;
}
