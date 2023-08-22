<?php

function prettyPrintArray(array $array) {
    echo '<pre>';
    print_r($array);
    echo '</pre>';
}

// array_chunk(array $array, int $length, bool $preserveKeys = false): array

$items = ['a' => 1, 'b' => 2, 'c' => 3, 'd' => 4];

prettyPrintArray(array_chunk($items, 2)); // if you wanna preserve the key => true for third argument

/////////////////////////////////////////////////////////////////
// array_combine(array $keys, array $values): array
$array1 = ['a', 'b', 'c'];
$array2 = [1, 2, 3];

// if the size of either the key array or the value one does not match
// it will return an error
prettyPrintArray(array_combine($array1, $array2));

////////////////////////////////////////////////////////////////
// array_filter(array $array, callable|null $callback = null, int $mode = 0): array
$array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// array_filter will only filter arrays, not reindex them
$even = array_filter($array, fn($number)=> $number % 2 === 0);

$even = array_values($even); // reindex the array

prettyPrintArray($even);

/////////////////////////////////////////////////////////////////
// array_keys(array $keys, mixed $search_value, bool $strict = false): array
// This is used to get the keys of the array
$array = ['a' => 5, 'b' => 10, 'c' => 15, 'd' => 5, 'e' => 10];

$keys = array_keys($array, '15', true);

prettyPrintArray($keys);

////////////////////////////////////////////////////////////////
// array_map(callable|null $callback, array $array, array ... $arrays): array
// This is used to change the value of an array
$array = [1, 2, 3, 4, 5, 6];
$array1 = ['a' => 1, 'b' => 2, 'c' => 3];
$array2 = ['d' => 4, 'e' => 5, 'f' => 6, 'g' => 7];

// Passing only one array into array_map will preserve the keys
// Passing more than one array will make it reindexed
$oneArray = array_map(fn($number) => $number * 3, $array);
$twoArray = array_map(fn($number1, $number2) => $number1 * $number2, $array1, $array2);

prettyPrintArray($oneArray);
prettyPrintArray($twoArray);

//////////////////////////////////////////////////////////////////
// array_merge(array ...$arrays): array
$array1 = [1, 2, 3];
$array2 = [4, 5, 6];
$array3 = [7, 8, 9];

$merge = array_merge($array1, $array2, $array3);

prettyPrintArray($merge);

//////////////////////////////////////////////////////////////////
// array_reduce(array $array, callable $callback, mixed $initialValue = null): mixed

$invoiceItems  = [
    ['price' => 9.99, 'qty' => 3,'desc' => 'Item 1'],
    ['price' => 29.99, 'qty' => 1,'desc' => 'Item 2'],
    ['price' => 14.99, 'qty' => 1,'desc' => 'Item 3'],
];

$total = array_reduce(
    $invoiceItems,
    fn($sum, $item) => $sum + $item['qty'] * $item['price'],
    500
);

echo $total; echo "<br/>";

////////////////////////////////////////////////////////////////////
// array_search(mixed $needle, array $haystack, bool $strict = false): int|string|false
// return the first matching needle, also, the search is case sensitive
$array = ['a', 'b', 'c', 'D', 'E', 'ab', 'bc', 'cd', 'b', 'd'];

$result = array_search('b', $array);
$result = array_search('d', $array);

var_dump($result); echo "<br/>";

////////////////////////////////////////////////////////////////////
// Sorting arrays
$array = ['d' => 3, 'c' => 1, 'b' => 2, 'a' => 4];

prettyPrintArray($array);

asort($array); // by default, it sorts arrays by value

prettyPrintArray($array);

ksort($array);

prettyPrintArray($array);

////////////////////////////////////////////////////////////////
// Array destructuring
$array = [1, 2, 3, [4, 5]];

[$a, , $c, [$d, $e]] = $array;

echo $a . ', ' . $c . ', ' . $e; echo "<br/>";
