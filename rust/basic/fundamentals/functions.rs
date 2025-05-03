// Function definition with no parameters and no return value
fn say_hello() {
    println!("Hello!");
}

// Function with parameters
fn print_sum(a: i32, b: i32) {
    println!("{} + {} = {}", a, b, a + b);
}

// Function with a return value
fn add(a: i32, b: i32) -> i32 {
    // Return expression (without semicolon)
    a + b
}

// Alternate way to return a value
fn subtract(a: i32, b: i32) -> i32 {
    // Using the return keyword (with semicolon)
    return a - b;
}

// Function with multiple return values using a tuple
fn swap(a: i32, b: i32) -> (i32, i32) {
    (b, a)
}

// Function with an early return
fn divide(a: f64, b: f64) -> Option<f64> {
    if b == 0.0 {
        return None;
    }

    Some(a / b)
}

// Function with a block expression as a return value
fn get_length(s: &str) -> usize {
    // The block evaluates to the length
    {
        // We can have multiple statements in a block
        let trimmed = s.trim();
        // The last expression (without semicolon) is the value of the block
        trimmed.len()
    }
}

// Nested function (function inside another function)
fn outer_function() {
    println!("This is the outer function");

    // Inner functions can only be called within their parent function
    fn inner_function() {
        println!("This is the inner function");
    }

    inner_function();
}

// Function with generic type parameters (we'll cover more in generics.rs)
fn first<T>(list: &[T]) -> Option<&T> {
    if list.is_empty() {
        None
    } else {
        Some(&list[0])
    }
}

// Function with closures as parameters
fn apply_twice<F>(f: F, x: i32) -> i32
where
    F: Fn(i32) -> i32,
{
    f(f(x))
}

// Example of a recursive function
fn factorial(n: u64) -> u64 {
    // Base case
    if n == 0 {
        1
    } else {
        // Recursive case
        n * factorial(n - 1)
    }
}

// Function that takes another function as an argument
fn call_with_args<F>(f: F, a: i32, b: i32) -> i32
where
    F: Fn(i32, i32) -> i32,
{
    f(a, b)
}

fn main() {
    // Calling functions
    say_hello();

    print_sum(5, 7);

    let result = add(10, 20);
    println!("10 + 20 = {}", result);

    let difference = subtract(15, 5);
    println!("15 - 5 = {}", difference);

    // Using tuple destructuring with function return
    let (x, y) = swap(3, 7);
    println!("Swapped 3 and 7: {} and {}", x, y);

    // Handling optional return values
    match divide(10.0, 2.0) {
        Some(result) => println!("10 / 2 = {}", result),
        None => println!("Cannot divide by zero"),
    }

    match divide(10.0, 0.0) {
        Some(result) => println!("10 / 0 = {}", result),
        None => println!("Cannot divide by zero"),
    }

    // Using block expressions
    let length = get_length("  Hello, Rust!  ");
    println!("Length of trimmed string: {}", length);

    // Calling a function with nested functions
    outer_function();

    // Using a generic function
    let numbers = [1, 2, 3, 4, 5];
    match first(&numbers) {
        Some(value) => println!("First number: {}", value),
        None => println!("List is empty"),
    }

    let empty: [i32; 0] = [];
    match first(&empty) {
        Some(value) => println!("First number: {}", value),
        None => println!("List is empty"),
    }

    // Using function with a closure
    let double = |x| x * 2;
    let quadruple = apply_twice(double, 5);
    println!("5 quadrupled: {}", quadruple);

    // Using a recursive function
    let fact_5 = factorial(5);
    println!("5! = {}", fact_5);

    // Function pointers
    let math_function: fn(i32, i32) -> i32 = add;
    let sum = math_function(25, 25);
    println!("25 + 25 = {}", sum);

    // Passing functions to other functions
    let multiply = |a, b| a * b;
    println!("3 * 4 = {}", call_with_args(multiply, 3, 4));
}
