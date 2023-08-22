<?php

$dir = scandir(__DIR__);

var_dump($dir); echo "<br/>";

mkdir("foo");
rmdir("foo");

if (file_exists('foo.txt')) {
    echo filesize("foo.txt"); echo "<br/>";

    // in PHP, files are cached for better performance
    file_put_contents('foo.txt', "hello world");

    clearstatcache();
    echo filesize("foo.txt"); echo "<br/>";
}

////////////////////////////////////////////////////////////////
// Reading/Writing a file
$file = fopen('foo.txt', 'r');

var_dump($file); echo "<br/>";

while (($line = fgets($file)) !== false) {
    echo $line . '<br/>';
}

fclose($file);

////////////////////////////////////////////////////////////////
// Get the content of a file
$content = file_get_contents('foo.txt', offset: 3, length: 2);

echo $content; echo '<br/>';

////////////////////////////////////////////////////////////////
// Copy and delete a file
// If the file already exists, it will overwrite it
copy('foo.txt', 'bar.txt');

rename('bar.txt', 'foobar.txt');

unlink('foobar.txt');
