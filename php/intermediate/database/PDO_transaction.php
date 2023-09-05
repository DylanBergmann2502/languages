<?php

declare(strict_types=1);

try {
    $db = new PDO(
        'mysql:host=' . $_ENV['DB_HOST'] . ';dbname=' . $_ENV['DB_DATABASE'],
        $_ENV['DB_USER'],
        $_ENV['DB_PASS'],
    );
} catch (PDOException $e) {
    throw new PDOException($e->getMessage(), (int) $e->getCode());
}

$email = 'johndoe@gmail.com';
$name = 'John Doe';
$amount = 25;


// SQL operation
try {
    $db->beginTransaction();

    $newUserStmt = $db->prepare(
        'INSERT INTO users (email, full_name, is_active, created_at)
        VALUES (?, ?, ?, NOW())'
    );
    $newInvoiceStmt = $db->prepare(
        'INSERT INTO invoices (amount, user_id)
        VALUES (?, ?)'
    );

    $newUserStmt->execute([$email, $name]);
    $userId = (int) $db->lastInsertId();
    $newInvoiceStmt->execute([$amount, $userId]);

    $db->commit();
} catch (\Throwable $e) {
    if ($db->inTransaction()) {
        $db->rollback();
    }
}


// Displaying invoice table
$fetchStmt = $db->prepare(
    'SELECT invoices.id as invoice_id, amount, user_id, full_name
    FROM invoices
    INNER JOIN users ON user_id = users.id
    WHERE email = ?'
);
$fetchStmt->execute([$email]);

echo '<pre>';
var_dump($fetchStmt->fetch(PDO::FETCH_ASSOC));
echo '</pre>';
