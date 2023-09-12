<?php

declare(strict_types=1);

abstract class Animal {

    public function __construct(
        protected string $name
    ) {}

    abstract public function speak();

    public function eat(Food $food){
        echo $this->name . " eats " . get_class($food);
    }
}
