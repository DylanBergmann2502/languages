<?php
declare(strict_types=1);

namespace Basic;

// You don't have to name the class after the file but it's recommended
// You can have > 1 classes in your file
// But it's recommended to have one class per file
class Transaction {
    // public: accessible everywhere
    // private: accessible only inside the current class
    // protected: accessible inside the current class and the child classes
    private float $amount;
    private string $description;

    public function __construct(float $amount, string $description) {
        $this->amount = $amount;
        $this->description = $description;
    }
    ////////////////////////////////////////////////////////////////
    // public function addTax(float $rate): float {
    //     return $this->amount += $this->amount * $rate / 100;
    // }
    // public function applyDiscount(float $rate): float {
    //     return $this->amount -= $this->amount * $rate / 100;
    // }

    // To chain different methods, we can return the class itself
    public function addTax(float $rate): Transaction {
        $this->amount += $this->amount * $rate / 100;
        return $this;
    }
    public function applyDiscount(float $rate): Transaction {
        $this->amount -= $this->amount * $rate / 100;
        return $this;
    }

    public function getAmount(): float {
        return $this->amount;
    }

    public function setAmount(float $amount) {
        $this->amount = $amount;
    }

    ////////////////////////////////////////////////////////////////
    // Destructor
    // This will execute when the object has been done with
    public function __destruct() {
        echo 'Destruct ' . $this->description . '<br/>';
    }
}
