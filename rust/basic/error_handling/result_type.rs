// Result<T, E> - Rust's Solution to Error Handling
// Result<T, E> is an enum that represents either Ok(T) or Err(E)
// It's Rust's way of handling operations that can fail
// Forces you to handle errors explicitly at compile time
// Result<T, E> is defined as: enum Result<T, E> { Ok(T), Err(E) }
// It's in the prelude, so you don't need to import it
// Many methods are available to work with Result values conveniently

use std::collections::HashMap;
use std::fs::File;
use std::io::{self, Read};
use std::num::ParseIntError;

// Custom error types for demonstration
#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeSquareRoot,
    Overflow,
}

#[derive(Debug)]
enum DatabaseError {
    ConnectionFailed,
    QueryFailed(String),
    NotFound,
    PermissionDenied,
}

#[derive(Debug, Clone)]
struct User {
    id: u32,
    name: String,
    email: String,
    age: u8,
}

// Function demonstrating basic Result creation and usage
fn basic_result_examples() {
    println!("=== Basic Result Examples ===");

    // Creating Ok and Err values
    let success: Result<i32, &str> = Ok(42);
    let failure: Result<i32, &str> = Err("Something went wrong");

    println!("Success: {:?}", success); // Ok(42)
    println!("Failure: {:?}", failure); // Err("Something went wrong")

    // Type annotation is often needed for the error type
    let empty_result: Result<String, io::Error> = Ok("Hello".to_string());
    println!("Empty result: {:?}", empty_result); // Ok("Hello")
}

// Function demonstrating pattern matching with Result
fn pattern_matching_examples() {
    println!("\n=== Pattern Matching with Result ===");

    let results = vec![Ok(10), Err("Invalid input"), Ok(20), Err("Network error")];

    for result in results {
        match result {
            Ok(value) if value > 15 => println!("Large success value: {}", value),
            Ok(value) => println!("Small success value: {}", value),
            Err(error) => println!("Error occurred: {}", error),
        }
    }
}

// Function demonstrating Result methods
fn result_methods_examples() {
    println!("\n=== Result Methods ===");

    let success: Result<i32, &str> = Ok(42);
    let failure: Result<i32, &str> = Err("error");

    // is_ok() and is_err()
    println!("success.is_ok(): {}", success.is_ok()); // true
    println!("success.is_err(): {}", success.is_err()); // false
    println!("failure.is_ok(): {}", failure.is_ok()); // false
    println!("failure.is_err(): {}", failure.is_err()); // true

    // unwrap() - use with caution! Panics on Err
    println!("success.unwrap(): {}", success.unwrap()); // 42
                                                        // println!("failure.unwrap(): {}", failure.unwrap());  // This would panic!

    // unwrap_or() - provides a default value on error
    println!("success.unwrap_or(0): {}", success.unwrap_or(0)); // 42
    println!("failure.unwrap_or(0): {}", failure.unwrap_or(0)); // 0

    // unwrap_or_else() - provides a default via closure
    println!(
        "failure.unwrap_or_else(|_| -1): {}",
        failure.unwrap_or_else(|_| -1)
    ); // -1

    // expect() - like unwrap but with custom panic message
    println!(
        "success.expect('Should have value'): {}",
        success.expect("Should have value")
    ); // 42
       // failure.expect("Should have value");  // Would panic with custom message

    // unwrap_err() - gets the error value (panics on Ok)
    println!("failure.unwrap_err(): {}", failure.unwrap_err()); // "error"
}

