// String vs &str - Two main string types in Rust
// &str (string slice) - immutable reference to string data
// String - owned, growable string type

fn main() {
    // Creating string literals (&str)
    let string_literal = "Hello, World!";
    let another_literal: &str = "This is a string slice";
    println!("String literal: {}", string_literal); // Hello, World!
    println!("Another literal: {}", another_literal); // This is a string slice

    // Creating owned strings (String)
    let mut owned_string = String::new(); // Empty string
    let from_literal = String::from("Hello");
    let to_string = "World".to_string();
    println!("Empty string: '{}'", owned_string); // ''
    println!("From literal: {}", from_literal); // Hello
    println!("To string: {}", to_string); // World

    // String capacity and length
    println!("Length of 'Hello': {}", from_literal.len()); // 5
    println!("Capacity: {}", from_literal.capacity()); // Usually >= 5
    println!("Is empty: {}", owned_string.is_empty()); // true

    // Modifying strings (only String, not &str)
    owned_string.push_str("Hello");
    println!("After push_str: {}", owned_string); // Hello
    owned_string.push(' '); // Single character
    owned_string.push_str("Rust!");
    println!("After push and push_str: {}", owned_string); // Hello Rust!

    // String concatenation
    let hello = String::from("Hello");
    let world = String::from(" World");
    let concatenated = hello + &world; // hello is moved here
    println!("Concatenated: {}", concatenated); // Hello World
    // println!("{}", hello); // Error: hello was moved

    // Using format! macro (doesn't move values)
    let greeting = "Hello";
    let name = "Alice";
    let message = format!("{}, {}!", greeting, name);
    println!("Formatted: {}", message); // Hello, Alice!
    println!("Original greeting: {}", greeting); // Still available

    // String slicing
    let text = "Hello, Rust programming!";
    let hello = &text[0..5];
    let rust = &text[7..11];
    println!("Slice 'hello': {}", hello); // Hello
    println!("Slice 'rust': {}", rust); // Rust

    // Be careful with non-ASCII characters
    let japanese = "こんにちは";
    println!("Japanese length in bytes: {}", japanese.len()); // 15 (not 5!)
    println!("Japanese char count: {}", japanese.chars().count()); // 5

    // Safe ways to get substrings with Unicode
    let first_char = japanese.chars().next().unwrap();
    println!("First character: {}", first_char); // こ

    // String methods for checking content
    let sample = "Hello, World!";
    println!("Starts with 'Hello': {}", sample.starts_with("Hello")); // true
    println!("Ends with '!': {}", sample.ends_with("!")); // true
    println!("Contains 'World': {}", sample.contains("World")); // true
    println!("Is ASCII: {}", sample.is_ascii()); // true

    // Case conversion
    let mixed_case = "Hello World";
    println!("Uppercase: {}", mixed_case.to_uppercase()); // HELLO WORLD
    println!("Lowercase: {}", mixed_case.to_lowercase()); // hello world
    println!("Original unchanged: {}", mixed_case); // Hello World

    // Trimming whitespace
    let padded = "  Hello, Rust!  ";
    println!("Original: '{}'", padded); // '  Hello, Rust!  '
    println!("Trimmed: '{}'", padded.trim()); // 'Hello, Rust!'
    println!("Trim start: '{}'", padded.trim_start()); // 'Hello, Rust!  '
    println!("Trim end: '{}'", padded.trim_end()); // '  Hello, Rust!'

    // Splitting strings
    let csv = "apple,banana,orange";
    let fruits: Vec<&str> = csv.split(',').collect();
    println!("Split fruits: {:?}", fruits); // ["apple", "banana", "orange"]

    let sentence = "Hello world from Rust";
    let words: Vec<&str> = sentence.split_whitespace().collect();
    println!("Words: {:?}", words); // ["Hello", "world", "from", "Rust"]

    // Replacing parts of strings
    let original = "Hello, World!";
    let replaced = original.replace("World", "Rust");
    println!("Replaced: {}", replaced); // Hello, Rust!
    println!("Original: {}", original); // Hello, World!

    // Multiple replacements
    let text_with_spaces = "a b c d";
    let no_spaces = text_with_spaces.replace(" ", "");
    println!("Without spaces: {}", no_spaces); // abcd

    // Parsing strings to numbers
    let number_str = "42";
    let parsed_number: i32 = number_str.parse().unwrap();
    println!("Parsed number: {}", parsed_number); // 42

    // Safe parsing with error handling
    let maybe_number = "not_a_number";
    match maybe_number.parse::<i32>() {
        Ok(num) => println!("Parsed: {}", num),
        Err(_) => println!("Could not parse '{}' as number", maybe_number), // This will execute
    }

    // Converting numbers to strings
    let number = 123;
    let number_string = number.to_string();
    println!("Number as string: {}", number_string); // 123

    // Iterating over characters
    let word = "Rust";
    print!("Characters: ");
    for ch in word.chars() {
        print!("'{}' ", ch); // 'R' 'u' 's' 't'
    }
    println!();

    // Iterating over bytes
    print!("Bytes: ");
    for byte in word.bytes() {
        print!("{} ", byte); // 82 117 115 116
    }
    println!();

    // String comparison
    let str1 = "apple";
    let str2 = "banana";
    let str3 = "apple";
    println!("'{}' == '{}': {}", str1, str2, str1 == str2); // false
    println!("'{}' == '{}': {}", str1, str3, str1 == str3); // true
    println!("'{}' < '{}': {}", str1, str2, str1 < str2); // true (lexicographic)

    // Building strings efficiently
    let mut builder = String::with_capacity(50); // Pre-allocate capacity
    builder.push_str("Building ");
    builder.push_str("a ");
    builder.push_str("string ");
    builder.push_str("efficiently");
    println!("Built string: {}", builder); // Building a string efficiently

    // Joining strings from a vector
    let words_vec = vec!["Rust", "is", "awesome"];
    let joined = words_vec.join(" ");
    println!("Joined: {}", joined); // Rust is awesome

    // String indexing (careful with Unicode!)
    let ascii_text = "Hello";
    // Direct indexing not allowed: ascii_text[0] // This would be an error
    // Use chars().nth() for safe character access
    if let Some(first_char) = ascii_text.chars().nth(0) {
        println!("First character: {}", first_char); // H
    }

    // Converting between String and &str
    let owned = String::from("Hello");
    let borrowed: &str = &owned; // String to &str
    let owned_again: String = borrowed.to_string(); // &str to String
    println!(
        "Owned: {}, Borrowed: {}, Owned again: {}",
        owned, borrowed, owned_again
    );

    // Raw strings (useful for regex, file paths, etc.)
    let raw_string = r#"This is a raw string with \n and " that are not escaped"#;
    println!("Raw string: {}", raw_string); // Backslashes are literal

    let multi_line_raw = r#"
        This is a multi-line
        raw string with "quotes"
        and \backslashes
    "#;
    println!("Multi-line raw: {}", multi_line_raw);
}
