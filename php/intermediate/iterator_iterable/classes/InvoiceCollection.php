<?php

class InvoiceCollection implements \Iterator {

    private int $key;
    public function __construct(public array $invoices) {}

    // return a current invoice from the invoice list
    public function current(): mixed {
        echo __METHOD__; echo '<br/>';
        return current($this->invoices);
        // return $this->invoices[$this->key];
    }

    // it brings the internal pointer to the next element
    public function next(): void {
        echo __METHOD__; echo '<br/>';
        next($this->invoices);
        // ++$this->key;
    }

    // return the key of the current element of an array
    public function key(): mixed {
        echo __METHOD__; echo '<br/>';
        return key($this->invoices);
        // return $this->key;
    }

    // check if the current position is valid
    // returning false will make the loop stop
    public function valid(): bool {
        echo __METHOD__; echo '<br/>';
        return current($this->invoices) !== false;
        // return isset($this->invoices[$this->key]);
    }

    // this gets called at the beginning of each foreach loop
    // it resets the array pointer back to the beginning
    public function rewind(): void {
        echo __METHOD__; echo '<br/>';
        reset($this->invoices);
        // $this->key = 0;
    }
}
