<?php

// Arithmetic operators (+ - * / % **)
$x = '10';
$y = 2;
$z = 0;

var_dump($x + $y);
var_dump(+$x);          // putting + or - in front of a string will cast it into a number
// var_dump($x / $z);   // DivisionByZeroError
var_dump(fdiv($x, $z)); // float(INF)

$x = 10.5;
$y = 3;

var_dump($x % $y);      // % cast x and y to int => always return an int
var_dump(fmod($x, $y)); // like % but return a float
echo "<br/>";

////////////////////////////////////////////////////////////////////////
// Assignment operators (= += -= *= /= %= **=)
$x = 5;
$x **= 3;

echo $x; echo "<br/>";

///////////////////////////////////////////////////////////////////////
// String operators (. .=)
$x = "Hello";

$x .= " World";

echo $x; echo "<br/>";

////////////////////////////////////////////////////////////////////////
// Comparison operators ( == === != <> !== < > <= => <=> ?? ?:
$x = 5;
$y = '5';

var_dump($x == $y);     // Loose comparison
var_dump($x === $y);    // Strict comparison

var_dump($x != $y);     // Loose comparison
var_dump($x !== $y);    // Strict comparison

var_dump($x <=> $y);    // -1 if x < y | 0 if x = y | 1 if x > y

// Before php 8, when comparing a string to a number
// The string will be cast into a number
// But after PHP 8, the number will be cast into a string instead LOL :>
var_dump(0 == 'hello');
var_dump(0 == (int) 'hello');       // Pre PHP 8
var_dump((string) 0 == 'hello');    // Post PHP 8

$x = 'Hello World';
$y = strpos($x, 'H');

$rs = $y === false ? 'H Not Found' : 'H Found at index ' . $y;
echo $rs; echo "<br/>";

$x = null;
$y = $x ?? 'Hello';     // ?? = null coalescing operator

echo $y; echo "<br/>";


