<?php

require_once './traits/CoffeeMaker.php';
require_once './traits/LatteTrait.php';
require_once './traits/LatteMaker.php';
require_once './traits/CappuccinoTrait.php';
require_once './traits/CappuccinoMaker.php';
require_once './traits/AllInOneCoffeeMaker.php';

$coffeeMaker = new CoffeeMaker();
$coffeeMaker->makeCoffee();

$latteMaker = new LatteMaker();
$latteMaker->makeCoffee();
$latteMaker->makeLatte();

$cappuccinoMaker = new CappuccinoMaker();
$cappuccinoMaker->makeCoffee();
$cappuccinoMaker->makeCappuccino();

$allInOneCoffeeMaker = new AllInOneCoffeeMaker();
$allInOneCoffeeMaker->makeCoffee();
$allInOneCoffeeMaker->makeLatte();
$allInOneCoffeeMaker->makeOriginalLatte();
$allInOneCoffeeMaker->makeCappuccino();

echo LatteMaker::$x; echo '<br/>';
LatteMaker::foo();

// Unlike inheritance, where classes share properties,
// using traits will allow each class its own version of the properties
LatteMaker::$x = 2;
AllInOneCoffeeMaker::$x = 3;
echo LatteMaker::$x; echo '<br/>';
echo AllInOneCoffeeMaker::$x; echo '<br/>';
