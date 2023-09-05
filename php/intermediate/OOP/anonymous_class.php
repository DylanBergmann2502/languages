<?php

require_once '../anonymous_class/ClassA.php';

// Anonymous class can extend from a class, implement interfaces, and use traits
// since anonymous classes have no name, you cannot type hint them directly
$obj = new class(1, 2, 3) {
    public function __construct(public int $x, public int $y, public int $z){}
};

var_dump($obj); echo '<br/>';

$obj = new ClassA(1, 2);


