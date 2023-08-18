<?php

ob_start();
include './partials/nav.php';
$nav = ob_get_clean();

$nav = str_replace('About', 'About Us', $nav);
echo $nav;