// Function demonstrating Result transformations
fn result_transformations() {
    println!("\n=== Result Transformations ===");

    let number: Result<i32, &str> = Ok(42);
    let error_result: Result<i32, &str> = Err("error");

    // map() - transforms the Ok value, leaves Err unchanged
    let doubled = number.map(|n| n * 2);
    let doubled_err = error_result.map(|n| n * 2);
    println!("number.map(|n| n * 2): {:?}", doubled); // Ok(84)
    println!("error_result.map(|n| n * 2): {:?}", doubled_err); // Err("error")

    // map_err() - transforms the Err value, leaves Ok unchanged
    let mapped_err = error_result.map_err(|e| format!("Error: {}", e));
    println!("error_result.map_err(): {:?}", mapped_err); // Err("Error: error")

    // map_or() - map with default value on error
    let result1 = number.map_or(0, |n| n * 2);
    let result2 = error_result.map_or(0, |n| n * 2);
    println!("number.map_or(0, |n| n * 2): {}", result1); // 84
    println!("error_result.map_or(0, |n| n * 2): {}", result2); // 0

    // and_then() - chains Result operations (flatMap in other languages)
    let divide_by_two = |n| {
        if n % 2 == 0 {
            Ok(n / 2)
        } else {
            Err("odd number")
        }
    };
    let chained = number.and_then(divide_by_two);
    println!("number.and_then(divide_by_two): {:?}", chained); // Ok(21)

    let odd_number = Ok(43);
    let chained_odd = odd_number.and_then(divide_by_two);
    println!("odd_number.and_then(divide_by_two): {:?}", chained_odd); // Err("odd number")
}

// Function demonstrating custom error types
fn custom_error_examples() {
    println!("\n=== Custom Error Types ===");

    // Safe division function
    fn safe_divide(a: f64, b: f64) -> Result<f64, MathError> {
        if b == 0.0 {
            Err(MathError::DivisionByZero)
        } else {
            Ok(a / b)
        }
    }

    // Safe square root function
    fn safe_sqrt(x: f64) -> Result<f64, MathError> {
        if x < 0.0 {
            Err(MathError::NegativeSquareRoot)
        } else {
            Ok(x.sqrt())
        }
    }

    // Testing safe division
    match safe_divide(10.0, 2.0) {
        Ok(result) => println!("10.0 / 2.0 = {}", result),
        Err(error) => println!("Division error: {:?}", error),
    }

    match safe_divide(10.0, 0.0) {
        Ok(result) => println!("10.0 / 0.0 = {}", result),
        Err(error) => println!("Division error: {:?}", error),
    }

    // Testing safe square root
    match safe_sqrt(16.0) {
        Ok(result) => println!("sqrt(16.0) = {}", result),
        Err(error) => println!("Square root error: {:?}", error),
    }

    match safe_sqrt(-4.0) {
        Ok(result) => println!("sqrt(-4.0) = {}", result),
        Err(error) => println!("Square root error: {:?}", error),
    }
}

// Function demonstrating Result with string parsing
fn parsing_examples() {
    println!("\n=== Parsing Examples ===");

    let valid_number = "42";
    let invalid_number = "not_a_number";

    // parse() returns Result<T, ParseError>
    match valid_number.parse::<i32>() {
        Ok(num) => println!("Parsed '{}' as: {}", valid_number, num),
        Err(error) => println!("Failed to parse '{}': {}", valid_number, error),
    }

    match invalid_number.parse::<i32>() {
        Ok(num) => println!("Parsed '{}' as: {}", invalid_number, num),
        Err(error) => println!("Failed to parse '{}': {}", invalid_number, error),
    }

    // Parsing multiple values
    let numbers = vec!["1", "2", "not_a_number", "4"];
    let parsed: Vec<Result<i32, ParseIntError>> =
        numbers.iter().map(|s| s.parse::<i32>()).collect();

    println!("Parsed results: {:?}", parsed);

    // Collecting only successful parses
    let valid_numbers: Vec<i32> = numbers.iter().filter_map(|s| s.parse().ok()).collect();
    println!("Valid numbers only: {:?}", valid_numbers);
}

// Function demonstrating Result with file operations
fn file_operations_examples() {
    println!("\n=== File Operations Examples ===");

    // This will likely fail unless the file exists
    fn read_file_contents(filename: &str) -> Result<String, io::Error> {
        let mut file = File::open(filename)?; // ? operator for early return
        let mut contents = String::new();
        file.read_to_string(&mut contents)?;
        Ok(contents)
    }

    // Try to read a file that probably doesn't exist
    match read_file_contents("nonexistent.txt") {
        Ok(contents) => println!("File contents: {}", contents),
        Err(error) => println!("Failed to read file: {}", error),
    }

    // Try to read a file that might exist (this one)
    match read_file_contents("result_type.rs") {
        Ok(contents) => println!("File length: {} characters", contents.len()),
        Err(error) => println!("Failed to read result_type.rs: {}", error),
    }
}

