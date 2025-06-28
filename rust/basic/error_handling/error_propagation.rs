// Error Propagation with the ? Operator in Rust
// The ? operator is syntactic sugar for early return on errors
// It works with Result<T, E> and Option<T> types
// Automatically converts error types using From trait
// Makes error handling code cleaner and more readable
// Can only be used in functions that return Result or Option
// The ? operator unwraps Ok/Some or returns Err/None early

use std::fmt;
use std::fs::File;
use std::io::{self, Read, Write};
use std::num::ParseIntError;

// Custom error types for demonstration
#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeSquareRoot,
    InvalidInput(String),
}

#[derive(Debug)]
enum FileError {
    IoError(io::Error),
    ParseError(ParseIntError),
    ValidationError(String),
}

// Implementing From trait for automatic error conversion
impl From<io::Error> for FileError {
    fn from(error: io::Error) -> Self {
        FileError::IoError(error)
    }
}

impl From<ParseIntError> for FileError {
    fn from(error: ParseIntError) -> Self {
        FileError::ParseError(error)
    }
}

// Implementing Display for better error messages
impl fmt::Display for MathError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MathError::DivisionByZero => write!(f, "Cannot divide by zero"),
            MathError::NegativeSquareRoot => {
                write!(f, "Cannot take square root of negative number")
            }
            MathError::InvalidInput(msg) => write!(f, "Invalid input: {}", msg),
        }
    }
}

impl fmt::Display for FileError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            FileError::IoError(e) => write!(f, "IO error: {}", e),
            FileError::ParseError(e) => write!(f, "Parse error: {}", e),
            FileError::ValidationError(msg) => write!(f, "Validation error: {}", msg),
        }
    }
}

// Function demonstrating basic ? operator usage
fn basic_question_mark_examples() {
    println!("=== Basic ? Operator Examples ===");

    // Without ? operator (verbose)
    fn parse_number_verbose(s: &str) -> Result<i32, ParseIntError> {
        match s.parse::<i32>() {
            Ok(n) => Ok(n),
            Err(e) => Err(e),
        }
    }

    // With ? operator (concise)
    fn parse_number_concise(s: &str) -> Result<i32, ParseIntError> {
        let n = s.parse::<i32>()?; // ? operator here
        Ok(n)
    }

    // Even more concise
    fn parse_number_ultra_concise(s: &str) -> Result<i32, ParseIntError> {
        s.parse::<i32>() // No need for ? if it's the last expression
    }

    // Testing the functions
    let test_inputs = vec!["42", "not_a_number", "-123"];

    for input in test_inputs {
        println!("Input: '{}'", input);
        println!("  Verbose result: {:?}", parse_number_verbose(input));
        println!("  Concise result: {:?}", parse_number_concise(input));
        println!(
            "  Ultra concise result: {:?}",
            parse_number_ultra_concise(input)
        );
    }
}

// Function demonstrating ? operator with Option<T>
fn option_question_mark_examples() {
    println!("\n=== ? Operator with Option<T> ===");

    // Function that might return None at various points
    fn get_first_word_length(text: Option<&str>) -> Option<usize> {
        let text = text?; // Early return if None
        let first_word = text.split_whitespace().next()?; // Early return if no words
        Some(first_word.len())
    }

    // Function that chains multiple Option operations
    fn extract_number_from_config(config: Option<&str>) -> Option<i32> {
        let config_str = config?;
        let number_str = config_str.split('=').nth(1)?;
        let trimmed = number_str.trim();
        trimmed.parse().ok() // Convert Result to Option
    }

    // Testing with different inputs
    let test_cases = vec![
        Some("Hello world from Rust"),
        Some("SingleWord"),
        Some(""),
        None,
    ];

    for case in test_cases {
        println!("Text: {:?}", case);
        println!("  First word length: {:?}", get_first_word_length(case));
    }

    let config_cases = vec![
        Some("timeout=30"),
        Some("debug=true"),
        Some("invalid_config"),
        Some("port=8080"),
        None,
    ];

    for config in config_cases {
        println!("Config: {:?}", config);
        println!(
            "  Extracted number: {:?}",
            extract_number_from_config(config)
        );
    }
}

