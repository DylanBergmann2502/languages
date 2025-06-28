// Enums in Rust - Defining types with multiple possible values
// Enums allow you to define a type by enumerating its possible variants
// Each variant can hold different types and amounts of data
// Enums are more powerful than in many other languages - they can hold data!
// The Option<T> and Result<T, E> types are actually enums
// Pattern matching with match is the primary way to work with enums

// Simple enum with no data
#[derive(Debug)]
enum IpAddrKind {
    V4,
    V6,
}

// Enum variants can hold data - each variant can have different types
#[derive(Debug)]
enum IpAddr {
    V4(u8, u8, u8, u8), // Tuple-like variant
    V6(String),         // Single value variant
}

// Enum with various data types
#[derive(Debug)]
enum Message {
    Quit,                       // No data
    Move { x: i32, y: i32 },    // Anonymous struct
    Write(String),              // Single string
    ChangeColor(i32, i32, i32), // Three integers
}

// Implementing methods on enums
impl Message {
    fn call(&self) {
        match self {
            Message::Quit => println!("Quit message received"),
            Message::Move { x, y } => println!("Move to coordinates ({}, {})", x, y),
            Message::Write(text) => println!("Text message: {}", text),
            Message::ChangeColor(r, g, b) => println!("Change color to RGB({}, {}, {})", r, g, b),
        }
    }

    // Associated function for enum
    fn new_quit() -> Message {
        Message::Quit
    }
}

// More complex enum - representing different types of web events
#[derive(Debug)]
enum WebEvent {
    PageLoad,
    PageUnload,
    KeyPress(char),
    Paste(String),
    Click { x: i64, y: i64 },
}

// Function that handles web events
fn handle_web_event(event: WebEvent) {
    match event {
        WebEvent::PageLoad => println!("Page loaded"),
        WebEvent::PageUnload => println!("Page unloaded"),
        WebEvent::KeyPress(c) => println!("Key '{}' was pressed", c),
        WebEvent::Paste(s) => println!("Text '{}' was pasted", s),
        WebEvent::Click { x, y } => println!("Clicked at coordinates ({}, {})", x, y),
    }
}

// Enum representing different coin types
#[derive(Debug)]
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState), // Quarter can have a state
}

// Enum for US states (subset for demo)
#[derive(Debug)]
enum UsState {
    Alabama,
    Alaska,
    California,
    Florida,
    // ... other states
}

// Function that returns value of coins in cents
fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        }
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {:?}!", state);
            25
        }
    }
}

// Working with Option<T> - Rust's built-in enum for nullable values
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

// Function demonstrating Option<T> usage
fn find_first_char(s: &str) -> Option<char> {
    if s.is_empty() {
        None
    } else {
        Some(s.chars().next().unwrap())
    }
}

// Enum for representing results of operations that can fail
#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeLogarithm,
    InvalidInput,
}

// Function that returns Result<T, E>
fn safe_divide(dividend: f64, divisor: f64) -> Result<f64, MathError> {
    if divisor == 0.0 {
        Err(MathError::DivisionByZero)
    } else {
        Ok(dividend / divisor)
    }
}

// Enum representing different types of employees
#[derive(Debug)]
enum Employee {
    FullTime {
        name: String,
        salary: u32,
    },
    PartTime {
        name: String,
        hourly_rate: u16,
    },
    Contractor {
        name: String,
        contract_value: u32,
        duration_months: u8,
    },
}

impl Employee {
    // Method to get employee name regardless of type
    fn name(&self) -> &str {
        match self {
            Employee::FullTime { name, .. } => name,
            Employee::PartTime { name, .. } => name,
            Employee::Contractor { name, .. } => name,
        }
    }

    // Method to calculate monthly pay
    fn monthly_pay(&self) -> u32 {
        match self {
            Employee::FullTime { salary, .. } => salary / 12,
            Employee::PartTime { hourly_rate, .. } => (*hourly_rate as u32) * 160, // Assuming 160 hours/month
            Employee::Contractor {
                contract_value,
                duration_months,
                ..
            } => contract_value / (*duration_months as u32),
        }
    }
}

// Enum with generic types
#[derive(Debug)]
enum Container<T> {
    Empty,
    Single(T),
    Multiple(Vec<T>),
}

impl<T> Container<T> {
    fn is_empty(&self) -> bool {
        matches!(self, Container::Empty)
    }

    fn count(&self) -> usize {
        match self {
            Container::Empty => 0,
            Container::Single(_) => 1,
            Container::Multiple(vec) => vec.len(),
        }
    }
}

