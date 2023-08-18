<?php
////////////////////////////////////////////////////////////////
// declare - encoding
// Never mind

// declare - strict_types
// this will apply to everything below it
// If you import sth under strict_types from one script to another
// you must specify strict_types in both scripts;
// otherwise, it won't work
declare(strict_types=1);

function sum(int $x, int $y) {
    $z = $x + $y;
    return $z;
}

echo sum(5, 10);
