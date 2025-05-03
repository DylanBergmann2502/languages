// characters.rs

fn main() {
    // Character type in Rust: char
    // Rust chars are 4 bytes and represent Unicode scalar values
    let letter: char = 'a';
    let emoji: char = '🦀';
    let chinese: char = '中';
    let heart: char = '❤';

    println!("letter: {}", letter); // a
    println!("emoji: {}", emoji); // 🦀
    println!("chinese: {}", chinese); // 中
    println!("heart: {}", heart); // ❤

    // Character literals use single quotes
    // String literals use double quotes
    let char_a = 'a'; // char
    let string_a = "a"; // &str

    println!("\nChar vs String:");
    println!("char_a: {} (type: char)", char_a);
    println!("string_a: {} (type: &str)", string_a);

    // Size in memory
    println!("\nSize in memory:");
    println!("char size: {} bytes", std::mem::size_of::<char>()); // 4 bytes
    println!("u8 size: {} bytes", std::mem::size_of::<u8>()); // 1 byte
    println!("u32 size: {} bytes", std::mem::size_of::<u32>()); // 4 bytes

    // Escape sequences
    let newline = '\n';
    let tab = '\t';
    let carriage_return = '\r';
    let backslash = '\\';
    let single_quote = '\'';
    let null_char = '\0';

    println!("\nEscape sequences:");
    print!("newline: a{}b", newline); // a
                                      // b
    print!("tab: a{}b\n", tab); // a    b
    print!("carriage_return: a{}b\n", carriage_return); // a\rb
    print!("backslash: {}\n", backslash); // \
    print!("single_quote: {}\n", single_quote); // '
    println!("null_char Unicode: U+{:04X}", null_char as u32); // U+0000

    // Unicode escapes
    let unicode_4digit = '\u{2764}'; // ❤ heart
    let unicode_6digit = '\u{1F980}'; // 🦀 crab

    println!("\nUnicode escapes:");
    println!("\\u{{2764}}: {}", unicode_4digit); // ❤
    println!("\\u{{1F980}}: {}", unicode_6digit); // 🦀

    // Creating chars from u32 values
    println!("\nCreating chars from u32:");

    // Safe way using from_u32
    let valid_char = char::from_u32(97); // 'a'
    let invalid_char = char::from_u32(0xD800); // Invalid Unicode

    println!("from_u32(97): {:?}", valid_char); // Some('a')
    println!("from_u32(0xD800): {:?}", invalid_char); // None

    // Unsafe way using from_u32_unchecked
    unsafe {
        let unchecked_char = char::from_u32_unchecked(97);
        println!("from_u32_unchecked(97): {}", unchecked_char); // a
    }

    // Converting to u32
    println!("\nConverting to u32:");
    let ch = '👍';
    let as_u32 = ch as u32;
    let into_u32: u32 = ch.into();

    println!("'👍' as u32: {} (0x{:X})", as_u32, as_u32); // 128077 (0x1F44D)
    println!("'👍'.into(): {} (0x{:X})", into_u32, into_u32); // 128077 (0x1F44D)

    // Character properties and methods
    println!("\nCharacter properties:");

    // Checking character types
    let digit = '5';
    let letter = 'a';
    let uppercase = 'A';
    let whitespace = ' ';
    let control = '\n';

    println!("'5'.is_digit(10): {}", digit.is_digit(10)); // true
    println!("'a'.is_alphabetic(): {}", letter.is_alphabetic()); // true
    println!("'A'.is_uppercase(): {}", uppercase.is_uppercase()); // true
    println!("'a'.is_lowercase(): {}", letter.is_lowercase()); // true
    println!("' '.is_whitespace(): {}", whitespace.is_whitespace()); // true
    println!("'\\n'.is_control(): {}", control.is_control()); // true

    // Checking numeric properties
    let hex_digit = 'F';
    let decimal = '7';

    println!("\nNumeric properties:");
    println!("'F'.is_digit(16): {}", hex_digit.is_digit(16)); // true
    println!("'F'.is_digit(10): {}", hex_digit.is_digit(10)); // false
    println!("'7'.to_digit(10): {:?}", decimal.to_digit(10)); // Some(7)
    println!("'F'.to_digit(16): {:?}", hex_digit.to_digit(16)); // Some(15)

    // Case conversion
    println!("\nCase conversion:");
    let lower_a = 'a';
    let upper_a = 'A';
    let german_ss = 'ß'; // German sharp s

    println!(
        "'a'.to_uppercase(): {:?}",
        lower_a.to_uppercase().collect::<String>()
    ); // "A"
    println!(
        "'A'.to_lowercase(): {:?}",
        upper_a.to_lowercase().collect::<String>()
    ); // "a"
    println!(
        "'ß'.to_uppercase(): {:?}",
        german_ss.to_uppercase().collect::<String>()
    ); // "SS"

    // Note: to_uppercase() and to_lowercase() return iterators
    // because some characters map to multiple characters when changing case

    // ASCII operations
    println!("\nASCII operations:");
    let ascii_char = 'A';
    let non_ascii = '♥';

    println!("'A'.is_ascii(): {}", ascii_char.is_ascii()); // true
    println!("'♥'.is_ascii(): {}", non_ascii.is_ascii()); // false
    println!(
        "'A'.to_ascii_lowercase(): {}",
        ascii_char.to_ascii_lowercase()
    ); // a
    println!("'a'.to_ascii_uppercase(): {}", 'a'.to_ascii_uppercase()); // A

    // Char ranges and iteration
    println!("\nChar ranges and iteration:");

    // Iterating through char ranges
    print!("'a'..='e': ");
    for ch in 'a'..='e' {
        print!("{} ", ch); // a b c d e
    }
    println!();

    // Unicode scalar value iteration
    print!("'A'..='E' values: ");
    for ch in 'A'..='E' {
        print!("{}({}) ", ch, ch as u32); // A(65) B(66) C(67) D(68) E(69)
    }
    println!();

    // Character escape_debug
    println!("\nEscape debug representation:");
    let tab = '\t';
    let newline = '\n';
    let quote = '"';
    let unicode = '🦀';

    println!("'\\t'.escape_debug(): {}", tab.escape_debug()); // \t
    println!("'\\n'.escape_debug(): {}", newline.escape_debug()); // \n
    println!("'\"'.escape_debug(): {}", quote.escape_debug()); // "
    println!("'🦀'.escape_debug(): {}", unicode.escape_debug()); // 🦀

    // Character length in UTF-8 encoding
    println!("\nUTF-8 encoding length:");
    let ascii = 'a';
    let latin = 'é';
    let chinese = '中';
    let emoji = '🦀';

    println!("'a' len_utf8(): {} bytes", ascii.len_utf8()); // 1 bytes
    println!("'é' len_utf8(): {} bytes", latin.len_utf8()); // 2 bytes
    println!("'中' len_utf8(): {} bytes", chinese.len_utf8()); // 3 bytes
    println!("'🦀' len_utf8(): {} bytes", emoji.len_utf8()); // 4 bytes

    // Encoding a char to UTF-8
    let mut buffer = [0; 4]; // char can be at most 4 bytes in UTF-8
    let crab = '🦀';
    let encoded = crab.encode_utf8(&mut buffer);

    println!("\nUTF-8 encoding:");
    println!("'🦀' encoded: {:?}", encoded); // "🦀"
    println!("Bytes: {:?}", &buffer[..crab.len_utf8()]); // [240, 159, 166, 128]

    // Pattern matching with chars
    println!("\nPattern matching:");
    let ch = 'x';

    match ch {
        'a'..='z' => println!("{} is lowercase", ch),
        'A'..='Z' => println!("{} is uppercase", ch),
        '0'..='9' => println!("{} is digit", ch),
        _ => println!("{} is something else", ch),
    }

    // Using chars in strings
    println!("\nChars in strings:");
    let s = "Hello";

    // Getting individual chars
    if let Some(first) = s.chars().next() {
        println!("First char: {}", first); // H
    }

    // Counting chars vs bytes
    let unicode_str = "🦀🦀🦀";
    println!("String: {}", unicode_str);
    println!("Byte length: {}", unicode_str.len()); // 12
    println!("Char count: {}", unicode_str.chars().count()); // 3
}