fn main() {
    println!("=== Basic Enums ===");

    // Creating enum instances
    let four = IpAddrKind::V4;
    let six = IpAddrKind::V6;
    println!("IP kind 1: {:?}", four); // V4
    println!("IP kind 2: {:?}", six); // V6

    // Enums with data
    let home = IpAddr::V4(127, 0, 0, 1);
    let loopback = IpAddr::V6(String::from("::1"));
    println!("Home IP: {:?}", home); // V4(127, 0, 0, 1)
    println!("Loopback IP: {:?}", loopback); // V6("::1")

    println!("\n=== Message Enum with Methods ===");

    // Creating different message types
    let msg1 = Message::Quit;
    let msg2 = Message::Move { x: 10, y: 20 };
    let msg3 = Message::Write(String::from("Hello, World!"));
    let msg4 = Message::ChangeColor(255, 0, 128);

    // Calling methods on enum instances
    msg1.call(); // Quit message received
    msg2.call(); // Move to coordinates (10, 20)
    msg3.call(); // Text message: Hello, World!
    msg4.call(); // Change color to RGB(255, 0, 128)

    // Using associated function
    let quit_msg = Message::new_quit();
    quit_msg.call(); // Quit message received

    println!("\n=== Web Events ===");

    // Creating and handling web events
    let events = vec![
        WebEvent::PageLoad,
        WebEvent::KeyPress('x'),
        WebEvent::Paste(String::from("clipboard text")),
        WebEvent::Click { x: 100, y: 200 },
        WebEvent::PageUnload,
    ];

    for event in events {
        handle_web_event(event);
    }

    println!("\n=== Coins and Pattern Matching ===");

    // Creating coins with different data
    let penny = Coin::Penny;
    let nickel = Coin::Nickel;
    let dime = Coin::Dime;
    let quarter = Coin::Quarter(UsState::Alaska);

    println!("Penny value: {} cents", value_in_cents(penny)); // 1 cent + "Lucky penny!"
    println!("Nickel value: {} cents", value_in_cents(nickel)); // 5 cents
    println!("Dime value: {} cents", value_in_cents(dime)); // 10 cents
    println!("Quarter value: {} cents", value_in_cents(quarter)); // 25 cents + state info

    println!("\n=== Option<T> Examples ===");

    // Working with Option<T>
    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);

    println!("Five: {:?}", five); // Some(5)
    println!("Six: {:?}", six); // Some(6)
    println!("None: {:?}", none); // None

    // Finding first character
    let text = "hello";
    let empty_text = "";

    match find_first_char(text) {
        Some(ch) => println!("First character of '{}': {}", text, ch), // h
        None => println!("No first character"),
    }

    match find_first_char(empty_text) {
        Some(ch) => println!("First character: {}", ch),
        None => println!("Empty string has no first character"), // This will print
    }

    println!("\n=== Result<T, E> Examples ===");

    // Working with Result<T, E>
    let division_results = vec![
        safe_divide(10.0, 2.0), // Ok
        safe_divide(5.0, 0.0),  // Error
        safe_divide(7.5, 2.5),  // Ok
    ];

    for result in division_results {
        match result {
            Ok(value) => println!("Division result: {}", value),
            Err(error) => println!("Division error: {:?}", error),
        }
    }

    println!("\n=== Employee Enum ===");

    // Creating different employee types
    let employees = vec![
        Employee::FullTime {
            name: String::from("Alice"),
            salary: 60000,
        },
        Employee::PartTime {
            name: String::from("Bob"),
            hourly_rate: 25,
        },
        Employee::Contractor {
            name: String::from("Charlie"),
            contract_value: 50000,
            duration_months: 6,
        },
    ];

    for employee in &employees {
        println!(
            "Employee: {}, Monthly pay: ${}",
            employee.name(),
            employee.monthly_pay()
        );
    }

    println!("\n=== Generic Enums ===");

    // Working with generic enums
    let empty_container: Container<i32> = Container::Empty;
    let single_container = Container::Single(42);
    let multiple_container = Container::Multiple(vec![1, 2, 3, 4, 5]);

    println!("Empty container count: {}", empty_container.count()); // 0
    println!("Single container count: {}", single_container.count()); // 1
    println!("Multiple container count: {}", multiple_container.count()); // 5

    println!("Is empty container empty? {}", empty_container.is_empty()); // true
    println!("Is single container empty? {}", single_container.is_empty()); // false

    // String container
    let string_container = Container::Multiple(vec![String::from("hello"), String::from("world")]);
    println!("String container count: {}", string_container.count()); // 2

    println!("\n=== Using if let for Simpler Pattern Matching ===");

    let some_value = Some(3);

    // Instead of this verbose match:
    match some_value {
        Some(3) => println!("Found three!"),
        _ => (),
    }

    // We can use if let:
    if let Some(3) = some_value {
        println!("Found three with if let!");
    }

    // if let with else
    let coin = Coin::Quarter(UsState::California);
    if let Coin::Quarter(state) = coin {
        println!("State quarter from {:?}!", state);
    } else {
        println!("Not a quarter");
    }

    println!("\n=== Match Guards ===");

    let num = Some(4);

    match num {
        Some(x) if x < 5 => println!("Number {} is less than 5", x),
        Some(x) => println!("Number {} is 5 or greater", x),
        None => println!("No number"),
    }
}

// Key takeaways:
// 1. Enums define types with multiple possible variants
// 2. Each variant can hold different types and amounts of data
// 3. Use match for comprehensive pattern matching
// 4. Use if let for simple pattern matching
// 5. Option<T> replaces null values (Some(T) or None)
// 6. Result<T, E> is for operations that can fail (Ok(T) or Err(E))
// 7. Enums can have methods and associated functions
// 8. Enums can be generic
// 9. Match arms must be exhaustive (cover all possibilities)
// 10. Use _ as a catch-all pattern
