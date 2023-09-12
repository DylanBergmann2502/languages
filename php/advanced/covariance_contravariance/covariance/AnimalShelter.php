<?php

declare(strict_types=1);

interface AnimalShelter {
    public function adopt(string $name): Animal;
}
