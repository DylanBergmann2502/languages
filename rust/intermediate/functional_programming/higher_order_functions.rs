// Higher-order functions: functions that take or return other functions

// Takes a function as parameter (fn pointer — for non-capturing functions)
fn apply(f: fn(i32) -> i32, x: i32) -> i32 {
    f(x)
}

// Takes a generic closure (more flexible than fn pointers)
fn apply_closure<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 {
    f(x)
}

// Takes a Vec and a transformation function
fn transform(v: &[i32], f: impl Fn(i32) -> i32) -> Vec<i32> {
    v.iter().map(|&x| f(x)).collect()
}

// Takes a Vec and a predicate function
fn keep_if(v: &[i32], pred: impl Fn(i32) -> bool) -> Vec<i32> {
    v.iter().filter(|&&x| pred(x)).copied().collect()
}

// Takes a Vec, accumulator, and reducer function
fn reduce(v: &[i32], init: i32, f: impl Fn(i32, i32) -> i32) -> i32 {
    v.iter().fold(init, |acc, &x| f(acc, x))
}

// Returns a function — function factory
fn make_adder(n: i32) -> impl Fn(i32) -> i32 {
    move |x| x + n
}

fn make_between(low: i32, high: i32) -> impl Fn(i32) -> bool {
    move |x| x >= low && x <= high
}

// Function composition — returns a new function that chains two
fn compose<A, B, C>(f: impl Fn(A) -> B, g: impl Fn(B) -> C) -> impl Fn(A) -> C {
    move |x| g(f(x))
}

// Named functions (fn pointers) can also be passed directly
fn double(x: i32) -> i32 {
    x * 2
}
fn is_even(x: i32) -> bool {
    x % 2 == 0
}
fn square(x: i32) -> i32 {
    x * x
}

fn main() {
    let nums = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // Passing named functions
    println!("{}", apply(double, 5)); // 10
    println!("{}", apply(square, 4)); // 16

    // Passing closures
    println!("{}", apply_closure(|x| x + 100, 5)); // 105

    // transform — map with a custom function
    println!("{:?}", transform(&nums, double)); // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
    println!("{:?}", transform(&nums, square)); // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
    println!("{:?}", transform(&nums, |x| x + 10)); // [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    // keep_if — filter with a custom predicate
    println!("{:?}", keep_if(&nums, is_even)); // [2, 4, 6, 8, 10]
    println!("{:?}", keep_if(&nums, |x| x > 5)); // [6, 7, 8, 9, 10]
    println!("{:?}", keep_if(&nums, |x| x % 3 == 0)); // [3, 6, 9]

    // reduce — fold with a custom reducer
    println!("{}", reduce(&nums, 0, |acc, x| acc + x)); // 55  (sum)
    println!("{}", reduce(&nums, 1, |acc, x| acc * x)); // 3628800  (product)
    println!("{}", reduce(&nums, i32::MIN, |acc, x| acc.max(x))); // 10  (max)

    // Function factories
    let add5 = make_adder(5);
    let add100 = make_adder(100);
    println!("{}", add5(10)); // 15
    println!("{}", add100(10)); // 110
    println!("{:?}", transform(&nums, add5)); // [6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

    let is_teen = make_between(13, 19);
    println!("{}", is_teen(15)); // true
    println!("{}", is_teen(25)); // false
    println!("{:?}", keep_if(&nums, make_between(3, 7))); // [3, 4, 5, 6, 7]

    // Function composition
    let double_then_square = compose(double, square);
    println!("{}", double_then_square(3)); // (3*2)^2 = 36

    let square_then_double = compose(square, double);
    println!("{}", square_then_double(3)); // (3^2)*2 = 18

    // Chaining multiple operations (functional pipeline)
    let result: i32 = nums
        .iter()
        .copied()
        .filter(|&x| x % 2 == 0) // keep evens: [2, 4, 6, 8, 10]
        .map(|x| x * x) // square them: [4, 16, 36, 64, 100]
        .filter(|&x| x > 20) // keep > 20:   [36, 64, 100]
        .sum(); // sum: 200
    println!("{}", result); // 200

    // Storing functions in a Vec
    let pipeline: Vec<Box<dyn Fn(i32) -> i32>> =
        vec![Box::new(|x| x + 1), Box::new(double), Box::new(square)];

    let val = pipeline.iter().fold(3, |acc, f| f(acc));
    println!("{}", val); // ((3+1)*2)^2 = 64
}
