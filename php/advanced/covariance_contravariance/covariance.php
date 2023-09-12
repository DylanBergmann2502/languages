<?php

require_once './covariance/Animal.php';
require_once './covariance/Cat.php';
require_once './covariance/Dog.php';
require_once './covariance/AnimalShelter.php';
require_once './covariance/CatShelter.php';
require_once './covariance/DogShelter.php';

// Covariance allows the child's method to return
// a more specific type than that of the parent's

// Covariance = Less Specific Type >> More Specific Type
// This feature is supported from PHP 7.4 onwards

// Let's say adopt() on AnimalShelter takes Cat type
// adopt() on CatShelter take Animal type
// => contravariant return type is not supported


$kitty = (new CatShelter())->adopt("Ricky");
$kitty->speak();

$puppy = (new DogShelter())->adopt("Marvick");
$puppy->speak();
