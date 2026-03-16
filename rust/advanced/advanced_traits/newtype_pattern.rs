use std::fmt;
use std::ops::{Add, Mul};

// Newtype pattern: wrap an existing type in a single-field tuple struct
// Benefits:
//   1. Implement external traits on external types (orphan rule workaround)
//   2. Type safety — prevent mixing up semantically different values
//   3. Zero runtime cost — compiler optimizes away the wrapper

// --- Orphan rule problem ---
// You can't implement an external trait on an external type directly:
// impl fmt::Display for Vec<i32> { ... }  // ERROR: both are external
//
// Solution: wrap Vec<i32> in a newtype
struct Wrapper(Vec<String>);

impl fmt::Display for Wrapper {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}]", self.0.join(", "))
    }
}

// --- Type safety with newtypes ---
// These are all just f64 underneath, but the compiler treats them as different types
struct Meters(f64);
struct Seconds(f64);
struct MetersPerSecond(f64);

#[allow(dead_code)]
impl Meters {
    fn value(&self) -> f64 {
        self.0
    }
}

#[allow(dead_code)]
impl Seconds {
    fn value(&self) -> f64 {
        self.0
    }
}

#[allow(dead_code)]
impl MetersPerSecond {
    fn value(&self) -> f64 {
        self.0
    }
}

// Can only divide Meters by Seconds — not accidentally mix them
impl std::ops::Div<Seconds> for Meters {
    type Output = MetersPerSecond;

    fn div(self, rhs: Seconds) -> MetersPerSecond {
        MetersPerSecond(self.0 / rhs.0)
    }
}

impl fmt::Display for MetersPerSecond {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{:.2} m/s", self.0)
    }
}

// --- Newtypes that add behavior ---
#[derive(Debug, Clone, Copy, PartialEq, PartialOrd)]
struct NonNegative(f64);

impl NonNegative {
    fn new(val: f64) -> Option<Self> {
        if val >= 0.0 {
            Some(NonNegative(val))
        } else {
            None
        }
    }

    fn value(&self) -> f64 {
        self.0
    }
}

impl Add for NonNegative {
    type Output = NonNegative;
    fn add(self, other: NonNegative) -> NonNegative {
        NonNegative(self.0 + other.0)
    }
}

impl Mul<f64> for NonNegative {
    type Output = Option<NonNegative>;
    fn mul(self, rhs: f64) -> Option<NonNegative> {
        NonNegative::new(self.0 * rhs)
    }
}

// --- Newtype for validated strings ---
#[derive(Debug, Clone)]
struct Email(String);

#[allow(dead_code)]
impl Email {
    fn new(s: &str) -> Result<Self, String> {
        if s.contains('@') && s.contains('.') {
            Ok(Email(s.to_string()))
        } else {
            Err(format!("'{}' is not a valid email", s))
        }
    }

    fn value(&self) -> &str {
        &self.0
    }
    fn domain(&self) -> &str {
        self.0.split('@').nth(1).unwrap_or("")
    }
}

impl fmt::Display for Email {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

// --- Newtype to hide implementation details ---
struct UserId(u64);
struct ProductId(u64);

// These are both u64 but can't be accidentally swapped
fn get_user_name(id: &UserId) -> String {
    format!("user_{}", id.0)
}

fn get_product_name(id: &ProductId) -> String {
    format!("product_{}", id.0)
}

fn main() {
    // Wrapper — Display on external type
    let w = Wrapper(vec![
        String::from("hello"),
        String::from("world"),
        String::from("rust"),
    ]);
    println!("{}", w); // [hello, world, rust]

    // Type-safe units
    let distance = Meters(100.0);
    let time = Seconds(9.58);
    let speed = distance / time;
    println!("{}", speed); // 10.44 m/s

    // Can't accidentally do: let bad = Meters(10.0) + Seconds(5.0);
    // ^ compile error: mismatched types

    // NonNegative validated newtype
    println!("{:?}", NonNegative::new(5.0)); // Some(NonNegative(5.0))
    println!("{:?}", NonNegative::new(-1.0)); // None

    let a = NonNegative::new(3.0).unwrap();
    let b = NonNegative::new(4.0).unwrap();
    println!("{:.1}", (a + b).value()); // 7.0

    println!("{:?}", a * 2.0); // Some(NonNegative(6.0))
    println!("{:?}", a * -1.0); // None

    // Email validation
    match Email::new("alice@example.com") {
        Ok(e) => {
            println!("{}", e); // alice@example.com
            println!("{}", e.domain()); // example.com
        }
        Err(e) => println!("{}", e),
    }

    match Email::new("not-an-email") {
        Ok(e) => println!("{}", e),
        Err(e) => println!("{}", e), // 'not-an-email' is not a valid email
    }

    // Type-safe IDs
    let uid = UserId(42);
    let pid = ProductId(42);
    println!("{}", get_user_name(&uid)); // user_42
    println!("{}", get_product_name(&pid)); // product_42
    // get_user_name(&pid);  // compile error: expected UserId, found ProductId
}
