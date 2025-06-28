// Option<T> - Rust's Solution to Null Values
// Option<T> is an enum that represents either Some(value) or None
// It's Rust's way of handling nullable values safely at compile time
// No null pointer exceptions! The compiler forces you to handle both cases
// Option<T> is defined as: enum Option<T> { Some(T), None }
// It's in the prelude, so you don't need to import it
// Many methods are available to work with Option values conveniently

use std::collections::HashMap;

// Custom struct for demonstration
#[derive(Debug, Clone)]
struct Person {
    name: String,
    age: u32,
    email: Option<String>, // Email is optional
}

// Function that might not find anything
fn find_person_by_name<'a>(people: &'a [Person], name: &str) -> Option<&'a Person> {
    for person in people {
        if person.name == name {
            return Some(person);
        }
    }
    None // Not found
}

// Function demonstrating basic Option creation and usage
fn basic_option_examples() {
    println!("=== Basic Option Examples ===");

    // Creating Some and None values
    let some_number = Some(42);
    let some_string = Some("Hello".to_string());
    let no_number: Option<i32> = None;

    println!("Some number: {:?}", some_number); // Some(42)
    println!("Some string: {:?}", some_string); // Some("Hello")
    println!("No number: {:?}", no_number); // None

    // Type annotation is often needed for None
    let empty_vec: Option<Vec<i32>> = None;
    println!("Empty vec: {:?}", empty_vec); // None
}

// Function demonstrating pattern matching with Option
fn pattern_matching_examples() {
    println!("\n=== Pattern Matching with Option ===");

    let numbers = vec![Some(1), None, Some(3), Some(42)];

    for number in numbers {
        match number {
            Some(n) if n < 10 => println!("Small number: {}", n),
            Some(n) => println!("Large number: {}", n),
            None => println!("No number found"),
        }
    }
}

// Function demonstrating Option methods
fn option_methods_examples() {
    println!("\n=== Option Methods ===");

    let some_value = Some(42);
    let no_value: Option<i32> = None;

    // is_some() and is_none()
    println!("some_value.is_some(): {}", some_value.is_some()); // true
    println!("some_value.is_none(): {}", some_value.is_none()); // false
    println!("no_value.is_some(): {}", no_value.is_some()); // false
    println!("no_value.is_none(): {}", no_value.is_none()); // true

    // unwrap() - use with caution! Panics on None
    println!("some_value.unwrap(): {}", some_value.unwrap()); // 42
                                                              // println!("no_value.unwrap(): {}", no_value.unwrap());      // This would panic!

    // unwrap_or() - provides a default value
    println!("some_value.unwrap_or(0): {}", some_value.unwrap_or(0)); // 42
    println!("no_value.unwrap_or(0): {}", no_value.unwrap_or(0)); // 0

    // unwrap_or_else() - provides a default via closure
    println!(
        "no_value.unwrap_or_else(|| 100): {}",
        no_value.unwrap_or_else(|| 100)
    ); // 100

    // expect() - like unwrap but with custom panic message
    println!(
        "some_value.expect('Should have value'): {}",
        some_value.expect("Should have value")
    ); // 42
       // no_value.expect("Should have value");  // Would panic with custom message
}

// Function demonstrating Option transformations
fn option_transformations() {
    println!("\n=== Option Transformations ===");

    let number = Some(42);
    let no_number: Option<i32> = None;

    // map() - transforms the value inside Some, leaves None unchanged
    let doubled = number.map(|n| n * 2);
    let doubled_none = no_number.map(|n| n * 2);
    println!("number.map(|n| n * 2): {:?}", doubled); // Some(84)
    println!("no_number.map(|n| n * 2): {:?}", doubled_none); // None

    // map_or() - map with default value
    let result1 = number.map_or(0, |n| n * 2);
    let result2 = no_number.map_or(0, |n| n * 2);
    println!("number.map_or(0, |n| n * 2): {}", result1); // 84
    println!("no_number.map_or(0, |n| n * 2): {}", result2); // 0

    // map_or_else() - map with default via closure
    let result3 = no_number.map_or_else(|| -1, |n| n * 2);
    println!("no_number.map_or_else(|| -1, |n| n * 2): {}", result3); // -1

    // and_then() - chains Option operations (flatMap in other languages)
    let divide_by_two = |n| if n % 2 == 0 { Some(n / 2) } else { None };
    let chained = number.and_then(divide_by_two);
    println!("number.and_then(divide_by_two): {:?}", chained); // Some(21)

    let odd_number = Some(43);
    let chained_odd = odd_number.and_then(divide_by_two);
    println!("odd_number.and_then(divide_by_two): {:?}", chained_odd); // None
}

