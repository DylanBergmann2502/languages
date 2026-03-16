use std::fmt;

trait Summary {
    fn summarize(&self) -> String;
}

// --- Trait bounds on generic functions ---

// Inline syntax
fn notify_inline<T: Summary>(item: &T) {
    println!("Notification: {}", item.summarize());
}

// Where clause syntax — cleaner for multiple bounds
fn notify_where<T>(item: &T)
where
    T: Summary + fmt::Debug,
{
    println!("Debug: {:?}", item);
    println!("Summary: {}", item.summarize());
}

// Multiple different type params with where
fn compare_and_display<T, U>(t: &T, u: &U)
where
    T: fmt::Display + PartialOrd,
    U: fmt::Display,
{
    println!("t = {}, u = {}", t, u);
}

// --- Trait bounds on structs ---
struct Wrapper<T: fmt::Display> {
    value: T,
}

impl<T: fmt::Display> Wrapper<T> {
    fn new(value: T) -> Self {
        Wrapper { value }
    }

    fn show(&self) {
        println!("Wrapper holds: {}", self.value);
    }
}

// --- Trait objects: Box<dyn Trait> ---
// Unlike impl Trait (compile-time), dyn Trait is dynamic dispatch (runtime)

struct Article {
    title: String,
}

struct Tweet {
    content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("Article: {}", self.title)
    }
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("Tweet: {}", self.content)
    }
}

impl fmt::Debug for Article {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Article({})", self.title)
    }
}

// Returns a Vec of different types that all implement Summary
// Only possible with Box<dyn Trait> — impl Trait can't do this
fn get_items(long: bool) -> Vec<Box<dyn Summary>> {
    if long {
        vec![
            Box::new(Article {
                title: String::from("Rust Generics"),
            }),
            Box::new(Tweet {
                content: String::from("loving traits!"),
            }),
        ]
    } else {
        vec![Box::new(Tweet {
            content: String::from("short post"),
        })]
    }
}

// impl Trait vs Box<dyn Trait>:
// - impl Trait: resolved at compile time, faster, but must be ONE concrete type
// - Box<dyn Trait>: resolved at runtime, heap allocation, can hold MIXED types

fn main() {
    let article = Article {
        title: String::from("Rust is Fast"),
    };
    let tweet = Tweet {
        content: String::from("just discovered trait bounds"),
    };

    // Inline trait bound
    notify_inline(&article); // Notification: Article: Rust is Fast
    notify_inline(&tweet); // Notification: Tweet: just discovered trait bounds

    // Where clause with multiple bounds
    notify_where(&article); // Debug: Article(Rust is Fast)
    // Summary: Article: Rust is Fast

    // Multiple type params
    compare_and_display(&42, &"hello"); // t = 42, u = hello
    compare_and_display(&3.14, &100); // t = 3.14, u = 100

    // Trait bound on struct
    let w1 = Wrapper::new(42);
    w1.show(); // Wrapper holds: 42

    let w2 = Wrapper::new("Rust");
    w2.show(); // Wrapper holds: Rust

    // Trait objects — mixed types in one collection
    let items = get_items(true);
    for item in &items {
        println!("{}", item.summarize());
    }
    // Article: Rust Generics
    // Tweet: loving traits!

    let short = get_items(false);
    for item in &short {
        println!("{}", item.summarize()); // Tweet: short post
    }
}
