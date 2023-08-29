<?php

require_once './classes_abstract/Field.php';
require_once './classes_abstract/Text.php';
require_once './classes_abstract/Boolean.php';
require_once './classes_abstract/Radio.php';
require_once './classes_abstract/Checkbox.php';

$fields = [
    new Text('baseText'),
    new Radio('baseRadio'),
    new Checkbox('baseCheckbox'),
];

foreach ($fields as $field) {
    echo $field->render(); echo "<br/>";
}
