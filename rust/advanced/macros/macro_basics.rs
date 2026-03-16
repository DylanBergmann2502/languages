// Declarative macros with macro_rules!
// Macros operate on syntax — they run before the compiler checks types
// Think of them as pattern-matching on code, then generating code

// --- Basic macro ---
macro_rules! say_hello {
    () => {
        println!("Hello!");
    };
}

// --- Macro with arguments ---
macro_rules! greet {
    ($name:expr) => {
        println!("Hello, {}!", $name)
    };
}

// --- Multiple patterns (like match arms) ---
macro_rules! log {
    // One argument — info level
    ($msg:expr) => {
        println!("[INFO] {}", $msg)
    };
    // Two arguments — custom level
    ($level:expr, $msg:expr) => {
        println!("[{}] {}", $level, $msg)
    };
}

// --- Repetition with $(...),* ---
// $(...),* means: repeat the pattern, separated by commas, zero or more times
macro_rules! make_vec {
    ($($x:expr),*) => {
        {
            #[allow(unused_mut)]
            let mut v = Vec::new();
            $(v.push($x);)*
            v
        }
    };
}

// --- Repetition with $(...);+ (one or more, semicolon separated) ---
macro_rules! print_all {
    ($($x:expr);+) => {
        $( println!("{}", $x); )+
    };
}

// --- Macro that generates a function ---
macro_rules! make_fn {
    ($name:ident, $param:ident, $type:ty, $body:expr) => {
        fn $name($param: $type) -> $type {
            $body
        }
    };
}

make_fn!(double, x, i32, x * 2);
make_fn!(square, x, i32, x * x);
make_fn!(negate, x, f64, -x);

// --- Macro that generates a struct ---
macro_rules! make_point {
    ($name:ident, $type:ty) => {
        #[derive(Debug)]
        struct $name {
            x: $type,
            y: $type,
        }

        impl $name {
            fn new(x: $type, y: $type) -> Self {
                $name { x, y }
            }

            fn distance_from_origin(&self) -> f64 {
                ((self.x as f64).powi(2) + (self.y as f64).powi(2)).sqrt()
            }
        }
    };
}

make_point!(Point2D, f64);
make_point!(IntPoint, i32);

// --- Macro with multiple fragment specifiers ---
// :expr  — an expression
// :ident — an identifier (variable or function name)
// :ty    — a type
// :stmt  — a statement
// :pat   — a pattern
// :block — a block {}
// :tt    — a single token tree (anything)
// :literal — a literal value

macro_rules! assert_approx_eq {
    ($a:expr, $b:expr, $tol:expr) => {
        let diff = (($a as f64) - ($b as f64)).abs();
        assert!(
            diff < $tol,
            "assert_approx_eq failed: |{} - {}| = {} >= {}",
            $a,
            $b,
            diff,
            $tol
        );
    };
    // Default tolerance
    ($a:expr, $b:expr) => {
        assert_approx_eq!($a, $b, 1e-6)
    };
}

// --- Recursive macro ---
macro_rules! sum {
    ($x:expr) => { $x };
    ($x:expr, $($rest:expr),+) => {
        $x + sum!($($rest),+)
    };
}

fn main() {
    // Basic macros
    say_hello!(); // Hello!
    greet!("Alice"); // Hello, Alice!
    greet!(String::from("Bob")); // Hello, Bob!

    // Multiple patterns
    log!("server started"); // [INFO] server started
    log!("WARN", "disk space low"); // [WARN] disk space low
    log!("ERROR", "connection failed"); // [ERROR] connection failed

    // make_vec — like vec! from std
    let v = make_vec![1, 2, 3, 4, 5];
    println!("{:?}", v); // [1, 2, 3, 4, 5]

    let empty: Vec<i32> = make_vec![];
    println!("{:?}", empty); // []

    // print_all — semicolon separated
    print_all!("apple"; "banana"; "cherry");
    // apple
    // banana
    // cherry

    // Generated functions
    println!("{}", double(7)); // 14
    println!("{}", square(5)); // 25
    println!("{:.1}", negate(3.14)); // -3.14

    // Generated structs
    let p = Point2D::new(3.0, 4.0);
    println!("{:?}", p); // Point2D { x: 3.0, y: 4.0 }
    println!("{:.1}", p.distance_from_origin()); // 5.0

    let ip = IntPoint::new(0, 5);
    println!("{:?}", ip); // IntPoint { x: 0, y: 5 }
    println!("{:.1}", ip.distance_from_origin()); // 5.0

    // assert_approx_eq
    assert_approx_eq!(0.1 + 0.2, 0.3, 1e-10); // passes
    assert_approx_eq!(3.14159, std::f64::consts::PI, 0.001); // passes
    println!("approx assertions passed"); // approx assertions passed

    // Recursive macro
    println!("{}", sum!(1)); // 1
    println!("{}", sum!(1, 2, 3)); // 6
    println!("{}", sum!(1, 2, 3, 4, 5)); // 15

    // Built-in macros you already know
    println!("{}", format!("{} + {} = {}", 1, 2, 3)); // 1 + 2 = 3
    let v2: Vec<i32> = vec![1, 2, 3];
    println!("{:?}", v2); // [1, 2, 3]
}
