fn main() {
    // VARIABLES AND MUTABILITY

    // By default, variables in Rust are immutable
    let x = 5;
    println!("The value of x is: {}", x);

    // This would cause an error:
    // x = 6; // cannot assign twice to immutable variable

    // To make a variable mutable, use the `mut` keyword
    let mut y = 5;
    println!("The value of y is: {}", y);

    y = 6; // This is allowed
    println!("The value of y is now: {}", y);

    // SHADOWING
    // You can declare a new variable with the same name
    // This is different from mutation!
    let z = 5;
    println!("The value of z is: {}", z);

    // This creates a new variable that shadows the previous one
    let z = z + 1; // This is allowed!
    println!("The value of z is now: {}", z);

    // Shadowing also lets you change the type
    let spaces = "   "; // This is a string
    println!("Spaces as string: '{}'", spaces);

    let spaces = spaces.len(); // Now it's a number
    println!("Number of spaces: {}", spaces);

    // With mutable variables, you cannot change the type:
    // let mut text = "hello";
    // text = text.len(); // This would cause an error

    // CONSTANTS
    // Constants are always immutable, use the const keyword
    // Constants need type annotations
    // Constants can be declared in any scope, including the global scope
    const MAX_POINTS: u32 = 100_000;
    println!("The maximum points is: {}", MAX_POINTS);

    // DIFFERENT WAYS TO DECLARE VARIABLES

    // With type annotation
    let _a: i32 = 10;

    // With type inference
    let _b = 20; // Rust infers the type

    // Multiple variables
    let (c, d) = (30, 40);
    println!("c = {}, d = {}", c, d);

    // You can declare without initializing, but must annotate type
    // And you must initialize before use
    let e: i32;
    // Using e here would cause an error
    e = 50;
    println!("e = {}", e);

    // SCOPE
    {
        // This variable only exists in this block
        let inner_variable = 100;
        println!("inner_variable = {}", inner_variable);
    }
    // Using inner_variable here would cause an error

    // VARIABLE FREEZING WITH REFERENCES
    let mut value = 123;
    println!("value = {}", value);

    // While a reference exists, you can't modify the variable
    let reference = &value;
    // value = 456; // This would cause an error
    println!("reference = {}", reference);

    // After the reference is no longer used, you can modify again
    value = 456;
    println!("value now = {}", value);
}
