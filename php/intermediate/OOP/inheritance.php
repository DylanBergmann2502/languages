<?php

require_once './classes_inheritance/Toaster.php';
require_once './classes_inheritance/ToasterPro.php';

$toaster = new Toaster();

$toaster->addSlice('bread');
$toaster->addSlice('bread');
$toaster->addSlice('bread');
callToast($toaster);

////////////////////////////////////////////////////////////////////////
$toasterPro = new ToasterPro();

$toasterPro->addSlice('bread');
$toasterPro->addSlice('bread');
$toasterPro->addSlice('bread');
$toasterPro->addSlice('bread');
$toasterPro->addSlice('bread');
callToast($toasterPro);

function callToast(Toaster $toaster) {
    $toaster->toast();
}
