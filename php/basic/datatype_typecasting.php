<?php
# 4 Scalar Types
    # bool
    $completed = true;
    # int
    $score = 75;
    # float
    $price = 0.99;
    # string
    $greeting = "Hello, Gio";

    echo $completed . '<br/>';
    echo gettype($price) . '<br/>'; // double = float

    var_dump($completed) . '<br/>';
    var_dump($score) . '<br/>';
    var_dump($price) . '<br/>';
    var_dump($greeting) . '<br/>'; echo "<br/>";

# 4 Compound Types
    # array
    $companies = [1, 2, 3, 0.5, 'Abc', true];
    print_r($companies); echo "<br/>";
    # object
    # callable
    # iterable

# 2 Special Types
    # resource
    # null

// declare(strict_types=1);
function sum(int $x, int $y) {
    return $x + $y;
}

echo sum(2, 3); echo "<br/>";
echo sum(2, '3'); echo "<br/>";
echo sum(2.5, '3'); echo "<br/>";

// Typecasting
$x = (int) '5';
$y = (string) 5;

echo var_dump($x); echo "<br/>";
echo var_dump($y); echo "<br/>";
