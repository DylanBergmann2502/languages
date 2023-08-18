<?php

$pL = ['PHP', 'Java', 'Python'];

// You can access string using inverted index,
// but you cannot do that with array
echo $pL[0]; echo "<br/>";
echo $pL[-1]; echo "<br/>"; //Undefined array key -1

// Check if an item exists at a specific index
var_dump(isset($pL[3])); echo "<br/>";

// Assignment
$pL[1] = 'C#';

echo '<pre>';
print_r($pL); echo "<br/>";
echo '</pre>';

echo count($pL); echo "<br/>";

// Push a value to an array
$pL[] = 'Ruby';
array_push($pL, 'GO', 'Javascript');

echo '<pre>';
print_r($pL); echo "<br/>";
echo '</pre>';

// Custom indexes/Associative arrays
$pL2 = [
    'PHP' => '8.2',
    'Python' => '3.11',
];

$pL2['Go'] = '1.21';

$node = 'NodeJS';
$pL2[$node] = '20.5';

echo '<pre>';
print_r($pL2); echo "<br/>";
echo '</pre>';

// Multi-dimensional array
$pL3 = [
    'php' => [
        'creator' => 'Rasmus Lerdorf',
        'isOpenSource' => true,
        'versions' => [
            ['version' => 8, 'releaseDate' => 'Nov 26, 2020'],
            ['version' => 7.4, 'releaseDate' => 'Nov 28, 2019'],
        ],
    ]
];

echo '<pre>';
print_r($pL3); echo "<br/>";
echo '</pre>';

echo $pL3['php']['versions'][0]['releaseDate']; echo "<br/>";

// Duplicate index and overwriting
$array = [true => 'a', 1 => 'b', '1' => 'c', 1.8 => 'd', null => 'e'];

print_r($array); echo "<br/>";
echo $array['']; echo "<br/>";
echo $array[null]; echo "<br/>";

$array2 = ['a', 'b', 50 => 'c', 'foo' => 'd',  'e', 'f'];
print_r($array2); echo "<br/>";

echo array_pop($array2); echo "<br/>";
echo array_shift($array2); echo "<br/>"; // remove first element

// removing elements can cause the array to be reindexed, non numeric keys are unaffected
print_r($array2); echo "<br/>";

// removing an element from an array using unset won't cause it to be reindexed
unset($array2[1]);
print_r($array2); echo "<br/>";

// Casting sth into an array will make it the first item in the array
$x = (array) 'a';
$y = (array) null; // return an empty array

print_r($x); echo "<br/>";
print_r($y); echo "<br/>";

// Check for existence of an item

$array3 = ['a' => 1, 'b' => null];

var_dump(array_key_exists('b', $array3)); // check if the key exists or not
var_dump(isset($array3['b']));            // check if the key exists and it's not null
