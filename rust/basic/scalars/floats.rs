// floats.rs

fn main() {
    // Floating-point types in Rust
    let f32_val: f32 = 3.14159;
    let f64_val: f64 = 3.14159265358979323846; // Default type for floating literals

    println!("f32: {}", f32_val); // 3.14159
    println!("f64: {}", f64_val); // 3.141592653589793

    // Type inference
    let default_float = 2.0; // f64 by default
    let explicit_f32 = 2.0f32; // f32 with suffix
    let explicit_f64 = 2.0f64; // f64 with suffix

    println!("\nType inference:");
    println!("default_float: {}", default_float); // 2
    println!("explicit_f32: {}", explicit_f32); // 2
    println!("explicit_f64: {}", explicit_f64); // 2

    // Scientific notation
    let scientific = 1.5e3; // 1.5 × 10³
    let negative_exp = 1.5e-3; // 1.5 × 10⁻³

    println!("\nScientific notation:");
    println!("1.5e3: {}", scientific); // 1500
    println!("1.5e-3: {}", negative_exp); // 0.0015

    // Special values
    println!("\nSpecial values:");
    let infinity = f32::INFINITY;
    let neg_infinity = f32::NEG_INFINITY;
    let nan = f32::NAN;

    println!("INFINITY: {}", infinity); // inf
    println!("NEG_INFINITY: {}", neg_infinity); // -inf
    println!("NAN: {}", nan); // NaN

    // Creating special values through operations
    let div_by_zero = 1.0f32 / 0.0;
    let neg_div_by_zero = -1.0f32 / 0.0;
    let zero_div_zero = 0.0f32 / 0.0;
    let sqrt_negative = (-1.0f32).sqrt();

    println!("\nSpecial values from operations:");
    println!("1.0 / 0.0: {}", div_by_zero); // inf
    println!("-1.0 / 0.0: {}", neg_div_by_zero); // -inf
    println!("0.0 / 0.0: {}", zero_div_zero); // NaN
    println!("sqrt(-1.0): {}", sqrt_negative); // NaN

    // Checking for special values
    println!("\nChecking special values:");
    println!("infinity.is_infinite(): {}", infinity.is_infinite()); // true
    println!("infinity.is_finite(): {}", infinity.is_finite()); // false
    println!("nan.is_nan(): {}", nan.is_nan()); // true
    println!("3.14.is_normal(): {}", 3.14f32.is_normal()); // true

    // NaN comparisons (NaN is not equal to anything, including itself)
    println!("\nNaN comparisons:");
    println!("nan == nan: {}", nan == nan); // false
    println!("nan != nan: {}", nan != nan); // true
    println!("nan < 1.0: {}", nan < 1.0); // false
    println!("nan > 1.0: {}", nan > 1.0); // false
    println!("nan <= 1.0: {}", nan <= 1.0); // false
    println!("nan >= 1.0: {}", nan >= 1.0); // false

    // Precision and rounding
    println!("\nPrecision and rounding:");
    let precise = 0.1 + 0.2;
    println!("0.1 + 0.2: {}", precise); // 0.30000000000000004
    println!("0.1 + 0.2 == 0.3: {}", precise == 0.3); // false

    // Using epsilon for float comparison
    let epsilon = f32::EPSILON;
    let a = 0.1f32 + 0.2f32;
    let b = 0.3f32;
    let difference = (a - b).abs();

    println!("\nFloat comparison with epsilon:");
    println!("f32::EPSILON: {}", epsilon); // 0.00000011920929
    println!("difference: {}", difference); // 0.00000005960464
    println!("difference < epsilon: {}", difference < epsilon); // true

    // Mathematical operations
    println!("\nMathematical operations:");
    let x = 2.0f32;
    let y = 3.0f32;

    println!("x + y: {}", x + y); // 5
    println!("x - y: {}", x - y); // -1
    println!("x * y: {}", x * y); // 6
    println!("x / y: {}", x / y); // 0.6666667
    println!("x % y: {}", x % y); // 2
    println!("x.powf(y): {}", x.powf(y)); // 8

    // Common mathematical functions
    println!("\nMathematical functions:");
    let angle = std::f32::consts::PI / 4.0; // 45 degrees

    println!("sin(π/4): {}", angle.sin()); // 0.70710677
    println!("cos(π/4): {}", angle.cos()); // 0.70710677
    println!("tan(π/4): {}", angle.tan()); // 0.99999994
    println!("sqrt(16.0): {}", 16.0f32.sqrt()); // 4
    println!("cbrt(27.0): {}", 27.0f32.cbrt()); // 3
    println!("exp(1.0): {}", 1.0f32.exp()); // 2.7182817
    println!("ln(e): {}", std::f32::consts::E.ln()); // 1
    println!("log10(100.0): {}", 100.0f32.log10()); // 2
    println!("log2(8.0): {}", 8.0f32.log2()); // 3

    // Rounding functions
    println!("\nRounding functions:");
    let num = 3.7f32;
    let neg_num = -3.7f32;

    println!("3.7.floor(): {}", num.floor()); // 3
    println!("3.7.ceil(): {}", num.ceil()); // 4
    println!("3.7.round(): {}", num.round()); // 4
    println!("3.7.trunc(): {}", num.trunc()); // 3
    println!("-3.7.floor(): {}", neg_num.floor()); // -4
    println!("-3.7.ceil(): {}", neg_num.ceil()); // -3
    println!("-3.7.round(): {}", neg_num.round()); // -4
    println!("-3.7.trunc(): {}", neg_num.trunc()); // -3

    // Float constants
    println!("\nFloat constants:");
    println!("f32::PI: {}", std::f32::consts::PI); // 3.1415927
    println!("f32::E: {}", std::f32::consts::E); // 2.7182817
    println!("f32::SQRT_2: {}", std::f32::consts::SQRT_2); // 1.4142135
    println!("f32::LN_2: {}", std::f32::consts::LN_2); // 0.6931472
    println!("f32::LN_10: {}", std::f32::consts::LN_10); // 2.3025851

    // Min/Max values
    println!("\nMin/Max values:");
    println!("f32::MIN: {}", f32::MIN); // -340282350000000000000000000000000000000
    println!("f32::MAX: {}", f32::MAX); // 340282350000000000000000000000000000000
    println!("f32::MIN_POSITIVE: {}", f32::MIN_POSITIVE); // 0.000000000000000000000000000000000000011754944

    // Size and precision
    println!("\nSize and precision:");
    println!("f32 size: {} bytes", std::mem::size_of::<f32>()); // 4 bytes
    println!("f64 size: {} bytes", std::mem::size_of::<f64>()); // 8 bytes
    println!("f32 mantissa digits: {}", f32::MANTISSA_DIGITS); // 24
    println!("f64 mantissa digits: {}", f64::MANTISSA_DIGITS); // 53
    println!("f32 radix: {}", f32::RADIX); // 2

    // Advanced float operations
    println!("\nAdvanced operations:");
    let val = 3.14f32;

    println!("3.14.abs(): {}", val.abs()); // 3.14
    println!("(-3.14).abs(): {}", (-val).abs()); // 3.14
    println!("3.14.signum(): {}", val.signum()); // 1
    println!("(-3.14).signum(): {}", (-val).signum()); // -1
    println!("3.14.fract(): {}", val.fract()); // 0.14000005
    println!("3.14.recip(): {}", val.recip()); // 0.31847134

    // Min/Max operations
    println!("\nMin/Max operations:");
    let a = 3.14f32;
    let b = 2.71f32;

    println!("min(3.14, 2.71): {}", a.min(b)); // 2.71
    println!("max(3.14, 2.71): {}", a.max(b)); // 3.14
    println!("clamp(5.0, 0.0, 4.0): {}", 5.0f32.clamp(0.0, 4.0)); // 4

    // Converting from/to bits
    println!("\nBit representation:");
    let float_val = 1.5f32;
    let bits = float_val.to_bits();
    let from_bits = f32::from_bits(bits);

    println!("1.5f32 to bits: 0x{:x}", bits); // 0x3fc00000
    println!("from_bits(0x{:x}): {}", bits, from_bits); // 1.5

    // Parsing from strings
    println!("\nParsing from strings:");
    let parsed: Result<f32, _> = "3.14".parse();
    let invalid: Result<f32, _> = "not a number".parse();

    println!("\"3.14\".parse(): {:?}", parsed); // Ok(3.14)
    println!("\"not a number\".parse(): {:?}", invalid); // Err(ParseFloatError { kind: Invalid })

    // Float display with formatting
    println!("\nDisplay formatting:");
    let pi = std::f32::consts::PI;

    println!("default: {}", pi); // 3.1415927
    println!("2 decimal places: {:.2}", pi); // 3.14
    println!("5 decimal places: {:.5}", pi); // 3.14159
    println!("scientific: {:e}", pi); // 3.1415927e0
    println!("scientific (uppercase): {:E}", pi); // 3.1415927E0
}
