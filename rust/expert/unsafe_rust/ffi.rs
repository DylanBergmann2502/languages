// FFI: Foreign Function Interface
// Calling C functions from Rust, and exposing Rust functions to C
//
// `extern "C"` — use the C calling convention
// `#[no_mangle]` — preserve the function name (don't mangle it like Rust does)
// `libc` crate — C type definitions (c_int, c_char, size_t, etc.)
//
// All extern function calls are unsafe — Rust can't verify C's behavior

use std::ffi::{CStr, CString};
use std::os::raw::{c_char, c_int};

// --- Declaring external C functions ---
// These are from libc (the C standard library), available on any Unix/Linux system
extern "C" {
    fn abs(x: c_int) -> c_int;
    fn strlen(s: *const c_char) -> usize;
    fn puts(s: *const c_char) -> c_int;
    fn atoi(s: *const c_char) -> c_int;
}

// --- Exposing Rust functions to C ---
// #[no_mangle]: keep the exact function name in the compiled binary
// extern "C": use C calling convention so C code can call this
#[no_mangle]
pub extern "C" fn rust_add(a: c_int, b: c_int) -> c_int {
    a + b
}

#[no_mangle]
pub extern "C" fn rust_max(a: c_int, b: c_int) -> c_int {
    if a > b { a } else { b }
}

// --- CString and CStr: bridging Rust strings and C strings ---
// C strings: null-terminated byte sequences (*const c_char)
// CString:   Rust-owned C-compatible string (heap allocated, null terminated)
// CStr:      borrowed reference to a C string (like &str to String)

fn demo_cstring() {
    // Rust String -> CString -> *const c_char (to pass to C)
    let rust_str = String::from("Hello from Rust");
    let c_string = CString::new(rust_str).unwrap();
    let ptr = c_string.as_ptr();

    unsafe {
        let len = strlen(ptr);
        println!("{}", len); // 15
        puts(ptr); // Hello from Rust
    }

    // *const c_char -> CStr -> &str (from C back to Rust)
    let c_literal: &[u8] = b"Hello, C!\0"; // null-terminated byte literal
    let c_str = unsafe { CStr::from_ptr(c_literal.as_ptr() as *const c_char) };
    let rust_back = c_str.to_str().unwrap();
    println!("{}", rust_back); // Hello, C!
    println!("{}", rust_back.len()); // 9

    // CString with embedded content
    let numbers = CString::new("42").unwrap();
    let n = unsafe { atoi(numbers.as_ptr()) };
    println!("{}", n); // 42
}

// --- Structs that cross the FFI boundary ---
// #[repr(C)]: lay out the struct in C's memory order (not Rust's optimized order)
// Without this, Rust may reorder fields for alignment — C won't know about that

#[repr(C)]
#[derive(Debug)]
pub struct Point {
    x: f64,
    y: f64,
}

#[repr(C)]
#[derive(Debug)]
pub struct Rectangle {
    top_left: Point,
    bottom_right: Point,
}

impl Rectangle {
    fn area(&self) -> f64 {
        let width = (self.bottom_right.x - self.top_left.x).abs();
        let height = (self.bottom_right.y - self.top_left.y).abs();
        width * height
    }
}

// Expose a Rust function taking a C-compatible struct
#[no_mangle]
pub extern "C" fn rect_area(rect: Rectangle) -> f64 {
    rect.area()
}

// --- Callbacks: passing Rust closures to C-like function pointers ---
// C uses function pointers; Rust can pass fn pointers (not closures) via FFI
type Predicate = extern "C" fn(c_int) -> bool;

extern "C" fn is_even(n: c_int) -> bool {
    n % 2 == 0
}

extern "C" fn is_positive(n: c_int) -> bool {
    n > 0
}

fn filter_with(nums: &[i32], pred: Predicate) -> Vec<i32> {
    nums.iter().copied().filter(|&n| pred(n)).collect()
}

fn main() {
    // Calling libc functions
    unsafe {
        println!("{}", abs(-42)); // 42
        println!("{}", abs(7)); // 7
    }

    // Rust functions exposed to C (callable from Rust too)
    println!("{}", rust_add(10, 32)); // 42
    println!("{}", rust_max(17, 99)); // 99

    // CString / CStr demos
    demo_cstring();
    // 15
    // Hello from Rust
    // Hello, C!
    // 9
    // 42

    // repr(C) structs
    let rect = Rectangle {
        top_left: Point { x: 0.0, y: 0.0 },
        bottom_right: Point { x: 4.0, y: 3.0 },
    };
    println!("{:.1}", rect.area()); // 12.0
    println!(
        "{:.1}",
        rect_area(Rectangle {
            top_left: Point { x: 1.0, y: 1.0 },
            bottom_right: Point { x: 6.0, y: 4.0 },
        })
    ); // 15.0

    // Function pointer callbacks
    let nums = vec![-3, -2, -1, 0, 1, 2, 3, 4];
    println!("{:?}", filter_with(&nums, is_even)); // [-2, 0, 2, 4]
    println!("{:?}", filter_with(&nums, is_positive)); // [1, 2, 3, 4]

    // Size of repr(C) types — predictable layout
    println!("{}", std::mem::size_of::<Point>()); // 16 (2 x f64)
    println!("{}", std::mem::size_of::<Rectangle>()); // 32 (2 x Point)

    println!("ffi done"); // ffi done
}
