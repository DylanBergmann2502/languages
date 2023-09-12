<?php

declare(strict_types=1);

$array1 = ['a'=>1, 2 , 3];
$array2 = [4, 5, 6];

// Unpacking array with string keys will resolve in an error pre-PHP 8
$array3 = [...$array1, ...$array2];
