<?php

// declare - ticks
// every tick is like an event, but not every statement is tickable
$x = 3;       // each of these is a tick or tickable statement
$y = 5;
$z = $x*$y;

function onTick() {
    echo 'Tick'; echo "<br/>";
}

register_tick_function('onTick');

// The number specifies how many tickable statements should pass before calling onTick()
declare(ticks=3);

$n = 0;
$length = 10;

while ($n < $length) {
    echo $n++; echo "<br/>";
}
