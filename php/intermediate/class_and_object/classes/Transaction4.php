<?php

declare(strict_types=1);

class Transaction4 {
    private static int $count = 0;

    public function __construct(
        public float $amount,
        public string $description,
    ){
        self::$count++;
    }

    public function process() {
        // Static method/callback => cannot access $this
        array_map(static function () {
            //
        }, []);
        echo 'Processing Transaction';
    }

    // "$this" points to the object
    // "self" points to the class
    // => inside static method, you can only use "self"
    public static function getCount() {
        return self::$count;
    }
}
