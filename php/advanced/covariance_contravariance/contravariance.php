<?php

require_once './contravariance/Food.php';
require_once './contravariance/AnimalFood.php';
require_once './contravariance/Animal.php';
require_once './contravariance/Dog.php';
require_once './contravariance/Cat.php';

// Contravariance allows a parameter type to be
// less specific in the child method,
// than that of its parent

// Contravariance = More Specific >> Less Specific
// This feature is supported from PHP 7.4 onwards

// Let's say eat() on Animal takes Food type
// eat() on Dog take AnimalFood type
// => covariant parameter is not supported

// This rule does not apply to __constructor

$catFood = new AnimalFood();
$kitty = new Cat("Ricky");

$kitty->eat($catFood);

$banana = new Food();
$puppy = new Dog("Marvick");

$puppy->eat($banana);
$puppy->eat($catFood); // This works means that it follows the Liskov Substitution Principle
