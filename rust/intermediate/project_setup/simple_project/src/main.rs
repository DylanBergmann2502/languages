// simple_project/src/main.rs
// A hands-on Cargo project demonstrating:
//   - Multi-file project structure
//   - External dependencies (rand)
//   - Modules across files (see src/math.rs and src/greet.rs)
//   - cargo run, cargo build, cargo test, cargo clippy, cargo fmt

mod greet;
mod math;

use rand::RngExt;

fn main() {
    // Using our own modules
    println!("{}", greet::hello("Alice")); // Hello, Alice!
    println!("{}", greet::hello("Bob")); // Hello, Bob!
    println!("{}", greet::goodbye("Alice")); // Goodbye, Alice!

    println!("{}", math::square(5)); // 25
    println!("{}", math::factorial(6)); // 720
    println!("{:.4}", math::circle_area(3.0)); // 28.2743

    // Using an external dependency (rand)
    // rand 0.10: thread_rng() renamed to rng()
    let mut rng = rand::rng();
    let roll: u32 = rng.random_range(1..=6);
    println!("Dice roll: {} (random 1-6)", roll);

    let rolls: Vec<u32> = (0..5).map(|_| rng.random_range(1..=6)).collect();
    println!("5 rolls: {:?}", rolls);

    // Build info
    println!(
        "Running in: {}",
        if cfg!(debug_assertions) {
            "debug"
        } else {
            "release"
        }
    );
}
