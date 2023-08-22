<?php

declare(strict_types=1);

// all required arguments must precede optional arguments
function sum(int|float $x, int|float $y = 10): int|float {
    return $x + $y;
}

echo sum(5.0, 10); echo "<br/>";

// Splat Operator (...)
// "..." capture all arguments into an array, what comes before it won't be taken into account
function total(int|float $x, int|float $y, int|float ...$numbers): int|float {
    return array_sum($numbers);
}

$x = 5; $y = 12;
$numbers = [4, 7];

echo total($x, $y, 4, 7); echo "<br/>";
echo total($x, $y, ...$numbers); echo "<br/>"; // ... is now unpack operator

////////////////////////////////////////////////////////////////////////
// Named arguments
echo sum(y: 3, x: 9); echo "<br/>";

// If you wanna you positional arguments + named arguments
// All positional arguments must precede named arguments
echo sum(9, y:3); echo "<br/>";

// Passing in an unpacked array as arguments
$arr = [ 3, 'y' => 9];

echo sum(...$arr); echo "<br/>";
