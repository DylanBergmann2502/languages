<?php

class Invoice {
    // // __get N __set get triggered automatically
    // // if the property does not exist or is not accessible
    // protected float $amount;

    // // These __get and __set methods don't replace the standard getter and setter
    // public function __get(string $name) {
    //     if (property_exists($this, $name)) {
    //         return $this->$name;
    //     }
    //     return null;
    // }

    // public function __set(string $name, $value): void {
    //     if (property_exists($this, $name)) {
    //         $this->$name = $value;
    //     }
    // }

    protected array $data = [];
    public function __get(string $name) {
        if (array_key_exists($name, $this->data)) {
            return $this->data[$name];
        }
        return null;
    }
    public function __set(string $name, $value) {
        $this->data[$name] = $value;
    }
    public function __isset(string $name): bool {
        return array_key_exists($name, $this->data);
    }
    public function __unset(string $name): void {
        unset($this->data[$name]);
    }
    public function __call(string $name, array $args) {
        var_dump($name, $args);
    }
    public static function __callStatic(string $name, array $args) {
        var_dump('static', $name, $args);
    }

    public function __toString(): string {
        return 'Hello';
    }
    public function __invoke(){
        var_dump('invoked');
    }
    // public function __debugInfo(): ?array {}
}
