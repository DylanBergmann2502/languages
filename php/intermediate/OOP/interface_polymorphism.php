<?php

require_once './interfaces/AnotherInterface.php';
require_once './interfaces/DebtCollectorInterface.php';
require_once './interfaces/CollectionAgency.php';
require_once './interfaces/Rocky.php';
require_once './interfaces/DebtCollectionService.php';

$collector = new CollectionAgency();

echo $collector->collect(100); echo "<br/>";

$service = new DebtCollectionService();

// This is called polymorphism
echo $service->collectDebt(new CollectionAgency()) . PHP_EOL;  echo "<br/>";
echo $service->collectDebt(new Rocky()) . PHP_EOL;  echo "<br/>";
