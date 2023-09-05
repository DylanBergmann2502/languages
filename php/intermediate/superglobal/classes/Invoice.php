<?php

declare(strict_types=1);

class Invoice {
    public function index(): string{
        return 'Invoice';
    }

    public function create(): string {
        return '<form action="/invoices/create" method="post"><label>Amount</label></form>';
    }

    public function store(): void {
        $amount = $_POST['amount'];
        var_dump($amount);
    }
}