// Function demonstrating Option with collections
fn option_with_collections() {
    println!("\n=== Option with Collections ===");

    let mut map = HashMap::new();
    map.insert("apple", 5);
    map.insert("banana", 3);

    // HashMap.get() returns Option<&V>
    match map.get("apple") {
        Some(count) => println!("Found {} apples", count),
        None => println!("No apples found"),
    }

    match map.get("orange") {
        Some(count) => println!("Found {} oranges", count),
        None => println!("No oranges found"),
    }

    // Vec indexing with get() returns Option
    let numbers = vec![1, 2, 3, 4, 5];
    println!("numbers.get(2): {:?}", numbers.get(2)); // Some(&3)
    println!("numbers.get(10): {:?}", numbers.get(10)); // None

    // first() and last() return Options
    println!("numbers.first(): {:?}", numbers.first()); // Some(&1)
    println!("numbers.last(): {:?}", numbers.last()); // Some(&5)

    let empty_vec: Vec<i32> = vec![];
    println!("empty_vec.first(): {:?}", empty_vec.first()); // None
}

// Function demonstrating Option with strings
fn option_with_strings() {
    println!("\n=== Option with Strings ===");

    let text = "Hello, World!";
    let empty_text = "";

    // chars().next() returns Option<char>
    println!("text.chars().next(): {:?}", text.chars().next()); // Some('H')
    println!("empty_text.chars().next(): {:?}", empty_text.chars().next()); // None

    // lines().next() returns Option<&str>
    let multiline = "Line 1\nLine 2\nLine 3";
    println!("multiline.lines().next(): {:?}", multiline.lines().next()); // Some("Line 1")

    // split().next() returns Option<&str>
    let csv = "apple,banana,cherry";
    println!("csv.split(',').next(): {:?}", csv.split(',').next()); // Some("apple")

    // Finding substring
    let position = text.find("World");
    match position {
        Some(pos) => println!("Found 'World' at position {}", pos),
        None => println!("'World' not found"),
    }
}

// Function demonstrating Option filtering
fn option_filtering() {
    println!("\n=== Option Filtering ===");

    let numbers = vec![Some(1), Some(2), None, Some(4), None, Some(6)];

    // filter() on Option - keeps Some if predicate is true, otherwise None
    let even_numbers: Vec<Option<i32>> = numbers
        .iter()
        .map(|opt| opt.filter(|&n| n % 2 == 0))
        .collect();
    println!("Filtered even numbers: {:?}", even_numbers); // [None, Some(2), None, Some(4), None, Some(6)]

    // Collecting only Some values
    let only_some: Vec<i32> = numbers.iter().filter_map(|&opt| opt).collect();
    println!("Only Some values: {:?}", only_some); // [1, 2, 4, 6]

    // Collecting only even Some values
    let only_even: Vec<i32> = numbers
        .iter()
        .filter_map(|&opt| opt)
        .filter(|&n| n % 2 == 0)
        .collect();
    println!("Only even Some values: {:?}", only_even); // [2, 4, 6]
}

// Function demonstrating Option with custom types
fn option_with_custom_types() {
    println!("\n=== Option with Custom Types ===");

    let people = vec![
        Person {
            name: "Alice".to_string(),
            age: 30,
            email: Some("alice@example.com".to_string()),
        },
        Person {
            name: "Bob".to_string(),
            age: 25,
            email: None,
        },
        Person {
            name: "Charlie".to_string(),
            age: 35,
            email: Some("charlie@email.com".to_string()),
        },
    ];

    // Finding a person
    match find_person_by_name(&people, "Alice") {
        Some(person) => println!("Found: {:?}", person),
        None => println!("Person not found"),
    }

    match find_person_by_name(&people, "David") {
        Some(person) => println!("Found: {:?}", person),
        None => println!("Person not found"),
    }

    // Working with optional email
    for person in &people {
        match &person.email {
            Some(email) => println!("{} has email: {}", person.name, email),
            None => println!("{} has no email address", person.name),
        }
    }

    // Using map with optional email
    for person in &people {
        let email_domain = person
            .email
            .as_ref()
            .and_then(|email| email.split('@').nth(1))
            .unwrap_or("no email");
        println!("{}'s email domain: {}", person.name, email_domain);
    }
}

