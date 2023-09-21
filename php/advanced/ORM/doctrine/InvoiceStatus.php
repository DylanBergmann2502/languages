<?php

// Enum Case without scalar values = Pure Case
// Enum Class that has Pure Cases = Pure Enum
// Enum Case with scalar values = Backed Case
// Enum Class that has Backed Cases = Backed Enum
// To fully indicate a Backed Enum => must type hint that enum
// Backed Enum must either be of string or int type

/**
 * Enum's caveats:
 * * NO
 * It cannot not have states => cannot have Constructor and Destructor
 * Inheritance and Properties are not allowed
 * Cloning is not allowed bc cases are singleton objects
 * Magic methods are not allowed except for __call, __callStatic, __invoke
 * Instantiation is not possible
 * * YES
 * public, private, protected methods
 * static methods, constants
 * interfaces
 * traits without properties
 * enum class attributes: Attribute::TARGET_CLASS
 * enum case attributes: Attribute::TARGET_CLASS_CONSTANTS
 */

// Enums can implement interfaces and use traits
// But these traits cannot have properties
enum InvoiceStatus: int implements InvoiceStatusInterface {
    use InvoiceStatusTrait;

    // each case is an object of the enum
    // => you can type hint the enum cases with the enum class name

    // You cannot have a mix backed & pure cases
    // Case's name and value must be unique
    case Pending = 0;
    case Paid = 1;
    case Void = 2;
    case Failed = 3;

    public function toString(): string {
        return match($this) {
            self::Paid => 'Paid',
            self::Void => 'Void',
            self::Failed => 'Declined',
            default => 'Pending'
        };
    }

    public function color(): Color {
        return match($this) {
            self::Paid => Color::Green,
            self::Void => Color::Gray,
            self::Failed => Color::Red,
            default => Color::Orange
        };
    }
}
