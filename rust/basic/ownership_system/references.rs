// Borrowing, references, and slices
// References allow you to refer to a value without taking ownership
// & creates a reference, * dereferences

fn main() {
    // Basic borrowing with immutable references
    let s1 = String::from("hello");
    let len = calculate_length(&s1); // &s1 borrows s1
    println!("The length of '{}' is {}.", s1, len); // The length of 'hello' is 5.

    // Multiple immutable borrows are allowed
    let r1 = &s1;
    let r2 = &s1;
    println!("r1: {}, r2: {}", r1, r2); // r1: hello, r2: hello

    // Mutable references
    let mut s2 = String::from("hello");
    change(&mut s2);
    println!("Changed: {}", s2); // Changed: hello, world!

    // Only one mutable reference at a time
    let r3 = &mut s2;
    // let r4 = &mut s2;  // Error: cannot borrow `s2` as mutable more than once
    r3.push_str(" Rust");
    println!("r3: {}", r3); // r3: hello, world! Rust

    // Cannot have mutable and immutable references simultaneously
    let s3 = String::from("concurrent"); // Fixed: removed mut
    let r5 = &s3; // immutable borrow
    let r6 = &s3; // another immutable borrow
    // let r7 = &mut s3;  // Error: cannot borrow as mutable
    println!("r5: {}, r6: {}", r5, r6); // r5: concurrent, r6: concurrent

    // Reference scope and lifetime
    let mut s4 = String::from("scope");
    {
        let r8 = &mut s4;
        r8.push_str(" test");
    } // r8 goes out of scope here
    let r9 = &mut s4; // This is okay now
    println!("r9: {}", r9); // r9: scope test

    // Dangling references are prevented
    // let reference_to_nothing = dangle();  // Error: missing lifetime specifier
    let valid_reference = no_dangle();
    println!("Valid: {}", valid_reference); // Valid: hello

    // String slices
    let s5 = String::from("hello world");
    let hello = &s5[0..5]; // or &s5[..5]
    let world = &s5[6..11]; // or &s5[6..]
    let whole = &s5[..]; // entire string
    println!("Slices: '{}', '{}', '{}'", hello, world, whole);
    // Slices: 'hello', 'world', 'hello world'

    // String literals are slices
    let s6 = "Hello, world!"; // &str type
    println!("String literal: {}", s6); // String literal: Hello, world!

    // Array slices
    let a = [1, 2, 3, 4, 5];
    let slice = &a[1..3];
    println!("Array slice: {:?}", slice); // Array slice: [2, 3]

    // Mutable slices
    let mut arr = [10, 20, 30, 40, 50];
    let slice_mut = &mut arr[1..4];
    slice_mut[0] = 25;
    println!("Modified through slice: {:?}", arr); // Modified through slice: [10, 25, 30, 40, 50]

    // References in structs
    #[derive(Debug)]
    struct Book {
        title: String,
        pages: u32,
    }

    let book = Book {
        title: String::from("Rust Programming"),
        pages: 500,
    };

    let title_ref = &book.title;
    let pages_ref = &book.pages;
    println!("Title: {}, Pages: {}", title_ref, pages_ref);
    // Title: Rust Programming, Pages: 500

    // References to vectors
    let v = vec![1, 2, 3, 4, 5];
    let third = &v[2];
    println!("The third element is {}", third); // The third element is 3

    // Mutable vector references
    let mut v_mut = vec![1, 2, 3];
    let first = &mut v_mut[0];
    *first = 10; // Dereference to modify
    println!("Modified vector: {:?}", v_mut); // Modified vector: [10, 2, 3]

    // Reference rules compilation errors commented out
    let mut s7 = String::from("rules");

    let r10 = &s7; // immutable borrow
    let r11 = &s7; // another immutable borrow
    println!("{} and {}", r10, r11); // rules and rules
    // r10 and r11 are no longer used after this point

    let r12 = &mut s7; // mutable borrow is okay now
    r12.push_str(" work");
    println!("{}", r12); // rules work

    // Using references in functions
    let mut numbers = vec![1, 2, 3, 4, 5];
    double_values(&mut numbers);
    println!("Doubled: {:?}", numbers); // Doubled: [2, 4, 6, 8, 10]

    // Reference comparison
    let x = 5;
    let y = 5;
    let rx = &x;
    let ry = &y;
    println!("rx == ry: {}", rx == ry); // true (values are equal)
    println!("rx ptr: {:p}, ry ptr: {:p}", rx, ry); // different addresses

    // Implicit dereferencing with methods
    let s8 = String::from("implicit");
    let r13 = &s8;
    println!("Length via ref: {}", r13.len()); // Length via ref: 8
}

fn calculate_length(s: &String) -> usize {
    s.len()
} // s goes out of scope, but doesn't have ownership, so nothing happens

fn change(some_string: &mut String) {
    some_string.push_str(", world!");
}

// This would cause a dangling reference
/*
fn dangle() -> &String {
    let s = String::from("hello");
    &s  // Error: s goes out of scope, reference would be invalid
}
*/

fn no_dangle() -> String {
    let s = String::from("hello");
    s // Ownership is moved out
}

fn double_values(numbers: &mut Vec<i32>) {
    for num in numbers.iter_mut() {
        *num *= 2;
    }
}