// Function demonstrating error conversion with From trait
fn error_conversion_examples() {
    println!("\n=== Automatic Error Conversion ===");

    // Function that can have multiple error types
    fn read_and_parse_file(filename: &str) -> Result<i32, FileError> {
        let mut file = File::open(filename)?; // io::Error -> FileError
        let mut contents = String::new();
        file.read_to_string(&mut contents)?; // io::Error -> FileError

        let trimmed = contents.trim();
        if trimmed.is_empty() {
            return Err(FileError::ValidationError("File is empty".to_string()));
        }

        let number = trimmed.parse::<i32>()?; // ParseIntError -> FileError
        Ok(number)
    }

    // Function that reads multiple numbers from files
    fn read_multiple_numbers(filenames: &[&str]) -> Result<Vec<i32>, FileError> {
        let mut numbers = Vec::new();
        for filename in filenames {
            let number = read_and_parse_file(filename)?; // Early return on any error
            numbers.push(number);
        }
        Ok(numbers)
    }

    // Create some test files for demonstration
    fn create_test_files() -> io::Result<()> {
        std::fs::write("test_number1.txt", "42")?;
        std::fs::write("test_number2.txt", "123")?;
        std::fs::write("test_empty.txt", "")?;
        std::fs::write("test_invalid.txt", "not_a_number")?;
        Ok(())
    }

    // Clean up test files
    fn cleanup_test_files() {
        let files = [
            "test_number1.txt",
            "test_number2.txt",
            "test_empty.txt",
            "test_invalid.txt",
        ];
        for file in &files {
            let _ = std::fs::remove_file(file); // Ignore errors
        }
    }

    // Create test files
    if let Err(e) = create_test_files() {
        println!("Failed to create test files: {}", e);
        return;
    }

    // Test reading single files
    let test_files = vec![
        "test_number1.txt",
        "test_empty.txt",
        "test_invalid.txt",
        "nonexistent.txt",
    ];

    for filename in test_files {
        match read_and_parse_file(filename) {
            Ok(number) => println!("✅ Read number {} from {}", number, filename),
            Err(error) => println!("❌ Error reading {}: {}", filename, error),
        }
    }

    // Test reading multiple files
    let valid_files = ["test_number1.txt", "test_number2.txt"];
    match read_multiple_numbers(&valid_files) {
        Ok(numbers) => println!("✅ Read all numbers: {:?}", numbers),
        Err(error) => println!("❌ Error reading multiple files: {}", error),
    }

    let mixed_files = ["test_number1.txt", "test_empty.txt", "test_number2.txt"];
    match read_multiple_numbers(&mixed_files) {
        Ok(numbers) => println!("✅ Read all numbers: {:?}", numbers),
        Err(error) => println!("❌ Error reading multiple files: {}", error),
    }

    cleanup_test_files();
}

