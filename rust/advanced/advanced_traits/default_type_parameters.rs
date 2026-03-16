use std::ops::Add;

// Default type parameters: give a generic parameter a fallback type
// Syntax: <T = DefaultType>
// Used to extend traits without breaking existing code

// --- Basic default type parameter ---
// std::ops::Add uses this:
// trait Add<Rhs = Self> { type Output; fn add(self, rhs: Rhs) -> Self::Output; }

#[derive(Debug, Clone, Copy, PartialEq)]
struct Vec2 {
    x: f64,
    y: f64,
}

// Add Vec2 + Vec2 (uses default Rhs = Self)
impl Add for Vec2 {
    type Output = Vec2;

    fn add(self, other: Vec2) -> Vec2 {
        Vec2 {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

// Add Vec2 + f64 (overrides default Rhs)
impl Add<f64> for Vec2 {
    type Output = Vec2;

    fn add(self, scalar: f64) -> Vec2 {
        Vec2 {
            x: self.x + scalar,
            y: self.y + scalar,
        }
    }
}

// --- Custom trait with default type parameter ---
trait Transform<Input = String> {
    type Output;
    fn transform(&self, input: Input) -> Self::Output;
}

struct Uppercaser;
struct Repeater(usize);
struct Doubler;

// Uses the default Input = String
impl Transform for Uppercaser {
    type Output = String;

    fn transform(&self, input: String) -> String {
        input.to_uppercase()
    }
}

// Uses the default Input = String
impl Transform for Repeater {
    type Output = String;

    fn transform(&self, input: String) -> String {
        input.repeat(self.0)
    }
}

// Overrides Input = i32
impl Transform<i32> for Doubler {
    type Output = i32;

    fn transform(&self, input: i32) -> i32 {
        input * 2
    }
}

// --- Default type parameters in structs ---
struct Wrapper<T, Allocator = Vec<T>> {
    data: Allocator,
    _phantom: std::marker::PhantomData<T>,
}

impl<T: Clone + std::fmt::Debug> Wrapper<T, Vec<T>> {
    fn new() -> Self {
        Wrapper {
            data: Vec::new(),
            _phantom: std::marker::PhantomData,
        }
    }

    fn push(&mut self, val: T) {
        self.data.push(val);
    }

    fn show(&self) {
        println!("{:?}", self.data);
    }
}

// --- Builder pattern with defaults ---
struct Config<T = String> {
    name: T,
    retries: u32,
    timeout_ms: u64,
}

impl Config<String> {
    fn new(name: &str) -> Self {
        Config {
            name: name.to_string(),
            retries: 3,
            timeout_ms: 5000,
        }
    }
}

impl<T: std::fmt::Display> Config<T> {
    fn with_retries(mut self, retries: u32) -> Self {
        self.retries = retries;
        self
    }

    fn with_timeout(mut self, ms: u64) -> Self {
        self.timeout_ms = ms;
        self
    }

    fn show(&self) {
        println!(
            "Config(name={}, retries={}, timeout={}ms)",
            self.name, self.retries, self.timeout_ms
        );
    }
}

fn main() {
    // Vec2 + Vec2 (default Rhs = Self)
    let a = Vec2 { x: 1.0, y: 2.0 };
    let b = Vec2 { x: 3.0, y: 4.0 };
    let c = a + b;
    println!("{:?}", c); // Vec2 { x: 4.0, y: 6.0 }

    // Vec2 + f64 (overridden Rhs = f64)
    let d = a + 10.0;
    println!("{:?}", d); // Vec2 { x: 11.0, y: 12.0 }

    // i32 + i32 uses Add<Rhs = Self> from std
    println!("{}", 5 + 3); // 8

    // Transform with default Input = String
    let upper = Uppercaser;
    println!("{}", upper.transform(String::from("hello"))); // HELLO

    let repeat = Repeater(3);
    println!("{}", repeat.transform(String::from("ha"))); // hahaha

    // Transform with overridden Input = i32
    let double = Doubler;
    println!("{}", double.transform(21)); // 42

    // Wrapper with default allocator
    let mut w: Wrapper<i32> = Wrapper::new();
    w.push(1);
    w.push(2);
    w.push(3);
    w.show(); // [1, 2, 3]

    // Config with builder pattern
    let cfg = Config::new("database").with_retries(5).with_timeout(3000);
    cfg.show(); // Config(name=database, retries=5, timeout=3000ms)

    let default_cfg = Config::new("cache");
    default_cfg.show(); // Config(name=cache, retries=3, timeout=5000ms)
}
