<?php

class InvoiceStatusClass {
    public const PENDING = 0;
    public const PAID    = 1;
    public const VOID    = 2;
    public const FAILED  = 3;

    public function all(): array {
        return [
            self::PAID,
            self::FAILED,
            self::VOID,
            self::PENDING
        ];
    }
}