// Function demonstrating Result combinators
fn result_combinators() {
    println!("\n=== Result Combinators ===");

    let x: Result<i32, &str> = Ok(2);
    let y: Result<i32, &str> = Ok(3);
    let z: Result<i32, &str> = Err("error");

    // and() - returns Err if either is Err, otherwise returns the second Result
    println!("x.and(y): {:?}", x.and(y)); // Ok(3)
    println!("x.and(z): {:?}", x.and(z)); // Err("error")
    println!("z.and(y): {:?}", z.and(y)); // Err("error")

    // or() - returns the first Ok, or the second Err if both are Err
    println!("x.or(y): {:?}", x.or(y)); // Ok(2)
    println!("x.or(z): {:?}", x.or(z)); // Ok(2)
    println!("z.or(y): {:?}", z.or(y)); // Ok(3)

    let z2: Result<i32, &str> = Err("second error");
    println!("z.or(z2): {:?}", z.or(z2)); // Err("second error")
}

// Function demonstrating Result error propagation
fn error_propagation_examples() {
    println!("\n=== Error Propagation Examples ===");

    // Function that can fail at multiple points
    fn process_user_input(input: &str) -> Result<u32, String> {
        let trimmed = input.trim();

        if trimmed.is_empty() {
            return Err("Input is empty".to_string());
        }

        let number = trimmed
            .parse::<u32>()
            .map_err(|_| "Failed to parse number".to_string())?;

        if number == 0 {
            return Err("Number cannot be zero".to_string());
        }

        if number > 100 {
            return Err("Number too large (max 100)".to_string());
        }

        Ok(number * 2) // Double the valid number
    }

    let test_inputs = vec!["42", "0", "150", "not_a_number", "  ", "25"];

    for input in test_inputs {
        match process_user_input(input) {
            Ok(result) => println!("Input '{}' -> Result: {}", input, result),
            Err(error) => println!("Input '{}' -> Error: {}", input, error),
        }
    }
}

// Function demonstrating Result with custom database-like operations
fn database_operations_examples() {
    println!("\n=== Database-like Operations ===");

    // Simulate a simple in-memory database
    struct Database {
        users: HashMap<u32, User>,
    }

    impl Database {
        fn new() -> Self {
            let mut users = HashMap::new();
            users.insert(
                1,
                User {
                    id: 1,
                    name: "Alice".to_string(),
                    email: "alice@example.com".to_string(),
                    age: 30,
                },
            );
            users.insert(
                2,
                User {
                    id: 2,
                    name: "Bob".to_string(),
                    email: "bob@example.com".to_string(),
                    age: 25,
                },
            );

            Database { users }
        }

        fn get_user(&self, id: u32) -> Result<&User, DatabaseError> {
            self.users.get(&id).ok_or(DatabaseError::NotFound)
        }

        fn update_user_age(&mut self, id: u32, new_age: u8) -> Result<(), DatabaseError> {
            if new_age > 120 {
                return Err(DatabaseError::QueryFailed("Invalid age".to_string()));
            }

            match self.users.get_mut(&id) {
                Some(user) => {
                    user.age = new_age;
                    Ok(())
                }
                None => Err(DatabaseError::NotFound),
            }
        }

        fn delete_user(&mut self, id: u32) -> Result<User, DatabaseError> {
            self.users.remove(&id).ok_or(DatabaseError::NotFound)
        }
    }

    let mut db = Database::new();

    // Get existing user
    match db.get_user(1) {
        Ok(user) => println!("Found user: {:?}", user),
        Err(error) => println!("Database error: {:?}", error),
    }

    // Get non-existent user
    match db.get_user(999) {
        Ok(user) => println!("Found user: {:?}", user),
        Err(error) => println!("Database error: {:?}", error),
    }

    // Update user age
    match db.update_user_age(1, 31) {
        Ok(()) => println!("User age updated successfully"),
        Err(error) => println!("Update failed: {:?}", error),
    }

    // Try invalid age
    match db.update_user_age(1, 150) {
        Ok(()) => println!("User age updated successfully"),
        Err(error) => println!("Update failed: {:?}", error),
    }

    // Delete user
    match db.delete_user(2) {
        Ok(deleted_user) => println!("Deleted user: {:?}", deleted_user),
        Err(error) => println!("Delete failed: {:?}", error),
    }
}

