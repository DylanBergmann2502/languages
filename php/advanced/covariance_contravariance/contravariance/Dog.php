<?php

declare(strict_types=1);

class Dog extends Animal {
    public function speak() {
        echo $this->name . ' barks!'; echo '</br>';
    }

    public function eat(Food $food){
        echo $this->name . " eats " . get_class($food);
    }
}
