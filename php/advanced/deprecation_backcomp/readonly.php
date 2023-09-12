<?php

class Address {
    public function __construct(
        // readonly => getter
        // You can only use readonly with type hinted properties
        // Readonly properties cannot have default values
        // unless when you use it with promoted properties
        public readonly string $street,
        public readonly string $city,
        public readonly string $state = "Montana",
    ) {}
}