// Function demonstrating complex error propagation chains
fn complex_error_chains() {
    println!("\n=== Complex Error Propagation Chains ===");

    // Mathematical operations that can fail
    fn safe_divide(a: f64, b: f64) -> Result<f64, MathError> {
        if b == 0.0 {
            Err(MathError::DivisionByZero)
        } else {
            Ok(a / b)
        }
    }

    fn safe_sqrt(x: f64) -> Result<f64, MathError> {
        if x < 0.0 {
            Err(MathError::NegativeSquareRoot)
        } else {
            Ok(x.sqrt())
        }
    }

    fn parse_positive_float(s: &str) -> Result<f64, MathError> {
        let num = s
            .parse::<f64>()
            .map_err(|_| MathError::InvalidInput(format!("'{}' is not a valid number", s)))?;

        if num <= 0.0 {
            Err(MathError::InvalidInput(
                "Number must be positive".to_string(),
            ))
        } else {
            Ok(num)
        }
    }

    // Complex calculation that chains multiple operations
    fn calculate_result(a_str: &str, b_str: &str) -> Result<f64, MathError> {
        let a = parse_positive_float(a_str)?; // Parse first number
        let b = parse_positive_float(b_str)?; // Parse second number

        let sum = a + b;
        let quotient = safe_divide(sum, 2.0)?; // Divide by 2
        let result = safe_sqrt(quotient)?; // Take square root

        Ok(result)
    }

    // Even more complex calculation with multiple steps
    fn complex_calculation(inputs: &[&str]) -> Result<f64, MathError> {
        if inputs.len() < 2 {
            return Err(MathError::InvalidInput(
                "Need at least 2 numbers".to_string(),
            ));
        }

        let mut result = 0.0;
        for (i, input) in inputs.iter().enumerate() {
            let num = parse_positive_float(input)?;

            if i == 0 {
                result = num;
            } else {
                result = safe_divide(result, num)?;
                result = safe_sqrt(result)?;
            }
        }

        Ok(result)
    }

    // Test the complex calculations
    let test_cases = vec![
        ("4.0", "12.0"),
        ("0", "5.0"),
        ("-1.0", "3.0"),
        ("not_a_number", "5.0"),
        ("2.0", "0"),
    ];

    for (a, b) in test_cases {
        match calculate_result(a, b) {
            Ok(result) => println!("✅ calculate_result({}, {}) = {:.2}", a, b, result),
            Err(error) => println!("❌ calculate_result({}, {}) failed: {}", a, b, error),
        }
    }

    let complex_inputs = vec![
        vec!["16.0", "2.0", "2.0"],
        vec!["100.0"],
        vec!["25.0", "0"],
        vec!["invalid", "2.0"],
    ];

    for inputs in complex_inputs {
        match complex_calculation(&inputs) {
            Ok(result) => println!("✅ complex_calculation({:?}) = {:.2}", inputs, result),
            Err(error) => println!("❌ complex_calculation({:?}) failed: {}", inputs, error),
        }
    }
}

// Function demonstrating early returns vs explicit error handling
fn early_returns_vs_explicit() {
    println!("\n=== Early Returns vs Explicit Handling ===");

    // Explicit error handling (verbose)
    fn validate_user_explicit(
        name: &str,
        age_str: &str,
        email: &str,
    ) -> Result<(String, u32, String), String> {
        // Validate name
        if name.trim().is_empty() {
            return Err("Name cannot be empty".to_string());
        }
        let clean_name = name.trim().to_string();

        // Validate age
        let age = match age_str.parse::<u32>() {
            Ok(age) => {
                if age > 150 {
                    return Err("Age cannot be greater than 150".to_string());
                }
                age
            }
            Err(_) => return Err("Age must be a valid number".to_string()),
        };

        // Validate email
        if !email.contains('@') {
            return Err("Email must contain @ symbol".to_string());
        }
        let clean_email = email.trim().to_string();

        Ok((clean_name, age, clean_email))
    }

    // Using ? operator (cleaner)
    fn validate_name(name: &str) -> Result<String, String> {
        if name.trim().is_empty() {
            Err("Name cannot be empty".to_string())
        } else {
            Ok(name.trim().to_string())
        }
    }

    fn validate_age(age_str: &str) -> Result<u32, String> {
        let age = age_str
            .parse::<u32>()
            .map_err(|_| "Age must be a valid number".to_string())?;

        if age > 150 {
            Err("Age cannot be greater than 150".to_string())
        } else {
            Ok(age)
        }
    }

    fn validate_email(email: &str) -> Result<String, String> {
        if email.contains('@') {
            Ok(email.trim().to_string())
        } else {
            Err("Email must contain @ symbol".to_string())
        }
    }

    fn validate_user_with_question_mark(
        name: &str,
        age_str: &str,
        email: &str,
    ) -> Result<(String, u32, String), String> {
        let clean_name = validate_name(name)?;
        let age = validate_age(age_str)?;
        let clean_email = validate_email(email)?;

        Ok((clean_name, age, clean_email))
    }

    // Test both approaches
    let test_users = vec![
        ("Alice", "30", "alice@example.com"),
        ("", "25", "bob@example.com"),
        ("Charlie", "not_a_number", "charlie@example.com"),
        ("Diana", "200", "diana@example.com"),
        ("Eve", "28", "invalid_email"),
    ];

    for (name, age, email) in test_users {
        println!(
            "Testing user: name='{}', age='{}', email='{}'",
            name, age, email
        );

        match validate_user_explicit(name, age, email) {
            Ok((n, a, e)) => println!("  ✅ Explicit: ({}, {}, {})", n, a, e),
            Err(error) => println!("  ❌ Explicit: {}", error),
        }

        match validate_user_with_question_mark(name, age, email) {
            Ok((n, a, e)) => println!("  ✅ With ?: ({}, {}, {})", n, a, e),
            Err(error) => println!("  ❌ With ?: {}", error),
        }
    }
}

