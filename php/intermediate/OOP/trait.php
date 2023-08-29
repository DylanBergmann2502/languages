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
