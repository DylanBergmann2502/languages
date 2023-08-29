<?php

class ClassA {
    protected static string $name = 'A';

    // Factory pattern
    // Point to classA
    public static function make1() {
        return new ClassA();
    }
    // Point to classA
    public static function make2() {
        return new self();
    }
    // Point to the current class
    public static function make3(): static {
        return new static();
    }
}