// Function demonstrating ? operator limitations and workarounds
fn question_mark_limitations() {
    println!("\n=== ? Operator Limitations and Workarounds ===");

    // 1. Can't use ? in functions that don't return Result/Option
    fn cant_use_question_mark() {
        // This won't compile:
        // let number = "42".parse::<i32>()?;

        // Workaround: use unwrap_or, unwrap_or_default, or explicit match
        let number1 = "42".parse::<i32>().unwrap_or(0);
        let number2 = "invalid".parse::<i32>().unwrap_or_default();

        println!("Using unwrap_or: {}", number1);
        println!("Using unwrap_or_default: {}", number2);
    }

    // 2. Different error types need conversion
    fn mixed_error_types() -> Result<String, Box<dyn std::error::Error>> {
        let file_content = std::fs::read_to_string("some_file.txt")?; // io::Error
        let number: i32 = file_content.trim().parse()?; // ParseIntError
        Ok(format!("Number is: {}", number))
    }

    // 3. Converting Option to Result when needed
    fn option_to_result_conversion() -> Result<usize, &'static str> {
        let text = "Hello, World!";
        let first_char = text.chars().next().ok_or("Empty string")?; // Option to Result
        Ok(first_char.len_utf8())
    }

    // 4. Custom error conversion
    fn custom_error_conversion() -> Result<i32, String> {
        let text = "42";
        let number = text
            .parse::<i32>()
            .map_err(|e| format!("Failed to parse number: {}", e))?;
        Ok(number * 2)
    }

    cant_use_question_mark();

    match mixed_error_types() {
        Ok(result) => println!("Mixed error types result: {}", result),
        Err(error) => println!("Mixed error types failed: {}", error),
    }

    match option_to_result_conversion() {
        Ok(len) => println!("First character length: {}", len),
        Err(error) => println!("Conversion failed: {}", error),
    }

    match custom_error_conversion() {
        Ok(result) => println!("Custom conversion result: {}", result),
        Err(error) => println!("Custom conversion failed: {}", error),
    }
}

