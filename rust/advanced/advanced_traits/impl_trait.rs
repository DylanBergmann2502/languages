use std::fmt;

// impl Trait: a concise way to use traits in argument and return positions
// Two uses:
//   1. Argument position: fn foo(x: impl Trait)  — sugar for <T: Trait>(x: T)
//   2. Return position:   fn foo() -> impl Trait  — returns some type that implements Trait

trait Summary {
    fn summarize(&self) -> String;
}

trait Drawable {
    fn draw(&self);
}

#[derive(Debug)]
struct Article {
    title: String,
    author: String,
}
#[derive(Debug)]
struct Tweet {
    user: String,
    content: String,
}
#[derive(Debug)]
struct Circle {
    radius: f64,
}
#[derive(Debug)]
struct Square {
    side: f64,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{} by {}", self.title, self.author)
    }
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("@{}: {}", self.user, self.content)
    }
}

impl Drawable for Circle {
    fn draw(&self) {
        println!("drawing circle r={}", self.radius);
    }
}

impl Drawable for Square {
    fn draw(&self) {
        println!("drawing square s={}", self.side);
    }
}

// --- Argument position ---
// impl Trait (concise)
fn notify(item: &impl Summary) {
    println!("{}", item.summarize());
}

// Equivalent with explicit generic (more verbose but allows multiple params of same type)
fn notify_generic<T: Summary>(item: &T) {
    println!("{}", item.summarize());
}

// Multiple trait bounds in argument position
fn notify_debug(item: &(impl Summary + fmt::Debug)) {
    println!("{:?} -> {}", item, item.summarize());
}

// Two params: impl Trait allows different concrete types
fn compare(a: &impl Summary, b: &impl Summary) {
    println!("{} | {}", a.summarize(), b.summarize());
}

// Two params: generic requires SAME concrete type
fn compare_same<T: Summary>(a: &T, b: &T) {
    println!("{} | {}", a.summarize(), b.summarize());
}

// --- Return position ---
// Returns some type implementing Summary — caller doesn't know the concrete type
fn make_article(title: &str, author: &str) -> impl Summary {
    Article {
        title: title.to_string(),
        author: author.to_string(),
    }
}

// Useful for returning closures without boxing
fn make_adder(n: i32) -> impl Fn(i32) -> i32 {
    move |x| x + n
}

fn make_multiplier(n: i32) -> impl Fn(i32) -> i32 {
    move |x| x * n
}

// Returning iterators — avoids complex type names
fn evens_up_to(n: i32) -> impl Iterator<Item = i32> {
    (0..=n).filter(|x| x % 2 == 0)
}

fn squares(v: Vec<i32>) -> impl Iterator<Item = i32> {
    v.into_iter().map(|x| x * x)
}

// --- impl Trait vs Box<dyn Trait> ---
// impl Trait: compile-time, no heap, single concrete type per call site
// Box<dyn Trait>: runtime dispatch, heap allocation, can hold mixed types

// This works with Box<dyn Trait> (mixed types in Vec)
fn make_drawables() -> Vec<Box<dyn Drawable>> {
    vec![
        Box::new(Circle { radius: 3.0 }),
        Box::new(Square { side: 4.0 }),
        Box::new(Circle { radius: 1.0 }),
    ]
}

// impl Trait can't return different concrete types conditionally:
// fn bad(flag: bool) -> impl Summary {
//     if flag { Article { ... } } else { Tweet { ... } }  // ERROR: mismatched types
// }
// For that, use Box<dyn Trait>

fn main() {
    let article = Article {
        title: String::from("Rust Rocks"),
        author: String::from("Alice"),
    };
    let tweet = Tweet {
        user: String::from("bob"),
        content: String::from("loving impl Trait"),
    };

    // Argument position
    notify(&article); // Rust Rocks by Alice
    notify(&tweet); // @bob: loving impl Trait

    notify_generic(&article); // Rust Rocks by Alice

    notify_debug(&article); // Article { .. } -> Rust Rocks by Alice
    notify_debug(&tweet); // Tweet { .. } -> @bob: loving impl Trait

    // impl Trait allows mixed types
    compare(&article, &tweet); // Rust Rocks by Alice | @bob: loving impl Trait

    // Generic requires same type
    let article2 = Article {
        title: String::from("More Rust"),
        author: String::from("Carol"),
    };
    compare_same(&article, &article2); // Rust Rocks by Alice | More Rust by Carol

    // Return position
    let a = make_article("The Future of Rust", "Dave");
    println!("{}", a.summarize()); // The Future of Rust by Dave

    let add10 = make_adder(10);
    let add100 = make_adder(100);
    println!("{}", add10(5)); // 15
    println!("{}", add100(5)); // 105

    let triple = make_multiplier(3);
    println!("{}", triple(7)); // 21

    // Returning iterators
    let evens: Vec<i32> = evens_up_to(10).collect();
    println!("{:?}", evens); // [0, 2, 4, 6, 8, 10]

    let sq: Vec<i32> = squares(vec![1, 2, 3, 4, 5]).collect();
    println!("{:?}", sq); // [1, 4, 9, 16, 25]

    // Box<dyn Trait> for mixed types
    let drawables = make_drawables();
    for d in &drawables {
        d.draw();
    }
    // drawing circle r=3
    // drawing square s=4
    // drawing circle r=1
}
