<?php

declare(strict_types=1);

class Cat extends Animal {
    public function speak() {
        echo $this->name . ' meows!'; echo '</br>';
    }
}
