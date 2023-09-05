<?php

class Invoice {
    private string $id;

    public function __construct() {
        $this->id = uniqid('invoice_');
        var_dump("__construct"); echo '<br/>';
    }

    public function __clone(): void {
        $this->id = uniqid('invoice_');
        var_dump("__clone"); echo '<br/>';
    }
}
