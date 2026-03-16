// documentation.rs — Writing and generating documentation in Rust
//
// Rust has first-class documentation support built into the language.
// Doc comments compile into HTML docs via `cargo doc`.

// --- /// Line doc comments (for items below) ---

/// Adds two numbers together and returns the result.
///
/// # Arguments
///
/// * `a` - The first number
/// * `b` - The second number
///
/// # Examples
///
/// ```
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Divides `a` by `b`, returning `None` if `b` is zero.
///
/// # Examples
///
/// ```
/// assert_eq!(safe_divide(10, 2), Some(5));
/// assert_eq!(safe_divide(10, 0), None);
/// ```
fn safe_divide(a: i32, b: i32) -> Option<i32> {
    if b == 0 { None } else { Some(a / b) }
}

/// A simple point in 2D space.
///
/// # Examples
///
/// ```
/// let p = Point::new(3.0, 4.0);
/// assert_eq!(p.distance_from_origin(), 5.0);
/// ```
struct Point {
    /// The x coordinate.
    x: f64,
    /// The y coordinate.
    y: f64,
}

impl Point {
    /// Creates a new `Point` at the given coordinates.
    pub fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }

    /// Returns the distance from the origin (0, 0).
    pub fn distance_from_origin(&self) -> f64 {
        (self.x * self.x + self.y * self.y).sqrt()
    }
}

/// Possible errors when parsing a color.
///
/// # Variants
///
/// - `InvalidFormat` — the string wasn't a valid hex color
/// - `InvalidValue` — the value was out of range
#[derive(Debug)]
#[allow(dead_code)]
enum ColorError {
    /// The format was not recognized (e.g. missing `#`).
    InvalidFormat,
    /// A channel value was out of the 0–255 range.
    InvalidValue(u8),
}

/// A trait for things that can describe themselves.
///
/// Implement this trait to provide a human-readable description.
trait Describable {
    /// Returns a description of this item.
    fn describe(&self) -> String;
}

impl Describable for Point {
    fn describe(&self) -> String {
        format!("Point at ({}, {})", self.x, self.y)
    }
}

// --- Doc comment sections ---
// Common sections used in Rust docs:
//
// # Panics       — when does this function panic?
// # Errors       — what errors can it return?
// # Safety       — for unsafe functions, what must the caller guarantee?
// # Examples     — runnable code examples (tested with `cargo test --doc`)
// # Arguments    — describe parameters
// # Returns      — describe the return value

/// Parses a positive integer, panicking on invalid input.
///
/// # Panics
///
/// Panics if `s` cannot be parsed as a `u32`.
///
/// # Examples
///
/// ```
/// let n = parse_positive("42");
/// assert_eq!(n, 42);
/// ```
fn parse_positive(s: &str) -> u32 {
    s.parse().expect("expected a positive integer")
}

fn main() {
    // Doc comments don't affect runtime — they're metadata for `cargo doc`
    // But the functions themselves work normally:

    println!("{}", add(3, 4)); // 7
    println!("{:?}", safe_divide(10, 2)); // Some(5)
    println!("{:?}", safe_divide(10, 0)); // None

    let p = Point::new(3.0, 4.0);
    println!("{}", p.distance_from_origin()); // 5
    println!("{}", p.describe()); // Point at (3, 4)

    println!("{}", parse_positive("99")); // 99

    let err = ColorError::InvalidValue(255);
    println!("{:?}", err); // InvalidValue(300)

    // To generate and view docs for a Cargo project:
    // cargo doc --open
    //
    // To run doc tests (the /// Examples blocks):
    // cargo test --doc
    //
    // //! at the top of a file documents the module/crate itself:
    // //! # My Crate
    // //! This crate does amazing things.
}