// Function demonstrating best practices for error propagation
fn error_propagation_best_practices() {
    println!("\n=== Error Propagation Best Practices ===");

    println!("🎯 Best Practices:");
    println!("1. Use ? operator for clean error propagation");
    println!("2. Implement From trait for automatic error conversion");
    println!("3. Use Result<T, E> return types for functions that can fail");
    println!("4. Provide meaningful error messages");
    println!("5. Use custom error types for domain-specific errors");
    println!("6. Don't ignore errors - handle or propagate them");
    println!("7. Use map_err for error transformation when needed");
    println!("8. Consider using thiserror or anyhow crates for complex error handling");

    // Example of good error propagation design
    #[derive(Debug)]
    enum UserRegistrationError {
        InvalidName(String),
        InvalidAge(String),
        InvalidEmail(String),
        DatabaseError(String),
    }

    impl fmt::Display for UserRegistrationError {
        fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
            match self {
                UserRegistrationError::InvalidName(msg) => write!(f, "Invalid name: {}", msg),
                UserRegistrationError::InvalidAge(msg) => write!(f, "Invalid age: {}", msg),
                UserRegistrationError::InvalidEmail(msg) => write!(f, "Invalid email: {}", msg),
                UserRegistrationError::DatabaseError(msg) => write!(f, "Database error: {}", msg),
            }
        }
    }

    fn validate_user_registration(
        name: &str,
        age_str: &str,
        email: &str,
    ) -> Result<(), UserRegistrationError> {
        // Validate name
        if name.trim().is_empty() {
            return Err(UserRegistrationError::InvalidName(
                "Name cannot be empty".to_string(),
            ));
        }

        // Validate age
        let age = age_str
            .parse::<u32>()
            .map_err(|_| UserRegistrationError::InvalidAge("Age must be a number".to_string()))?;

        if age < 13 {
            return Err(UserRegistrationError::InvalidAge(
                "Must be at least 13 years old".to_string(),
            ));
        }

        // Validate email
        if !email.contains('@') || !email.contains('.') {
            return Err(UserRegistrationError::InvalidEmail(
                "Invalid email format".to_string(),
            ));
        }

        // Simulate database save
        simulate_database_save(name, age, email)?;

        Ok(())
    }

    fn simulate_database_save(
        _name: &str,
        _age: u32,
        email: &str,
    ) -> Result<(), UserRegistrationError> {
        // Simulate database failure for specific email
        if email == "duplicate@example.com" {
            Err(UserRegistrationError::DatabaseError(
                "Email already exists".to_string(),
            ))
        } else {
            Ok(())
        }
    }

    // Test the registration system
    let test_registrations = vec![
        ("Alice", "25", "alice@example.com"),
        ("", "30", "bob@example.com"),
        ("Charlie", "12", "charlie@example.com"),
        ("Diana", "not_a_number", "diana@example.com"),
        ("Eve", "28", "invalid_email"),
        ("Frank", "35", "duplicate@example.com"),
    ];

    for (name, age, email) in test_registrations {
        match validate_user_registration(name, age, email) {
            Ok(()) => println!("✅ Registration successful for {}", name),
            Err(error) => println!("❌ Registration failed for {}: {}", name, error),
        }
    }
}

fn main() {
    println!("🦀 Error Propagation with ? Operator in Rust");
    println!("==============================================");

    basic_question_mark_examples();
    option_question_mark_examples();
    error_conversion_examples();
    complex_error_chains();
    early_returns_vs_explicit();
    question_mark_limitations();
    error_propagation_best_practices();

    println!("\n=== Summary ===");
    println!("The ? operator is Rust's tool for clean error propagation:");
    println!("✓ Automatically unwraps Ok/Some or returns Err/None");
    println!("✓ Uses From trait for automatic error type conversion");
    println!("✓ Makes error handling code much cleaner and readable");
    println!("✓ Works with both Result<T, E> and Option<T>");
    println!("✓ Enables early returns without verbose match statements");
    println!("✓ Encourages proper error handling patterns");
    println!("✓ Can only be used in functions returning Result/Option");

    println!("\n🎯 Remember:");
    println!("   ? operator = unwrap on success, early return on failure");
    println!("   Use it to make your error handling code clean and maintainable!");
}

// Key takeaways:
// 1. ? operator provides clean error propagation syntax
// 2. Automatically converts error types using From trait
// 3. Early returns on Err/None, unwraps on Ok/Some
// 4. Can only be used in functions returning Result/Option
// 5. Works with both Result<T, E> and Option<T>
// 6. Implement From trait for automatic error conversion
// 7. Use custom error types for domain-specific errors
// 8. map_err can transform errors when From trait isn't enough
// 9. Encourages proper error handling patterns
// 10. Makes code more readable and maintainable
