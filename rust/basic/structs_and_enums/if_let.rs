// if let - Concise Control Flow with Pattern Matching
// if let is syntactic sugar that makes code more readable when you only care about one pattern
// It's less verbose than match when you only want to handle one specific case
// Combines if and let into a single construct for pattern matching
// Can be used with else for handling the "other" cases
// Particularly useful with Option<T>, Result<T,E>, and enum variants
// Does not check for exhaustiveness like match does

// Basic enums for demonstration
#[derive(Debug)]
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(String), // Quarter with state name
}

#[derive(Debug)]
enum IpAddress {
    V4(u8, u8, u8, u8),
    V6(String),
}

#[derive(Debug)]
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(u8, u8, u8),
}

#[derive(Debug)]
enum UserRole {
    Admin { permissions: Vec<String> },
    Moderator { level: u8 },
    User,
    Guest,
}

// Struct for configuration
#[derive(Debug)]
struct Config {
    max_connections: Option<u32>,
    timeout: Option<u32>,
    debug_mode: Option<bool>,
}

// Function demonstrating basic if let with Option<T>
fn process_optional_number(num: Option<i32>) {
    // Using match - verbose for single pattern
    match num {
        Some(value) => println!("Match: Found number {}", value),
        _ => (), // We ignore None case
    }

    // Using if let - much more concise
    if let Some(value) = num {
        println!("if let: Found number {}", value);
    }
    // No need for else if we don't care about None
}

// Function demonstrating if let with else
fn check_configuration(config: &Config) {
    // Check max connections
    if let Some(max) = config.max_connections {
        println!("Max connections configured: {}", max);
    } else {
        println!("No connection limit set");
    }

    // Check debug mode with different handling
    if let Some(debug) = config.debug_mode {
        if debug {
            println!("Debug mode is ON");
        } else {
            println!("Debug mode is OFF");
        }
    } else {
        println!("Debug mode not configured");
    }
}

// Function demonstrating if let with enum variants
fn handle_message_concise(msg: Message) {
    // Only handle Move messages, ignore others
    if let Message::Move { x, y } = msg {
        println!("Moving to coordinates ({}, {})", x, y);
    } else {
        println!("Not a move message, ignoring");
    }
}

// Function demonstrating if let with complex enum
fn check_quarter_state(coin: Coin) {
    // Only interested in quarters from specific states
    if let Coin::Quarter(state) = coin {
        if state == "Alaska" || state == "Hawaii" {
            println!("Special quarter from {}!", state);
        } else {
            println!("Regular quarter from {}", state);
        }
    } else {
        println!("Not a quarter");
    }
}

// Function demonstrating nested if let
fn process_nested_option(opt: Option<Option<String>>) {
    if let Some(inner_opt) = opt {
        if let Some(value) = inner_opt {
            println!("Found nested value: {}", value);
        } else {
            println!("Outer Some, but inner None");
        }
    } else {
        println!("Outer None");
    }
}

// Function demonstrating if let with Result<T, E>
fn handle_division_result(result: Result<f64, &str>) {
    if let Ok(value) = result {
        println!("Division successful: {:.2}", value);
    } else if let Err(error) = result {
        println!("Division failed: {}", error);
    }
}

// Function demonstrating if let with guards (conditions)
fn check_admin_permissions(role: UserRole) {
    if let UserRole::Admin { permissions } = role {
        if permissions.contains(&"delete_users".to_string()) {
            println!("Admin has delete permissions");
        } else {
            println!("Admin lacks delete permissions");
        }
    } else {
        println!("Not an admin user");
    }
}

// Function demonstrating if let with ranges
fn categorize_number(num: Option<i32>) {
    if let Some(n @ 1..=10) = num {
        println!("Small number in range: {}", n);
    } else if let Some(n @ 11..=100) = num {
        println!("Medium number in range: {}", n);
    } else if let Some(n) = num {
        println!("Large number: {}", n);
    } else {
        println!("No number provided");
    }
}

// Function demonstrating while let (bonus - similar concept)
fn process_vector_until_none(mut vec: Vec<Option<i32>>) {
    println!("Processing vector with while let:");
    while let Some(item) = vec.pop() {
        if let Some(value) = item {
            println!("  Processing value: {}", value);
        } else {
            println!("  Found None, continuing");
        }
    }
    println!("Vector is now empty");
}

// Function demonstrating let else (newer Rust feature)
fn extract_ipv4(addr: IpAddress) -> Option<(u8, u8, u8, u8)> {
    // Using if let for IPv4 extraction
    if let IpAddress::V4(a, b, c, d) = addr {
        Some((a, b, c, d))
    } else {
        None
    }
}

// Function showing when match is better than if let
fn handle_all_coins(coin: Coin) -> u8 {
    // When you need to handle multiple patterns, match is better
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(_) => 25, // Don't care about the state here
    }
    // if let would require multiple if let statements and wouldn't ensure exhaustiveness
}

