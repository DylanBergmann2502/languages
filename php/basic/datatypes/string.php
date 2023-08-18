<?php

$firstName = 'Will';
$lastName = 'Smith';
$fullName = "$firstName Smith";

echo $fullName; echo "<br/>";

// Indexing a string
$name = $firstName . ' ' . $lastName;

echo $name[1]; echo "<br/>";

// Heredoc treats strings enclosed in ""
$text = <<<TEXT
Line 1 $firstName
Line 2 $lastName
Line 3 ' "
TEXT;

echo $text; echo "<br/>";
echo nl2br($text); echo "<br/>";

// Nowdoc treats strings enclosed in ''
$text = <<<'TEXT'
Line 1 $firstName
Line 2 $lastName
Line 3 ' "
TEXT;

echo nl2br($text);
