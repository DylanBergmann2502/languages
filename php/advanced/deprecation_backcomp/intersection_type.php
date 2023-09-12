<?php

class MyClass {
    public function __construct(
        // $entity must implement both Syncable and Syncable
        // You cannot use & and | at the same time
        private Syncable&Payable $entity
    ){}
}
