fn main() {
    // SCALAR TYPES
    println!("--- SCALAR TYPES ---");

    // Integer Types
    println!("\n-- Integer Types --");

    // Signed integers: i8, i16, i32, i64, i128, isize
    let signed_integer: i32 = -42;
    println!("Signed integer (i32): {}", signed_integer);

    // Unsigned integers: u8, u16, u32, u64, u128, usize
    let unsigned_integer: u32 = 42;
    println!("Unsigned integer (u32): {}", unsigned_integer);

    // isize and usize depend on the computer architecture
    // 64 bits on 64-bit architecture, 32 bits on 32-bit architecture
    let architecture_dependent: usize = 100;
    println!(
        "Architecture dependent integer (usize): {}",
        architecture_dependent
    );

    // Integer literals
    let decimal = 98_222; // Decimal (with visual separator _)
    let hex = 0xff; // Hex
    let octal = 0o77; // Octal
    let binary = 0b1111_0000; // Binary
    let byte = b'A'; // Byte (u8 only) - ASCII value of 'A'

    println!(
        "Integer literals: decimal={}, hex={}, octal={}, binary={}, byte={}",
        decimal, hex, octal, binary, byte
    );

    // Integer Overflow
    // In debug mode, Rust checks for integer overflow and will panic
    // In release mode, Rust performs two's complement wrapping
    // let will_overflow: u8 = 256; // This would cause a compile error

    // Explicit handling of potential overflow using wrapping_* methods
    let wrapped = 255_u8.wrapping_add(1);
    println!("255 + 1 with wrapping: {}", wrapped); // Will be 0

    // Floating-Point Types
    println!("\n-- Floating-Point Types --");

    // f32 and f64 (default is f64)
    let float_32: f32 = 3.14;
    let float_64 = 3.14159265359; // Type inferred as f64

    println!("32-bit float: {}", float_32);
    println!("64-bit float: {}", float_64);

    // Mathematical operations
    let sum = 5.0 + 10.0; // Addition
    let difference = 95.5 - 4.3; // Subtraction
    let product = 4.0 * 30.0; // Multiplication
    let quotient = 56.7 / 32.2; // Division
    let remainder = 43.0 % 5.0; // Remainder

    println!(
        "Mathematical operations: sum={}, difference={}, product={}, quotient={}, remainder={}",
        sum, difference, product, quotient, remainder
    );

    // Boolean Type
    println!("\n-- Boolean Type --");

    let true_value: bool = true;
    let false_value: bool = false;

    println!("Boolean values: true={}, false={}", true_value, false_value);

    // Boolean expressions
    let is_greater = 10 > 5;
    println!("Is 10 greater than 5? {}", is_greater);

    // Character Type
    println!("\n-- Character Type --");

    // char type is 4 bytes in size and represents a Unicode Scalar Value
    let character: char = 'z';
    let emoji: char = '😀';
    let chinese: char = '中';

    println!(
        "Characters: Latin={}, Emoji={}, Chinese={}",
        character, emoji, chinese
    );
    println!("Size of char type: {} bytes", std::mem::size_of::<char>());

    // COMPOUND TYPES
    println!("\n--- COMPOUND TYPES ---");

    // Tuple Type
    println!("\n-- Tuple Type --");

    // A tuple is a collection of values of different types
    let tuple: (i32, f64, char) = (500, 6.4, 'A');

    // Accessing tuple elements
    println!(
        "Tuple elements: first={}, second={}, third={}",
        tuple.0, tuple.1, tuple.2
    );

    // Destructuring a tuple
    let (x, y, z) = tuple;
    println!("Destructured tuple: x={}, y={}, z={}", x, y, z);

    // Unit tuple () - represents an empty value or empty return type
    let empty_tuple = ();
    println!(
        "Empty tuple size: {} bytes",
        std::mem::size_of_val(&empty_tuple)
    );

    // Array Type
    println!("\n-- Array Type --");

    // Arrays in Rust have fixed length and elements of the same type
    let array: [i32; 5] = [1, 2, 3, 4, 5];

    // Accessing array elements
    println!("Array elements: first={}, second={}", array[0], array[1]);

    // Arrays with the same value
    let same_value_array = [3; 5]; // [3, 3, 3, 3, 3]
    println!("Array with same values: {:?}", same_value_array);

    // Array length
    println!("Array length: {}", array.len());

    // Array memory allocation (on the stack)
    println!("Array memory size: {} bytes", std::mem::size_of_val(&array));

    // Slices
    println!("\n-- Slices --");

    // Slices let you reference a contiguous sequence of elements
    let slice = &array[1..4]; // Elements at indices 1, 2, and 3

    println!("Slice elements: {:?}", slice);
    println!("Slice length: {}", slice.len());

    // String slices
    let string = String::from("hello world");
    let hello = &string[0..5]; // or &string[..5]
    let world = &string[6..11]; // or &string[6..]

    println!("String: {}", string);
    println!("String slices: '{}' and '{}'", hello, world);

    // String literals are slices
    let string_literal = "This is a string literal";
    println!("String literal (str slice): {}", string_literal);

    // TYPE CONVERSION
    println!("\n--- TYPE CONVERSION ---");

    // Explicit conversion (casting)
    let a = 15_i32;
    let b = a as i64; // i32 to i64
    let c = b as f64; // i64 to f64

    println!("Casting: i32({}) -> i64({}) -> f64({})", a, b, c);

    // Be careful with narrowing conversions
    let large_number = 1000_i32;
    let smaller_type = large_number as u8; // This will truncate!

    println!(
        "Narrowing conversion: i32({}) -> u8({})",
        large_number, smaller_type
    );

    // From and Into traits
    let s = String::from("hello"); // str to String
    println!("String from str: {}", s);

    // TryFrom and TryInto for conversions that might fail
    let result = u8::try_from(1000_i32);
    match result {
        Ok(value) => println!("Successful conversion: {}", value),
        Err(e) => println!("Failed conversion: {}", e),
    }
}
