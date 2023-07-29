<?php
echo 'Hello World';
print 'Hello World'; // print has value return of 1, mostly, you should use echo
echo print 'Hello World';
echo 'Hello', ' ', 'World';
echo "Joe's Invoice";
echo 'Joe\'s Invoice';

////////////////////////////////////////////////////////////////////////
$name = "Dylan";

echo 'Hello ' . $name;

$x = 1;
$y = $x;
$z = &$x;

$x = 3;
echo $y, $z;

//////////////////////////////////////////////////////////////////////////
//Comments 1
# Comments 2
/*
    Multilines
    Like
    This
*/

////////////////////////////////////////////////////////////////////////

