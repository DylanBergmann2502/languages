<?php

require_once './classes/RouteNotFoundException.php';
require_once './classes/Router.php';
require_once './classes/Home.php';
require_once './classes/Invoice.php';


echo '<pre>';
print_r($_SERVER);
echo '<pre>';

$router = new Router();

// $router->register('/', function(){
//     echo 'Home'; echo '<br/>';
// });

$router
->get('/', [Home::class, 'index'])
->get('/invoices', [Invoice::class, 'index'])
->get('/invoices', [Invoice::class, 'create'])
->post('/invoices/create', [Invoice::class, 'store']);

echo $router->resolve($_SERVER['REQUEST_URI'], strtolower($_SERVER['REQUEST_METHOD'])); echo '<br/>';
