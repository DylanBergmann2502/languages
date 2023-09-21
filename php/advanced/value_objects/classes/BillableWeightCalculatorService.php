<?php

class BillableWeightCalculatorService {
    public function calculate(
        PackageDimension $packageDimension,
        Weight $weight,
        DimDivisor $dimDivisor
    ) {
        $dimWeight = (int) round(
            $packageDimension->width * $packageDimension->height * $packageDimension->length / $dimDivisor->value
        );

        return max($dimWeight, $weight->value);
    }
}
