<?php

class Invoice {
    public string $id;
    public function __construct(public float $amount) {
        $this->id = random_int(10000, 9999999);
    }
}
