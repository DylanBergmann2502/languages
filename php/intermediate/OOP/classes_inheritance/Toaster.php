<?php
class Toaster {
    public array $slices;

    // change this to "private" => you cannot override private properties
    // you can only override public and protected
    protected int $size;

    public function __construct() {
        $this->slices = [];
        $this->size = 2;
    }

    public function addSlice(string $slice): void {
        if (count($this->slices) < $this->size) {
            $this->slices[] = $slice;
        }
    }

    public function toast() {
        foreach ($this->slices as $i => $slice) {
            echo ($i + 1) . ": Toasting " . $slice . PHP_EOL; echo "<br/>";
        }
    }
}
