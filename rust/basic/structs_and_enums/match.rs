// Pattern Matching with match in Rust
// match is like a switch statement but much more powerful
// It allows you to compare a value against a series of patterns
// match is exhaustive - you must handle all possible cases
// Patterns can destructure data, bind variables, and include guards
// match expressions return values (they're expressions, not statements)

// Basic enum for demonstration
#[derive(Debug)]
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(String), // Quarter with state name
}

// More complex enum for advanced pattern matching
#[derive(Debug)]
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(u8, u8, u8),
}

// Enum for demonstrating Option<T> pattern matching
#[derive(Debug)]
enum Color {
    Red,
    Green,
    Blue,
    Rgb(u8, u8, u8),
    Hsv(u16, u8, u8),
}

// Function demonstrating basic match with enum
fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        }
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {}!", state);
            25
        }
    }
}

// Function demonstrating match with Option<T>
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

// Function demonstrating complex pattern matching
fn handle_message(msg: Message) {
    match msg {
        Message::Quit => {
            println!("The Quit variant has no data to destructure.");
        }
        Message::Move { x, y } => {
            println!("Move in the x direction {} and in the y direction {}", x, y);
        }
        Message::Write(text) => println!("Text message: {}", text),
        Message::ChangeColor(r, g, b) => {
            println!("Change the color to red {}, green {}, and blue {}", r, g, b)
        }
    }
}

// Function demonstrating color processing
fn process_color(color: Color) -> String {
    match color {
        Color::Red => "Pure red".to_string(),
        Color::Green => "Pure green".to_string(),
        Color::Blue => "Pure blue".to_string(),
        Color::Rgb(r, g, b) => format!("RGB({}, {}, {})", r, g, b),
        Color::Hsv(h, s, v) => format!("HSV({}, {}, {})", h, s, v),
    }
}

// Function demonstrating matching with guards (conditions)
fn categorize_number(x: Option<i32>) -> String {
    match x {
        Some(i) if i < 0 => "Negative number".to_string(),
        Some(i) if i == 0 => "Zero".to_string(),
        Some(i) if i > 0 && i <= 10 => "Small positive number".to_string(),
        Some(i) if i > 10 => "Large positive number".to_string(),
        None => "No number".to_string(),
        _ => "This shouldn't happen".to_string(), // Catch-all (though unreachable here)
    }
}

// Function demonstrating multiple patterns in one arm
fn describe_number(n: i32) -> &'static str {
    match n {
        1 | 2 | 3 => "Small",
        4..=10 => "Medium", // Range pattern
        11..=100 => "Large",
        _ => "Very large", // Catch-all pattern
    }
}

// Function demonstrating matching tuples
fn analyze_point(point: (i32, i32)) -> String {
    match point {
        (0, 0) => "Origin".to_string(),
        (0, y) => format!("On y-axis at y = {}", y),
        (x, 0) => format!("On x-axis at x = {}", x),
        (x, y) if x == y => format!("On diagonal at ({}, {})", x, y),
        (x, y) if x.abs() == y.abs() => format!("On anti-diagonal at ({}, {})", x, y),
        (x, y) => format!("Point at ({}, {})", x, y),
    }
}

// Struct for demonstrating destructuring
#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

// Function demonstrating struct destructuring
fn analyze_struct_point(point: Point) -> String {
    match point {
        Point { x: 0, y: 0 } => "Origin".to_string(),
        Point { x: 0, y } => format!("On y-axis at y = {}", y),
        Point { x, y: 0 } => format!("On x-axis at x = {}", x),
        Point { x, y } if x == y => format!("On diagonal at ({}, {})", x, y),
        Point { x, y } => format!("Point at ({}, {})", x, y),
    }
}

// Function demonstrating Result<T, E> pattern matching
fn handle_division(result: Result<f64, &str>) -> String {
    match result {
        Ok(value) if value == 0.0 => "Result is zero".to_string(),
        Ok(value) if value > 0.0 => format!("Positive result: {:.2}", value),
        Ok(value) => format!("Negative result: {:.2}", value),
        Err(error) => format!("Error: {}", error),
    }
}

// Function demonstrating nested pattern matching
fn process_nested_option(opt: Option<Option<i32>>) -> String {
    match opt {
        Some(Some(n)) => format!("Found nested number: {}", n),
        Some(None) => "Found outer Some with inner None".to_string(),
        None => "Found None".to_string(),
    }
}

// Function demonstrating ignoring parts of values
fn first_and_last(numbers: &[i32]) -> String {
    match numbers {
        [] => "Empty slice".to_string(),
        [single] => format!("Single element: {}", single),
        [first, .., last] => format!("First: {}, Last: {}", first, last),
    }
}

// Function demonstrating @ binding (capturing matched value)
fn analyze_id(id: Option<i32>) -> String {
    match id {
        Some(id_value @ 1..=10) => format!("Small ID: {}", id_value),
        Some(id_value @ 11..=100) => format!("Medium ID: {}", id_value),
        Some(id_value) => format!("Large ID: {}", id_value),
        None => "No ID".to_string(),
    }
}