// Function demonstrating Result best practices
fn result_best_practices() {
    println!("\n=== Result Best Practices ===");

    // DON'T: Use unwrap() in production code
    let risky_result: Result<i32, &str> = Ok(42);
    // let value = risky_result.unwrap();  // Dangerous!

    // DO: Use safer alternatives
    let safe_value = risky_result.unwrap_or(-1);
    println!("Safe unwrap with default: {}", safe_value);

    // DON'T: Ignore errors
    // let _ = some_operation_that_can_fail();

    // DO: Handle errors explicitly
    fn some_operation() -> Result<i32, &'static str> {
        Ok(42)
    }

    match some_operation() {
        Ok(value) => println!("Operation succeeded: {}", value),
        Err(error) => println!("Operation failed: {}", error),
    }

    // DO: Use ? operator for error propagation
    fn chain_operations() -> Result<i32, &'static str> {
        let value1 = some_operation()?;
        let value2 = Ok(value1 * 2)?;
        Ok(value2 + 10)
    }

    println!("Chained operations result: {:?}", chain_operations());

    // DO: Convert between Option and Result when needed
    let option_value: Option<i32> = Some(42);
    let result_value: Result<i32, &str> = option_value.ok_or("No value");
    println!("Option to Result: {:?}", result_value);

    let result_to_option: Option<i32> = result_value.ok();
    println!("Result to Option: {:?}", result_to_option);
}

// Function demonstrating collecting Results
fn collecting_results() {
    println!("\n=== Collecting Results ===");

    let numbers = vec!["1", "2", "3", "4"];
    let invalid_numbers = vec!["1", "not_a_number", "3"];

    // collect() on Results - fails if any parsing fails
    let all_parsed: Result<Vec<i32>, _> = numbers.iter().map(|s| s.parse::<i32>()).collect();
    println!("All valid numbers: {:?}", all_parsed); // Ok([1, 2, 3, 4])

    let some_invalid: Result<Vec<i32>, _> =
        invalid_numbers.iter().map(|s| s.parse::<i32>()).collect();
    println!("Some invalid numbers: {:?}", some_invalid); // Err(...)

    // Partition results into successes and failures
    let (successes, failures): (Vec<_>, Vec<_>) = invalid_numbers
        .iter()
        .map(|s| s.parse::<i32>())
        .partition(Result::is_ok);

    let success_values: Vec<i32> = successes.into_iter().map(Result::unwrap).collect();
    let error_values: Vec<_> = failures.into_iter().map(Result::unwrap_err).collect();

    println!("Successes: {:?}", success_values);
    println!("Errors: {:?}", error_values);
}

fn main() {
    basic_result_examples();
    pattern_matching_examples();
    result_methods_examples();
    result_transformations();
    custom_error_examples();
    parsing_examples();
    file_operations_examples();
    result_combinators();
    error_propagation_examples();
    database_operations_examples();
    result_best_practices();
    collecting_results();

    println!("\n=== Summary ===");
    println!("Result<T, E> is Rust's way of handling operations that can fail:");
    println!("- Ok(value) represents success");
    println!("- Err(error) represents failure");
    println!("- Compiler forces you to handle both cases");
    println!("- ? operator provides convenient error propagation");
    println!("- Rich set of methods for transformation and combination");
    println!("- No exceptions - all errors are explicit!");
}

// Key takeaways:
// 1. Result<T, E> makes error handling explicit and safe
// 2. Use Ok(value) for success, Err(error) for failure
// 3. Pattern matching is the primary way to handle Results
// 4. Many convenient methods: map, unwrap_or, and_then, etc.
// 5. ? operator provides clean error propagation
// 6. Custom error types make errors more descriptive
// 7. Avoid unwrap() in production code - use safer alternatives
// 8. Result composes well with other Result values
// 9. Can convert between Option and Result types
// 10. collect() on iterators of Results follows "fail fast" semantics
