<?php

class ClassA {
    public function __construct(public int $x, public int $y){}

    public function foo(): object {
        return new class($this->x, $this->y) {
            public function __construct(public int $x, public int $y){
                var_dump($x, $y);
            }
        };
    }
}
