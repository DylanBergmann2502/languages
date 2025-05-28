// Understanding Rust's ownership model
// Each value in Rust has an owner
// There can only be one owner at a time
// When the owner goes out of scope, the value will be dropped

fn main() {
    // Basic ownership
    let s1 = String::from("hello");
    println!("s1: {}", s1); // hello

    // Ownership transfer (move)
    let s2 = s1; // s1 is moved to s2
    // println!("s1: {}", s1);  // This would cause a compile error!
    println!("s2: {}", s2); // hello

    // Copy trait for stack-stored types
    let x = 5;
    let y = x; // x is copied, not moved
    println!("x: {}, y: {}", x, y); // 5, 5

    // Ownership and functions
    let s3 = String::from("world");
    takes_ownership(s3); // s3 is moved into the function
    // println!("s3: {}", s3);  // This would cause a compile error!

    let x = 10;
    makes_copy(x); // x is copied into the function
    println!("x still valid: {}", x); // 10

    // Functions can return ownership
    let s4 = gives_ownership();
    println!("s4: {}", s4); // yours

    let s5 = String::from("hello");
    let s6 = takes_and_gives_back(s5);
    // println!("s5: {}", s5);  // This would cause a compile error!
    println!("s6: {}", s6); // hello

    // Understanding scope
    {
        let s7 = String::from("scoped");
        println!("Inside scope: {}", s7); // scoped
    } // s7 goes out of scope and is dropped here

    // Multiple owners not allowed
    let s8 = String::from("shared");
    let s9 = s8;
    let s10 = s9; // s9 is moved to s10
    // println!("s8: {}", s8);  // Error: s8 was moved to s9
    // println!("s9: {}", s9);  // Error: s9 was moved to s10
    println!("s10: {}", s10); // shared

    // Arrays and tuples follow ownership rules
    let arr1 = vec![1, 2, 3, 4, 5];
    let arr2 = arr1; // arr1 is moved to arr2
    // println!("arr1: {:?}", arr1);  // This would cause a compile error!
    println!("arr2: {:?}", arr2); // [1, 2, 3, 4, 5]

    // Fixed-size arrays can be copied
    let fixed_arr1 = [1, 2, 3];
    let fixed_arr2 = fixed_arr1; // Copy happens here
    println!("fixed_arr1: {:?}", fixed_arr1); // [1, 2, 3]
    println!("fixed_arr2: {:?}", fixed_arr2); // [1, 2, 3]

    // Ownership with structs
    #[derive(Debug)]
    struct Book {
        title: String,
        pages: u32,
    }

    let book1 = Book {
        title: String::from("Rust Guide"),
        pages: 300,
    };

    let book2 = book1; // book1 is moved to book2
    // println!("book1: {:?}", book1);  // This would cause a compile error!
    println!("book2: {:?}", book2); // Book { title: "Rust Guide", pages: 300 }

    // Partial moves
    let book3 = Book {
        title: String::from("Advanced Rust"),
        pages: 500,
    };

    let title = book3.title; // Only title field is moved
    // println!("book3: {:?}", book3);  // Error: partial move
    println!("title: {}", title); // Advanced Rust
    println!("pages: {}", book3.pages); // 500 (still accessible)

    // Clone to create deep copies
    let s11 = String::from("clonable");
    let s12 = s11.clone(); // Deep copy
    println!("s11: {}", s11); // clonable
    println!("s12: {}", s12); // clonable

    // Ownership patterns with match
    let optional = Some(String::from("optional value"));
    match optional {
        Some(s) => println!("Got: {}", s), // Got: optional value
        None => println!("Got nothing"),
    }
    // println!("{:?}", optional);  // Error: value moved in match

    // Using ref to avoid moves in match
    let optional2 = Some(String::from("preserved"));
    match &optional2 {
        Some(s) => println!("Got: {}", s), // Got: preserved
        None => println!("Got nothing"),
    }
    println!("Still have: {:?}", optional2); // Still have: Some("preserved")
}

fn takes_ownership(some_string: String) {
    println!("Took ownership: {}", some_string); // Took ownership: world
} // some_string goes out of scope and is dropped

fn makes_copy(some_integer: i32) {
    println!("Made copy: {}", some_integer); // Made copy: 10
} // some_integer goes out of scope, nothing special happens

fn gives_ownership() -> String {
    let some_string = String::from("yours");
    some_string // Return moves ownership out
}

fn takes_and_gives_back(a_string: String) -> String {
    a_string // Return moves ownership out
}