// Function demonstrating Option combinators
fn option_combinators() {
    println!("\n=== Option Combinators ===");

    let x = Some(2);
    let y = Some(3);
    let z: Option<i32> = None;

    // and() - returns None if either is None, otherwise returns the second Option
    println!("x.and(y): {:?}", x.and(y)); // Some(3)
    println!("x.and(z): {:?}", x.and(z)); // None
    println!("z.and(y): {:?}", z.and(y)); // None

    // or() - returns the first Some, or None if both are None
    println!("x.or(y): {:?}", x.or(y)); // Some(2)
    println!("x.or(z): {:?}", x.or(z)); // Some(2)
    println!("z.or(y): {:?}", z.or(y)); // Some(3)

    // xor() - returns Some if exactly one is Some, None otherwise
    println!("x.xor(y): {:?}", x.xor(y)); // None (both are Some)
    println!("x.xor(z): {:?}", x.xor(z)); // Some(2)
    println!("z.xor(y): {:?}", z.xor(y)); // Some(3)

    // zip() - combines two Options into Option<(T, U)>
    println!("x.zip(y): {:?}", x.zip(y)); // Some((2, 3))
    println!("x.zip(z): {:?}", x.zip(z)); // None
}

// Function demonstrating Option error handling patterns
fn option_error_handling() {
    println!("\n=== Option Error Handling Patterns ===");

    // Early return pattern
    fn process_optional_data(data: Option<i32>) -> Option<String> {
        let value = data?; // Early return if None
        if value > 0 {
            Some(format!("Positive: {}", value))
        } else {
            None
        }
    }

    println!(
        "process_optional_data(Some(42)): {:?}",
        process_optional_data(Some(42))
    );
    println!(
        "process_optional_data(Some(-5)): {:?}",
        process_optional_data(Some(-5))
    );
    println!(
        "process_optional_data(None): {:?}",
        process_optional_data(None)
    );

    // Chaining operations
    let result = Some(10)
        .map(|x| x * 2)
        .filter(|&x| x > 15)
        .map(|x| format!("Result: {}", x));
    println!("Chained operations: {:?}", result); // Some("Result: 20")

    // Converting Option to Result
    let opt = Some(42);
    let result: Result<i32, &str> = opt.ok_or("No value provided");
    println!("Option to Result: {:?}", result); // Ok(42)

    let opt_none: Option<i32> = None;
    let result_err: Result<i32, &str> = opt_none.ok_or("No value provided");
    println!("None to Result: {:?}", result_err); // Err("No value provided")
}

// Function demonstrating common Option pitfalls and solutions
fn option_best_practices() {
    println!("\n=== Option Best Practices ===");

    // DON'T: Use unwrap() unless you're absolutely sure
    let maybe_number = Some(42);
    // let value = maybe_number.unwrap(); // Dangerous!

    // DO: Use safer alternatives
    let value = maybe_number.unwrap_or(0);
    println!("Safe unwrap with default: {}", value);

    // DON'T: Nested pattern matching
    let nested: Option<Option<i32>> = Some(Some(42));
    // match nested {
    //     Some(inner) => match inner {
    //         Some(value) => println!("Value: {}", value),
    //         None => println!("Inner None"),
    //     },
    //     None => println!("Outer None"),
    // }

    // DO: Use flatten() or and_then()
    let flattened = nested.flatten();
    println!("Flattened: {:?}", flattened); // Some(42)

    // DON'T: Manual None checking
    let numbers = vec![Some(1), None, Some(3)];
    // let mut result = Vec::new();
    // for num in numbers {
    //     if num.is_some() {
    //         result.push(num.unwrap());
    //     }
    // }

    // DO: Use iterator methods
    let result: Vec<i32> = numbers.into_iter().flatten().collect();
    println!("Filtered result: {:?}", result); // [1, 3]
}

fn main() {
    basic_option_examples();
    pattern_matching_examples();
    option_methods_examples();
    option_transformations();
    option_with_collections();
    option_with_strings();
    option_filtering();
    option_with_custom_types();
    option_combinators();
    option_error_handling();
    option_best_practices();

    println!("\n=== Summary ===");
    println!("Option<T> is Rust's way of handling nullable values safely:");
    println!("- Some(value) represents a value");
    println!("- None represents the absence of a value");
    println!("- Compiler forces you to handle both cases");
    println!("- Rich set of methods for transformation and combination");
    println!("- No null pointer exceptions possible!");
}

// Key takeaways:
// 1. Option<T> eliminates null pointer exceptions at compile time
// 2. Use Some(value) for present values, None for absent values
// 3. Pattern matching is the primary way to handle Options
// 4. Many convenient methods: map, unwrap_or, and_then, etc.
// 5. ? operator provides early return for None values
// 6. filter_map is great for working with iterators of Options
// 7. Avoid unwrap() in production code - use safer alternatives
// 8. Option composes well with other Option values
// 9. Can convert between Option and Result types
// 10. Iterator methods like flatten() help with nested Options
