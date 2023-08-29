<?php

require_once './late_static_binding/ClassA.php';
require_once './late_static_binding/ClassB.php';

var_dump(ClassA::make1()); echo "<br/>";
var_dump(ClassB::make1()); echo "<br/>";

var_dump(ClassA::make2()); echo "<br/>";
var_dump(ClassB::make2()); echo "<br/>";

var_dump(ClassA::make3()); echo "<br/>";
var_dump(ClassB::make3()); echo "<br/>";
