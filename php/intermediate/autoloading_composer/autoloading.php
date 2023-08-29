<?php

// require_once '../app/PaymentGateway/Paddle/Transaction.php';

// Use the custom autoloading
// spl_autoload_register(function($class){
//     $path = __DIR__ . "\\" . lcfirst(str_replace("\\", '/', $class)) . ".php";
//     if (file_exists($path)) {
//         require $path;
//     }
// });

// Use composer's autoloader
require __DIR__ . '\vendor\autoload.php';
$id = new \Ramsey\Uuid\UuidFactory();

echo $id->uuid4();
