<?php

// you can put function everywhere in the global scope and it'll still be loaded first
var_dump(foo()); echo "<br/>"; // NULL if there's no return statement

function foo() {
}

// Nested functions
function a() {
    echo 'a'; echo "<br/>";
    function b() {
        echo 'b'; echo "<br/>";
    }
}

a(); // a() has to be called first
b(); // before calling b(); otherwise, there'll be an error bc b() is not previously defined

// Type hints
function c(): string {
    return 1;
}

function d(): void {
}

function e(): ?int { // ?int = int|null
    return null;
}

function f() : int|float|array {
    return 2;
}

// "mixed" => if you expect sth that can be of any type or cannot be type hinted
function g() : mixed {
    return 2;
}

var_dump(c()); echo "<br/>";
var_dump(d()); echo "<br/>";
var_dump(e()); echo "<br/>";
var_dump(f()); echo "<br/>";
var_dump(g()); echo "<br/>";
