<?php

declare(strict_types=1);

try {
    $db = new PDO('mysql:host=localhost;dbname=testdb', 'root', 'dylan', [
        // By default, it will fetch as array
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ
    ]);
} catch (PDOException $e) {
    throw new PDOException($e->getMessage(), (int) $e->getCode());
}

// http://localhost/intermediate/database/PDO_prepare_stmt.php?first_name=David%22+OR+1=1--+
$first_name = $_GET['first_name'];

$query = 'SELECT * FROM employee WHERE first_name = "' . $first_name .'"';

echo $query; echo "<br/>";

$stmt = $db->prepare($query);

$stmt->execute();

// var_dump($stmt->fetchAll());

foreach($db->query($query) as $emp) {
    echo '<pre>';
    var_dump($emp);
    echo '</pre>';
}






