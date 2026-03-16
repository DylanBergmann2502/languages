// Common macro patterns and best practices

// --- Pattern: tt muncher (token tree eater) ---
// Processes tokens one at a time recursively
macro_rules! count {
    () => { 0 };
    ($head:tt $($tail:tt)*) => { 1 + count!($($tail)*) };
}

// --- Pattern: callback / continuation ---
macro_rules! with_value {
    ($val:expr, $callback:ident) => {
        $callback($val)
    };
}

// --- Pattern: builder / DSL ---
macro_rules! html {
    (p { $content:expr }) => {
        format!("<p>{}</p>", $content)
    };
    (h1 { $content:expr }) => {
        format!("<h1>{}</h1>", $content)
    };
    (div { $($child:expr);+ }) => {
        format!("<div>{}</div>", vec![$($child),+].join(""))
    };
}

// --- Pattern: map literal ---
macro_rules! hashmap {
    ($($key:expr => $val:expr),* $(,)?) => {
        {
            let mut m = std::collections::HashMap::new();
            $(m.insert($key, $val);)*
            m
        }
    };
}

// --- Pattern: generate multiple similar items ---
macro_rules! impl_from_number {
    ($($t:ty),+) => {
        $(
            impl From<$t> for MyNum {
                fn from(val: $t) -> MyNum {
                    MyNum(val as f64)
                }
            }
        )+
    };
}

#[derive(Debug)]
#[allow(dead_code)]
struct MyNum(f64);
impl_from_number!(i32, i64, u32, u64, f32);

// --- Pattern: conditional compilation helper ---
macro_rules! debug_print {
    ($($arg:tt)*) => {
        #[cfg(debug_assertions)]
        println!("[DEBUG] {}", format!($($arg)*));
    };
}

// --- Pattern: retry logic ---
#[allow(unused_macros)]
macro_rules! retry {
    ($times:expr, $block:block) => {{
        let mut success = false;
        for attempt in 1..=$times {
            let result: Result<_, String> = (|| Ok($block))();
            if result.is_ok() {
                success = true;
                println!("succeeded on attempt {}", attempt);
                break;
            }
        }
        success
    }};
}

// --- Pattern: early return with logging ---
macro_rules! try_or_log {
    ($expr:expr, $msg:expr) => {
        match $expr {
            Some(v) => v,
            None => {
                println!("[WARN] {}", $msg);
                return;
            }
        }
    };
}

fn find_first_even(nums: &[i32]) {
    let first_even = try_or_log!(nums.iter().find(|&&x| x % 2 == 0), "no even number found");
    println!("first even: {}", first_even);
}

// --- Best practices ---
// 1. Prefer functions over macros when possible — easier to read and debug
// 2. Document your macros — they're harder to understand than functions
// 3. Use $(,)? at the end of repetitions to allow trailing commas
// 4. Keep macro scope narrow — export with #[macro_export] only when needed
// 5. Use descriptive names for metavariables ($key, $val vs $x, $y)

fn main() {
    // tt muncher counter
    println!("{}", count!()); // 0
    println!("{}", count!(a b c)); // 3
    println!("{}", count!(x x x x x)); // 5

    // callback
    fn double(x: i32) -> i32 {
        x * 2
    }
    println!("{}", with_value!(21, double)); // 42

    // html DSL
    println!("{}", html!(p { "Hello World" })); // <p>Hello World</p>
    println!("{}", html!(h1 { "My Title" })); // <h1>My Title</h1>
    let div = html!(div {
        html!(p { "first" });
        html!(p { "second" })
    });
    println!("{}", div); // <div><p>first</p><p>second</p></div>

    // hashmap literal
    let scores = hashmap! {
        "alice" => 95,
        "bob"   => 87,
        "carol" => 92,
    };
    println!("{}", scores["alice"]); // 95
    println!("{}", scores["bob"]); // 87

    // trailing comma allowed
    let m = hashmap! { "a" => 1, "b" => 2, };
    println!("{}", m.len()); // 2

    // impl_from_number
    let n1 = MyNum::from(42i32);
    let n2 = MyNum::from(3.14f32);
    let n3 = MyNum::from(100u64);
    println!("{:?}", n1); // MyNum(42.0)
    println!("{:.2?}", n2); // MyNum(3.14)
    println!("{:?}", n3); // MyNum(100.0)

    // debug_print (only prints in debug builds)
    debug_print!("x = {}, y = {}", 10, 20); // [DEBUG] x = 10, y = 20

    // try_or_log
    find_first_even(&[1, 3, 4, 6]); // first even: 4
    find_first_even(&[1, 3, 5, 7]); // [WARN] no even number found

    println!("done"); // done
}
