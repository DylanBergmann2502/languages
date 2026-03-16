// Closures: anonymous functions that can capture their environment

fn apply<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 {
    f(x)
}

fn apply_twice<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 {
    f(f(x))
}

// Returning a closure — must use Box<dyn Fn> since size isn't known at compile time
fn make_adder(n: i32) -> Box<dyn Fn(i32) -> i32> {
    Box::new(move |x| x + n)
}

fn make_multiplier(n: i32) -> impl Fn(i32) -> i32 {
    move |x| x * n
}

fn main() {
    // Basic closure syntax
    let double = |x| x * 2;
    let add_ten = |x| x + 10;

    println!("{}", double(5)); // 10
    println!("{}", add_ten(5)); // 15

    // Closures can infer types
    let square = |x: i32| x * x;
    println!("{}", square(4)); // 16

    // Multi-line closure
    let describe = |n: i32| {
        if n > 0 {
            "positive"
        } else if n < 0 {
            "negative"
        } else {
            "zero"
        }
    };
    println!("{}", describe(5)); // positive
    println!("{}", describe(-3)); // negative
    println!("{}", describe(0)); // zero

    // Closures capture their environment (unlike regular functions)
    let base = 100;
    let add_base = |x| x + base; // captures `base` by reference
    println!("{}", add_base(42)); // 142
    println!("{}", add_base(0)); // 100

    // move closure — takes ownership of captured variables
    let name = String::from("Alice");
    let greet = move || format!("Hello, {}!", name); // name moved into closure
    println!("{}", greet()); // Hello, Alice!
    // println!("{}", name); // error: name moved

    // The three closure traits:
    // Fn     — borrows immutably, can be called multiple times
    // FnMut  — borrows mutably, can be called multiple times
    // FnOnce — takes ownership, can only be called once

    // FnMut example
    let mut count = 0;
    let mut increment = || {
        count += 1;
        count
    };
    println!("{}", increment()); // 1
    println!("{}", increment()); // 2
    println!("{}", increment()); // 3

    // Passing closures to functions
    println!("{}", apply(double, 7)); // 14
    println!("{}", apply(add_ten, 7)); // 17
    println!("{}", apply_twice(double, 3)); // 12

    // Returning closures
    let add5 = make_adder(5);
    let add100 = make_adder(100);
    println!("{}", add5(10)); // 15
    println!("{}", add100(10)); // 110

    let triple = make_multiplier(3);
    println!("{}", triple(7)); // 21

    // Closures in collections
    let operations: Vec<Box<dyn Fn(i32) -> i32>> = vec![
        Box::new(|x| x + 1),
        Box::new(|x| x * 2),
        Box::new(|x| x - 3),
    ];

    let mut val = 10;
    for op in &operations {
        val = op(val);
    }
    println!("{}", val); // (10+1)*2-3 = 19
}
