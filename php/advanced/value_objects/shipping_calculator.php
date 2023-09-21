<?php

require_once './classes/PackageDimension.php';
require_once './classes/Weight.php';
require_once './classes/DimDivisor.php';
require_once './classes/BillableWeightCalculatorService.php';

$package = [
    'weight' => 6,
    'dimensions' => [
        'width' => 9,
        'length' => 15,
        'height' => 7
    ]
];

$packageDimensions = new PackageDimension(
    $package['dimensions']['width'],
    $package['dimensions']['height'],
    $package['dimensions']['length'],
);

$weight = new Weight($package['weight']);

$billableWeight = (new BillableWeightCalculatorService())->calculate(
    $packageDimensions,
    $weight,
    DimDivisor::FEDEX
);

echo $billableWeight . ' lb'; echo '<br/>';
