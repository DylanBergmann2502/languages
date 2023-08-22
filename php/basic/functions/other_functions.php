<?php

// Variable function
function sum( int|float ...$numbers): int|float {
    return array_sum($numbers);
}

$x = 'sum';

// When PHP see () next to a variable,
// it will look for a function with the same name as the value the variable evaluates to
if (is_callable($x)) {
    echo $x(1, 2 ,3 , 4); echo "<br/>";
} else {
    echo 'Not callable';
}

// Anonymous/Lambda functions
$y = 1;
$z = 2;

// to access global variables for lambda, use "use ()"
$sum = function (int|float ...$numbers) use ($y, &$z): int|float {
    $y = 15;
    $z = 25;

    echo $y; echo "<br/>"; // This is called closure
    echo $z; echo "<br/>";

    return array_sum($numbers);
}; // without ; at the end, it will return an error

echo $sum(1, 2, 3, 4); echo "<br/>";

echo $y; echo "<br/>"; // still 1
echo $z; echo "<br/>"; // changed to 25

////////////////////////////////////////////////////////////////
$array = [1, 2, 3, 4];

// First way
$array2 = array_map(
    function($element) {
        return $element * 2 ;
    }, $array
);

// Second way
$x = function($element) {
    return $element * 2 ;
};

$array2 = array_map($x, $array);

// Third way
function foo ($element) {
    return $element * 2 ;
};

$array2 = array_map('foo', $array);

echo '<pre>';
print_r($array);

print_r($array2);
echo '</pre>';

////////////////////////////////////////////////////////////////
// Callable, Callback
// Closure must be an anonymous function
// While Callable can be both
$sum = function(callable|closure $callback, int|float ...$numbers): int|float {
    return $callback(array_sum($numbers));
};

echo $sum(function($element){
    return $element * 2;
}, 1 ,2 ,3 ,4); echo "<br/>";

////////////////////////////////////////////////////////////////
// Arrow Functions: fn() => []
$array = [1, 2, 3, 4];

$y = 5;

// you can always access global variables with arrow functions
// but you can't modify it outside of the arrow functions
// as of PHP 8, you can only have single line expressions
$array2 = array_map(fn($number) => $number * $number * ++$y, $array);

echo '<pre>';
print_r($array2);
echo '</pre>';

echo $y;
