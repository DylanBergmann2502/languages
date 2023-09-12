<?php

class A {
    public static function counter() {
        static $counter = 0;
        $counter++;
        return $counter;
    }
}

class B extends A {}
                            // Pre PHP 8.1   |  Post PHP 8.1
var_dump(A::counter());     //      1        |       1
var_dump(A::counter());     //      2        |       2
var_dump(B::counter());     //      1        |       3
var_dump(B::counter());     //      2        |       4
