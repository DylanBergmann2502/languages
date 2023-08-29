<?php

declare(strict_types=1);

namespace Inner;

// or you can load DateTime from the global namespace using "use"
use DateTime;

// Aliasing
use Basic\Transaction as BasicTransaction;

class Transaction {
    public function __construct() {
        // You can use other classes from the same namespace
        var_dump(new CustomerProfile());

        // "\" tells PHP to not load the name from the local namespace
        // instead, load it from the global namespace
        var_dump(new \DateTime());

        // Basically, PHP will load classes from the current namespace
        // -> look for use/import statements -> throw an error
        // But for functions, if it doesn't exist in the local namespace,
        // it will fall back to the global namespace
        // "\" tells PHP to look for this function the global namespace
        var_dump(\explode(",", 'hello,world'));

        // Aliasing
        var_dump(new BasicTransaction(100, 'Transaction 1'));
    }
}

function explode($separator, $str) {
    return 'foo';
}
