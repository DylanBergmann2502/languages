// Defining a trait
trait Summary {
    fn summarize(&self) -> String;

    // Default implementation — can be overridden
    fn preview(&self) -> String {
        format!("{}...", &self.summarize()[..20.min(self.summarize().len())])
    }
}

trait Greet {
    fn greet(&self) -> String {
        String::from("Hello!")
    }
}

struct Article {
    title: String,
    author: String,
    content: String,
}

struct Tweet {
    username: String,
    content: String,
}

// Implementing traits on types
impl Summary for Article {
    fn summarize(&self) -> String {
        format!(
            "{}, by {} — {}",
            self.title,
            self.author,
            &self.content[..20.min(self.content.len())]
        )
    }
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }

    // Override the default preview
    fn preview(&self) -> String {
        format!("@{} tweeted: {}", self.username, self.content)
    }
}

impl Greet for Article {} // Uses default greet()

// impl Trait syntax — accept any type that implements Summary
fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

// Returning impl Trait
fn make_tweet(user: &str, msg: &str) -> impl Summary {
    Tweet {
        username: String::from(user),
        content: String::from(msg),
    }
}

// Implementing multiple traits
trait Drawable {
    fn draw(&self);
}

trait Resizable {
    fn resize(&mut self, factor: f64);
}

struct Circle {
    radius: f64,
}

impl Drawable for Circle {
    fn draw(&self) {
        println!("Drawing circle with radius {}", self.radius);
    }
}

impl Resizable for Circle {
    fn resize(&mut self, factor: f64) {
        self.radius *= factor;
    }
}

fn main() {
    let article = Article {
        title: String::from("Rust is Amazing"),
        author: String::from("Alice"),
        content: String::from("Rust provides memory safety without GC."),
    };

    let tweet = Tweet {
        username: String::from("bob"),
        content: String::from("Loving Rust so far!"),
    };

    // Calling trait methods
    println!("{}", article.summarize()); // Rust is Amazing, by Alice
    println!("{}", tweet.summarize()); // bob: Loving Rust so far!

    // Default implementation
    println!("{}", article.preview()); // Rust is Amazing, by ...
    // Overridden default
    println!("{}", tweet.preview()); // @bob tweeted: Loving Rust so far!

    // Default greet
    println!("{}", article.greet()); // Hello!

    // impl Trait as parameter
    notify(&article); // Breaking news! Rust is Amazing, by Alice
    notify(&tweet); // Breaking news! bob: Loving Rust so far!

    // Returning impl Trait
    let t = make_tweet("carol", "traits are cool");
    println!("{}", t.summarize()); // carol: traits are cool

    // Multiple traits
    let mut circle = Circle { radius: 5.0 };
    circle.draw(); // Drawing circle with radius 5
    circle.resize(2.0);
    circle.draw(); // Drawing circle with radius 10
}
