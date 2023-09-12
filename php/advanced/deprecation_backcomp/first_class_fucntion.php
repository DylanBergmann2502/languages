<?php

declare(strict_types=1);

function sum(float ...$num): float {
    return array_sum($num);
}

$closure = sum(...);

var_dump($closure);