fn main() {
    println!("=== Basic if let with Option<T> ===");

    // Basic Option handling
    let some_number = Some(42);
    let no_number: Option<i32> = None;

    process_optional_number(some_number); // Will print both match and if let
    process_optional_number(no_number); // Will only print match

    println!("\n=== if let with else ===");

    // Configuration examples
    let config1 = Config {
        max_connections: Some(100),
        timeout: None,
        debug_mode: Some(true),
    };

    let config2 = Config {
        max_connections: None,
        timeout: Some(30),
        debug_mode: None,
    };

    println!("Config 1:");
    check_configuration(&config1);
    println!("Config 2:");
    check_configuration(&config2);

    println!("\n=== if let with Enum Variants ===");

    // Message handling
    let messages = vec![
        Message::Move { x: 10, y: 20 },
        Message::Write("Hello".to_string()),
        Message::Quit,
        Message::ChangeColor(255, 0, 0),
    ];

    for msg in messages {
        handle_message_concise(msg);
    }

    println!("\n=== if let with Complex Enums ===");

    // Coin handling
    let coins = vec![
        Coin::Quarter("Alaska".to_string()),
        Coin::Quarter("Texas".to_string()),
        Coin::Penny,
        Coin::Quarter("Hawaii".to_string()),
    ];

    for coin in coins {
        check_quarter_state(coin);
    }

    println!("\n=== Nested if let ===");

    // Nested Option handling
    let nested_options = vec![Some(Some("Found it!".to_string())), Some(None), None];

    for opt in nested_options {
        process_nested_option(opt);
    }

    println!("\n=== if let with Result<T, E> ===");

    // Result handling
    let results = vec![
        Ok(42.5),
        Err("Division by zero"),
        Ok(-17.3),
        Err("Invalid input"),
    ];

    for result in results {
        handle_division_result(result);
    }

    println!("\n=== if let with Complex Patterns ===");

    // User role handling
    let roles = vec![
        UserRole::Admin {
            permissions: vec![
                "read".to_string(),
                "write".to_string(),
                "delete_users".to_string(),
            ],
        },
        UserRole::Admin {
            permissions: vec!["read".to_string(), "write".to_string()],
        },
        UserRole::Moderator { level: 3 },
        UserRole::User,
    ];

    for role in roles {
        check_admin_permissions(role);
    }

    println!("\n=== if let with Ranges and @ Binding ===");

    // Number categorization
    let numbers = vec![Some(5), Some(50), Some(500), None];
    for num in numbers {
        categorize_number(num);
    }

    println!("\n=== while let Example ===");

    // while let demonstration
    let test_vec = vec![Some(1), None, Some(3), Some(4), None];
    process_vector_until_none(test_vec);

    println!("\n=== IPv4 Extraction ===");

    // IP address handling
    let addresses = vec![
        IpAddress::V4(192, 168, 1, 1),
        IpAddress::V6("::1".to_string()),
        IpAddress::V4(10, 0, 0, 1),
    ];

    for addr in addresses {
        if let Some((a, b, c, d)) = extract_ipv4(addr) {
            println!("IPv4 address: {}.{}.{}.{}", a, b, c, d);
        } else {
            println!("Not an IPv4 address");
        }
    }

    println!("\n=== When to Use match vs if let ===");

    let coin = Coin::Quarter("California".to_string());

    // Use if let when you only care about one pattern
    if let Coin::Quarter(state) = &coin {
        println!("if let: Found quarter from {}", state);
    }

    // Use match when you need to handle multiple patterns or want exhaustiveness
    let value = handle_all_coins(coin);
    println!("match: Coin value is {} cents", value);

    println!("\n=== Chaining if let Statements ===");

    // Multiple if let statements for different cases
    let data: Result<Option<i32>, &str> = Ok(Some(42));

    if let Ok(option_val) = data {
        if let Some(number) = option_val {
            println!("Successfully extracted number: {}", number);
        } else {
            println!("Got Ok but no value inside");
        }
    } else {
        println!("Got an error");
    }

    println!("\n=== Comparing Verbosity ===");

    let maybe_number = Some(7);

    // Verbose match version
    match maybe_number {
        Some(n) if n < 10 => println!("Match: Small number {}", n),
        _ => {}
    }

    // Concise if let version
    if let Some(n) = maybe_number {
        if n < 10 {
            println!("if let: Small number {}", n);
        }
    }

    // Alternative if let with guard-like behavior
    if let Some(n @ 1..=9) = maybe_number {
        println!("if let with range: Small number {}", n);
    }
}

// Key takeaways:
// 1. if let is syntactic sugar for match when you only care about one pattern
// 2. More concise than match for single pattern matching
// 3. Can be combined with else for binary logic
// 4. Particularly useful with Option<T> and Result<T, E>
// 5. Can be nested for complex pattern matching
// 6. while let exists for loops with pattern matching
// 7. Use match when you need exhaustiveness checking
// 8. Use if let when you only care about specific variants
// 9. Can use @ binding and ranges just like match
// 10. Great for early returns and optional value processing
