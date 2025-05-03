// integers.rs

fn main() {
    // Signed integers (can be negative)
    let i8_val: i8 = -128;
    let i16_val: i16 = -32_768;
    let i32_val: i32 = -2_147_483_648;
    let i64_val: i64 = -9_223_372_036_854_775_808;
    let i128_val: i128 = -170_141_183_460_469_231_731_687_303_715_884_105_728;
    let isize_val: isize = -100; // Pointer-sized, depends on architecture

    println!("i8: {}", i8_val); // -128
    println!("i16: {}", i16_val); // -32768
    println!("i32: {}", i32_val); // -2147483648
    println!("i64: {}", i64_val); // -9223372036854775808
    println!("i128: {}", i128_val); // -170141183460469231731687303715884105728
    println!("isize: {}", isize_val); // -100

    // Unsigned integers (only positive)
    let u8_val: u8 = 255;
    let u16_val: u16 = 65_535;
    let u32_val: u32 = 4_294_967_295;
    let u64_val: u64 = 18_446_744_073_709_551_615;
    let u128_val: u128 = 340_282_366_920_938_463_463_374_607_431_768_211_455;
    let usize_val: usize = 100; // Pointer-sized, depends on architecture

    println!("\nu8: {}", u8_val); // 255
    println!("u16: {}", u16_val); // 65535
    println!("u32: {}", u32_val); // 4294967295
    println!("u64: {}", u64_val); // 18446744073709551615
    println!("u128: {}", u128_val); // 340282366920938463463374607431768211455
    println!("usize: {}", usize_val); // 100

    // Type inference - Rust can often infer the type
    let default_integer = 42; // i32 by default
    let inferred_u8 = 42u8; // u8 suffix
    let inferred_i64 = 42i64; // i64 suffix

    println!("\nType inference:");
    println!("default_integer: {}", default_integer); // 42
    println!("inferred_u8: {}", inferred_u8); // 42
    println!("inferred_i64: {}", inferred_i64); // 42

    // Number literals with different bases
    let decimal = 98_222; // Decimal
    let hex = 0xff; // Hexadecimal
    let octal = 0o77; // Octal
    let binary = 0b1111_0000; // Binary
    let byte = b'A'; // Byte (u8 only)

    println!("\nNumber literals:");
    println!("decimal: {}", decimal); // 98222
    println!("hex: {}", hex); // 255
    println!("octal: {}", octal); // 63
    println!("binary: {}", binary); // 240
    println!("byte: {}", byte); // 65

    // Overflow behavior in debug mode (panics)
    // In release mode, it wraps around
    println!("\nOverflow behavior:");

    // This would panic in debug mode
    // let overflow: u8 = 255 + 1;

    // Safe overflow handling
    let wrapped = 255u8.wrapping_add(1);
    let saturated = 255u8.saturating_add(1);
    let checked = 255u8.checked_add(1);
    let overflowed = 255u8.overflowing_add(1);

    println!("wrapping_add: {}", wrapped); // 0
    println!("saturating_add: {}", saturated); // 255
    println!("checked_add: {:?}", checked); // None
    println!("overflowing_add: {:?}", overflowed); // (0, true)

    // Common integer methods
    println!("\nCommon methods:");
    let _num = 42i32;

    println!("abs(-42): {}", (-42i32).abs()); // 42
    println!("pow(2, 3): {}", 2i32.pow(3)); // 8
    println!("min(10, 20): {}", 10i32.min(20)); // 10
    println!("max(10, 20): {}", 10i32.max(20)); // 20
    println!("clamp(50, 0, 10): {}", 50i32.clamp(0, 10)); // 10

    // Bitwise operations
    println!("\nBitwise operations:");
    let a = 0b1010u8; // 10
    let b = 0b1100u8; // 12

    println!("a: {:04b} ({})", a, a); // 1010 (10)
    println!("b: {:04b} ({})", b, b); // 1100 (12)
    println!("a & b: {:04b} ({})", a & b, a & b); // 1000 (8)
    println!("a | b: {:04b} ({})", a | b, a | b); // 1110 (14)
    println!("a ^ b: {:04b} ({})", a ^ b, a ^ b); // 0110 (6)
    println!("!a: {:08b} ({})", !a, !a); // 11110101 (245)
    println!("a << 1: {:04b} ({})", a << 1, a << 1); // 10100 (20)
    println!("a >> 1: {:04b} ({})", a >> 1, a >> 1); // 0101 (5)

    // Conversion between integer types
    println!("\nType conversions:");
    let small: u8 = 42;
    let medium: u16 = small as u16; // Safe upcast
    let large: u32 = medium as u32; // Safe upcast

    println!("u8 to u16: {} -> {}", small, medium); // 42 -> 42
    println!("u16 to u32: {} -> {}", medium, large); // 42 -> 42

    // Potentially lossy conversion
    let big: u32 = 300;
    let small_again: u8 = big as u8; // Truncates!

    println!("u32 to u8 (truncated): {} -> {}", big, small_again); // 300 -> 44

    // Safe conversion with TryFrom
    use std::convert::TryFrom;

    let safe_conversion = u8::try_from(300u32);
    let successful_conversion = u8::try_from(200u32);

    println!("TryFrom 300u32: {:?}", safe_conversion); // Err(TryFromIntError(()))
    println!("TryFrom 200u32: {:?}", successful_conversion); // Ok(200)

    // Integer division and remainder
    println!("\nDivision and remainder:");
    let dividend = 17;
    let divisor = 5;

    println!("{} / {} = {}", dividend, divisor, dividend / divisor); // 17 / 5 = 3
    println!("{} % {} = {}", dividend, divisor, dividend % divisor); // 17 % 5 = 2

    // Euclidean division and modulo - fix: explicitly specify types
    let a: i32 = -17;
    let b: i32 = 5;

    println!("\nEuclidean operations:");
    println!("{} / {} = {}", a, b, a / b); // -17 / 5 = -3
    println!("{} % {} = {}", a, b, a % b); // -17 % 5 = -2
    println!("{}.div_euclid({}) = {}", a, b, a.div_euclid(b)); // -17.div_euclid(5) = -4
    println!("{}.rem_euclid({}) = {}", a, b, a.rem_euclid(b)); // -17.rem_euclid(5) = 3

    // Checking properties
    println!("\nChecking properties:");
    let zero = 0i32;
    let positive = 42i32;
    let negative = -42i32;
    let even = 42i32;
    let odd = 43i32;

    println!("0.is_positive(): {}", zero.is_positive()); // false
    println!("42.is_positive(): {}", positive.is_positive()); // true
    println!("-42.is_negative(): {}", negative.is_negative()); // true
    println!("42 % 2 == 0 (is even): {}", even % 2 == 0); // true
    println!("43 % 2 == 0 (is even): {}", odd % 2 == 0); // false

    // From string parsing
    println!("\nParsing from strings:");
    let parsed: Result<i32, _> = "42".parse();
    let invalid: Result<i32, _> = "not a number".parse();
    let hex_parsed: Result<i32, _> = i32::from_str_radix("ff", 16);

    println!("\"42\".parse(): {:?}", parsed); // Ok(42)
    println!("\"not a number\".parse(): {:?}", invalid); // Err(ParseIntError { kind: InvalidDigit })
    println!("from_str_radix(\"ff\", 16): {:?}", hex_parsed); // Ok(255)

    // Useful constants
    println!("\nInteger constants:");
    println!("i32::MIN: {}", i32::MIN); // -2147483648
    println!("i32::MAX: {}", i32::MAX); // 2147483647
    println!("u32::MIN: {}", u32::MIN); // 0
    println!("u32::MAX: {}", u32::MAX); // 4294967295

    // Size in bytes
    println!("\nSize in bytes:");
    println!("i8: {} byte", std::mem::size_of::<i8>()); // 1 byte
    println!("i16: {} bytes", std::mem::size_of::<i16>()); // 2 bytes
    println!("i32: {} bytes", std::mem::size_of::<i32>()); // 4 bytes
    println!("i64: {} bytes", std::mem::size_of::<i64>()); // 8 bytes
    println!("i128: {} bytes", std::mem::size_of::<i128>()); // 16 bytes
    println!("isize: {} bytes", std::mem::size_of::<isize>()); // Depends on architecture
}
