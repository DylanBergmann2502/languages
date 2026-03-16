use std::fmt;

// The Sized trait: a type is Sized if its size is known at compile time
// Most types are Sized: i32, String, Vec<T>, structs, enums...

// Every generic <T> implicitly means <T: Sized>
fn takes_sized<T>(x: T) -> T {
    x
}

// ?Sized opts out — T may or may not be Sized (Dynamically Sized Type)
// Must be behind a reference since DSTs can't live on the stack directly
fn takes_maybe_unsized<T: ?Sized + fmt::Display>(x: &T) {
    println!("{}", x);
}

// str is a DST — size unknown at compile time (unlike &str which is a fat pointer)
// You can never have a bare `str` on the stack, but you can have &str
fn print_str(s: &str) {
    println!("{}", s);
}

// [T] is also a DST — a slice of unknown length
// You can't have a bare [i32], but you can have &[i32]
fn print_slice(s: &[i32]) {
    println!("{:?}", s);
}

// Trait objects (dyn Trait) are DSTs too
// Box<dyn fmt::Display> wraps a DST on the heap with a fat pointer
fn make_displayable(n: i32) -> Box<dyn fmt::Display> {
    Box::new(n)
}

// Struct with a DST field — must be the LAST field and used behind a pointer
// This is rarely needed directly but powers things like Rc<str>, Arc<[T]>
struct Holder {
    value: Box<dyn fmt::Display>,
}

impl Holder {
    fn show(&self) {
        println!("Holder: {}", self.value);
    }
}

// Sized bound in practice: why std uses ?Sized
// Box<T> uses ?Sized so you can write Box<str>, Box<[i32]>, Box<dyn Trait>
// Without ?Sized, Box would only work with concrete sized types

fn main() {
    // Sized types — live on the stack fine
    println!("{}", takes_sized(42)); // 42
    println!("{}", takes_sized("hello")); // hello

    // ?Sized — accepts both sized and unsized (via reference)
    takes_maybe_unsized(&42); // 42
    takes_maybe_unsized("hello world"); // hello world
    takes_maybe_unsized(&3.14f64); // 3.14

    // str is a DST — only usable behind &
    let s: &str = "Rust";
    print_str(s); // Rust

    let owned = String::from("owned string");
    print_str(&owned); // owned string  (String coerces to &str)

    // [T] is a DST — only usable behind &
    let arr = [1, 2, 3, 4, 5];
    print_slice(&arr); // [1, 2, 3, 4, 5]

    let v = vec![10, 20, 30];
    print_slice(&v); // [10, 20, 30]  (Vec<T> coerces to &[T])

    // Trait objects — dyn Trait is a DST, Box gives it a known size
    let d = make_displayable(99);
    println!("{}", d); // 99

    let h = Holder {
        value: Box::new("wrapped"),
    };
    h.show(); // Holder: wrapped

    let h2 = Holder {
        value: Box::new(1234),
    };
    h2.show(); // Holder: 1234

    // Size comparison
    println!("{}", std::mem::size_of::<i32>()); // 4  (bytes, Sized)
    println!("{}", std::mem::size_of::<&str>()); // 16 (fat pointer: ptr + len)
    println!("{}", std::mem::size_of::<&[i32]>()); // 16 (fat pointer: ptr + len)
    println!("{}", std::mem::size_of::<Box<i32>>()); // 8  (thin pointer)
}
