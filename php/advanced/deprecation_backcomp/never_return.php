<?php

declare(strict_types=1);

// After foo() is run, the execution stops
function foo(): never {
    echo 1;
    exit;
}

foo();

echo 'Never reached';
