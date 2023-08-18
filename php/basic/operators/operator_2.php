<?php

// Error Control Operators(@)
// Adding @ will suppress the error
$x = @file('foo.txt');      // recommending using this operator

// Increment/Decrement Operators (++ --)
// These operators only affect numbers and strings
$x = 5;

$x++;   // 5
$x--;   // 5
++$x;   // 6
--$x;   // 4

$y = null;

echo --$y; echo "<br/>"; // No effect
echo ++$y; echo "<br/>"; // 1

$z = 'abc';

echo --$z; echo "<br/>"; // No effect, still 'abc'
echo ++$z; echo "<br/>"; // abd

////////////////////////////////////////////////////////////////
// Logical Operators (&& || ! and or xor)
$x = true;
$y = false;

// '||' is short-circuited => if any of the previous values are true
// the rest won't be evaluated
var_dump($x || $y);

// '&&' has higher precedence over '||'
var_dump($x && $y || $y);
var_dump(!$x);

$z = $x and $y; // '=' has higher precedence over 'and' => $z = $x = true

echo $z; echo "<br/>";

// Bitwise operators (& | ^ ~ << >>)
// Never mind :>

////////////////////////////////////////////////////////////////
// Array operators (+ == === != <> !==)
$x = ['a', 'b', 'c', ];
$y = ['d', 'e', 'f'];

// + => union => append y to x if the item is at different index, if it's the same index, ignore
$z = $x + $y;
print_r($z); echo "<br/>"; // Array ( [0] => a [1] => b [2] => c )

$x = ['a' => 1, 'b' => 2, 'c' => 3];
$y = ['a' => 4, 'e' => 5, 'f' => 6];

$z = $x + $y;
print_r($z); echo "<br/>"; // Array ( [a] => 1 [b] => 2 [c] => 3 [e] => 5 [f] => 6 )

$x = ['a' => 1, 'b' => 2, 'c' => 3];
$y = ['a' => 1, 'c' => 3, 'b' => '2',];

var_dump($x == $y);     // Only true if both key and value match
var_dump($x === $y);    // Only true if both key and value match both in value and datatype and order must be the same

////////////////////////////////////////////////////////////////
// Execution Operators (``)

// Type Operators (instanceof)

// Null-safe Operator - PHP8 (?)
