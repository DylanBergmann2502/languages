<?php

$x = 5;

function foo() {
    global $x; echo "<br/>"; // 2. Use global keyword to access global variables

    $x = 10;

    echo $x; echo "<br/>";   // 1. Every variable inside a function has a local scope
}

foo();

echo $x; echo "<br/>";

////////////////////////////////////////////////////////////////
// super-global variables
// should be avoided
$y = 6;
function bar() {
    $GLOBALS['y'] = 8;

    echo $GLOBALS['y']; echo "<br/>";
}

bar();

////////////////////////////////////////////////////////////////
// Static variables
function getValue() {
    static $value = null; // using the static keyword to capture the return value from a function

    if ($value === null) {
        $value = someExpensiveFunction();
    }

    return $value;
}

function someExpensiveFunction() {
    sleep(2);

    echo "Processing"; echo "<br/>";

    return 10;
}

echo getValue(); echo "<br/>";
echo getValue(); echo "<br/>";
echo getValue(); echo "<br/>";
