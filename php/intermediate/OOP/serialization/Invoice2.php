<?php

class Invoice2 {
    public string $id;


    public function __construct(
        public float $amount,
        public string $creditCardNumber // trying to remove this from the serialization
    )
    {
        $this->id = uniqid('invoice_');
    }

    // Called before the object serialization
    // Must return the names of the properties to be serialized
    public function __sleep(): array {
        return ['id', 'amount'];
    }

    // Called after the object deserialization
    public function __wakeup(): void {
    }

    // This magic method is a combination of __sleep() and serialize() from the Serializable interface
    // It's not limited to just the class properties
    // It can also add new key value pairs and customize the serialization however you want
    // When you have both sleep() and serialize() => serialize() > sleep()
    public function __serialize(): array {
        return [
            'id' => $this->id,
            'amount' => $this->amount,
            'creditCardNumber' => base64_encode($this->creditCardNumber),
            'foo' => 'bar'
        ];
    }

    // The same applies for unserialize()
    public function __unserialize(array $data): void {
        $this->id = $data['id'];
        $this->amount = $data['amount'];
        $this->creditCardNumber = base64_decode($data['creditCardNumber']);
    }
}
