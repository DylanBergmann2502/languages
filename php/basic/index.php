<?php
echo 'Hello World'; echo "<br>";
// print has value return of 1, mostly, you should use echo
print 'Hello World'; echo "<br>";
echo print 'Hello World'; echo "<br>";
echo 'Hello', ' ', 'World'; echo "<br>";
echo "Joe's Invoice"; echo "<br>";
echo 'Joe\'s Invoice'; echo "<br>";

////////////////////////////////////////////////////////////////////////
// variable must start with letter or underscore, starting with number will return errors
// variable cannot have special characters and cannot be "$this"
$name = "Dylan";

echo 'Hello ' . $name; echo "<br>";
echo "Hello $name"; echo "<br>"; // must use "", '' will return an error
echo "Hello {$name}"; echo "<br>";

$x = 1;
$y = $x; // variables are assigned by value
$z = &$x; // use ampersand "&" => assign variable by reference

$x = 3;
echo $y, $z; echo "<br>";

//////////////////////////////////////////////////////////////////////////
//Comments 1
# Comments 2
/*
    Multi-lines
    Like
    This
*/

////////////////////////////////////////////////////////////////////////
// Constants
define('STATUS_PAID', 'paid'); // defined at runtime
const STATUS_UNPAID = 'unpaid'; // defined at compile time

echo STATUS_PAID;
echo defined('STATUS_PAID'); echo "<br>";// return bool if a constant has been defined
echo defined('STATUS_VOID'); echo "<br>";

// Dynamic constants
// define('TIME_' . $process, 4);

// echo TIME_PROCESS;

// Built-in constants
echo PHP_VERSION; echo "<br>";

// Magic constants
// These constants change based on where they are used
echo __LINE__; echo "<br>";
echo __FILE__; echo "<br>";

////////////////////////////////////////////////////////////////
// Variable variables
$foo = 'bar';

$$foo = 'fuck'; //$foo = 'bar' => $$foo = $bar = 'fuck';

echo "$foo, $bar, {$$foo}"; echo "<br>"; // without {}, it wont work
