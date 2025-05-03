// This is a comment in Rust
// The main function is the entry point of every Rust program
fn main() {
    // println! is a macro that prints text to the console
    println!("Hello, World!");

    // We can also use variables
    let message = "Hello from Rust!";
    println!("{}", message);

    // Rust has string formatting similar to other languages
    let name = "Rust Beginner";
    println!("Welcome, {}!", name);

    // We can include expressions in our formatting too
    println!("1 + 2 = {}", 1 + 2);

    // Formatting options are available for more control
    println!("Padded number: {:5}", 42); // Right-aligned with width 5
    println!("Left-aligned: {:<5}", 42); // Left-aligned with width 5
    println!("With decimals: {:.2}", 42.1234); // Two decimal places

    // Multiple values can be formatted too
    println!("x = {}, y = {}", 10, 20);

    // Named parameters
    println!(
        "{greeting}, {name}!",
        greeting = "Hello",
        name = "Rustacean"
    );
}
