<?php

// Cookies are stored on the client side => can remain for as long as the set expiration date
// Sessions are stored on the server side => also destroyed when the browser is closed
session_start();

var_dump($_SESSION); echo '<br/>';

setcookie(
    'userName',
    'Dylan',
    time() + (24 * 60 * 60)
);

var_dump($_COOKIE); echo '<br/>';
