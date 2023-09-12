<?php

$numbers = lazyRange(1, 300000);

echo $numbers->current();
$numbers->next();
echo $numbers->current();

// return an error, bc the execution hasn't reached the return statement yet
// echo $numbers->getReturn();

$numbers->next();
echo $numbers->getReturn();

// Downside of a generator is that you can only loop through it once and you cannot rewind it
function lazyRange(int $start, int $end): Generator {
    // These operations don't get executed
    // even when we call the function lazyRange()
    // They will only be executed once the iterator methods are called
    // or when we loop over it
    // "yield" statement pauses the execution
    echo 'Hello';

    yield $start;

    echo 'World';

    yield $end;

    return '!';

    // for ($i = $start; $i <= $end; $i++) {
    //     yield $i;
    // }
}
