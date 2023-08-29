<?php

class Rocky implements DebtCollectorInterface {
    public function collect(float $owedAmount): float {
        return $owedAmount * 0.65;
    }
}
