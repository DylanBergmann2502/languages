<?php

// Abstract class cannot have instances
abstract class Field implements Renderable {
    public function __construct(protected string $name){}

    // Abstract method cannot have implementation
    // abstract public function render(): string;
}
