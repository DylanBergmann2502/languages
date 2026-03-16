// main.rs — thin binary wrapper, calls into the library
use full_project::models::{Product, User};
use full_project::utils::formatter::format_user_list;
use full_project::utils::{format_price, validate_email};

fn main() {
    // Users
    let mut alice = User::new(1, "Alice", "alice@example.com");
    let bob = User::new(2, "Bob", "bob@example.com");

    println!("{}", alice.display_name()); // Alice#1
    println!("{}", bob.display_name()); // Bob#2
    println!("{}", alice.is_active()); // true

    alice.deactivate();
    println!("{}", alice.is_active()); // false

    // Products
    let mut widget = Product::new(1, "Widget", 9.99, 10);
    let gadget = Product::new(2, "Gadget", 24.99, 0);

    println!("{}", format_price(widget.price)); // $9.99
    println!("{}", widget.in_stock()); // true
    println!("{}", gadget.in_stock()); // false

    match widget.purchase(3) {
        Ok(total) => println!("Total: {}", format_price(total)), // Total: $29.97
        Err(e) => println!("Error: {}", e),
    }
    println!("{}", widget.stock_count()); // 7

    // Validators
    match validate_email("invalid") {
        Ok(_) => println!("valid"),
        Err(e) => println!("{}", e), // invalid format: missing @ symbol
    }

    // Formatter
    let names = vec!["Alice", "Bob", "Carol"];
    println!("{}", format_user_list(&names)); // Alice, Bob, and Carol
}