fn main() {
    println!("=== Basic Match with Enums ===");

    // Basic enum matching
    let coins = vec![
        Coin::Penny,
        Coin::Nickel,
        Coin::Dime,
        Coin::Quarter("Alaska".to_string()),
    ];

    for coin in coins {
        let value = value_in_cents(coin);
        println!("Coin value: {} cents", value);
    }

    println!("\n=== Matching Option<T> ===");

    // Option<T> matching
    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);

    println!("Five plus one: {:?}", six); // Some(6)
    println!("None plus one: {:?}", none); // None

    // More Option examples with pattern matching
    let numbers = vec![Some(1), None, Some(3), Some(42)];
    for number in numbers {
        match number {
            Some(n) if n < 10 => println!("Small number: {}", n),
            Some(n) => println!("Large number: {}", n),
            None => println!("No number"),
        }
    }

    println!("\n=== Complex Pattern Matching ===");

    // Complex message handling
    let messages = vec![
        Message::Quit,
        Message::Move { x: 10, y: 20 },
        Message::Write("Hello, Rust!".to_string()),
        Message::ChangeColor(255, 0, 128),
    ];

    for msg in messages {
        handle_message(msg);
    }

    println!("\n=== Color Processing ===");

    // Color pattern matching
    let colors = vec![
        Color::Red,
        Color::Rgb(255, 128, 0),
        Color::Hsv(240, 100, 50),
        Color::Blue,
    ];

    for color in colors {
        println!("Color: {}", process_color(color));
    }

    println!("\n=== Match Guards (Conditions) ===");

    // Match guards with conditions
    let test_numbers = vec![Some(-5), Some(0), Some(7), Some(42), None];
    for num in test_numbers {
        println!("Number category: {}", categorize_number(num));
    }

    println!("\n=== Multiple Patterns and Ranges ===");

    // Multiple patterns and ranges
    let test_values = vec![1, 5, 15, 150];
    for value in test_values {
        println!("Number {} is {}", value, describe_number(value));
    }

    println!("\n=== Tuple Pattern Matching ===");

    // Tuple pattern matching
    let points = vec![(0, 0), (0, 5), (3, 0), (4, 4), (3, -3), (7, 2)];
    for point in points {
        println!("Point analysis: {}", analyze_point(point));
    }

    println!("\n=== Struct Destructuring ===");

    // Struct destructuring
    let struct_points = vec![
        Point { x: 0, y: 0 },
        Point { x: 0, y: 10 },
        Point { x: 5, y: 0 },
        Point { x: 3, y: 3 },
        Point { x: 8, y: 2 },
    ];

    for point in struct_points {
        println!("Struct point analysis: {}", analyze_struct_point(point));
    }

    println!("\n=== Result<T, E> Pattern Matching ===");

    // Result pattern matching
    let division_results = vec![Ok(10.5), Ok(0.0), Ok(-3.7), Err("Division by zero")];

    for result in division_results {
        println!("Division result: {}", handle_division(result));
    }

    println!("\n=== Nested Pattern Matching ===");

    // Nested Option matching
    let nested_options = vec![Some(Some(42)), Some(None), None];

    for opt in nested_options {
        println!("Nested option: {}", process_nested_option(opt));
    }

    println!("\n=== Slice Pattern Matching ===");

    // Slice pattern matching
    let test_slices = vec![vec![], vec![1], vec![1, 2], vec![1, 2, 3, 4, 5]];

    for slice in &test_slices {
        println!("Slice analysis: {}", first_and_last(slice));
    }

    println!("\n=== @ Binding (Capturing Values) ===");

    // @ binding examples
    let test_ids = vec![Some(5), Some(50), Some(500), None];
    for id in test_ids {
        println!("ID analysis: {}", analyze_id(id));
    }

    println!("\n=== match vs if let ===");

    // Demonstrating when to use match vs if let
    let config_max = Some(3u8);

    // Using match (verbose for single pattern)
    match config_max {
        Some(max) => println!("The maximum is configured to be {}", max),
        _ => (),
    }

    // Using if let (more concise for single pattern)
    if let Some(max) = config_max {
        println!("The maximum is configured to be {} (using if let)", max);
    }

    // if let with else
    if let Some(max) = config_max {
        println!("Maximum: {}", max);
    } else {
        println!("No maximum configured");
    }

    println!("\n=== Matching References ===");

    // Matching references
    let x = &4;
    match x {
        &val => println!("Got a value via destructuring: {}", val),
    }

    // Alternative - matching reference directly
    match x {
        val => println!("Got a reference: {}", val),
    }

    // Matching reference in complex pattern
    let points_ref = &(3, 5);
    match points_ref {
        &(x, y) => println!("Destructured reference: ({}, {})", x, y),
    }
}

// Key takeaways:
// 1. match is exhaustive - must handle all cases
// 2. match expressions return values
// 3. Use guards (if conditions) for complex matching
// 4. Patterns can destructure structs, enums, tuples
// 5. Use _ as catch-all pattern
// 6. Use | for multiple patterns in one arm
// 7. Use .. to ignore parts of patterns
// 8. Use @ to bind matched values to variables
// 9. Range patterns: 1..=5 (inclusive), 1..5 (exclusive)
// 10. if let is more concise for single pattern matching
