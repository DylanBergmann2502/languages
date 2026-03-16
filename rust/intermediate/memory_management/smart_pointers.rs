use std::fmt;
use std::ops::Deref;

// Smart pointers: own data + have metadata + implement Deref and Drop
// Built-in: Box<T>, Rc<T>, Arc<T>, RefCell<T>, Cell<T>, Cow<T>
// You can build your own by implementing Deref and Drop

// --- Custom smart pointer ---
struct MyBox<T: fmt::Display>(T);

impl<T: fmt::Display> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}

// Implement Deref so *mybox works like *Box
impl<T: fmt::Display> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.0
    }
}

// Implement Drop to run cleanup code when value goes out of scope
impl<T: fmt::Display> Drop for MyBox<T> {
    fn drop(&mut self) {
        println!("Dropping MyBox with value: {}", self.0);
    }
}

// --- Deref coercions ---
// &MyBox<String> -> &String -> &str (automatic chain)
fn print_str(s: &str) {
    println!("{}", s);
}

fn print_len(s: &str) {
    println!("length: {}", s.len());
}

// --- A resource that needs explicit cleanup ---
struct Connection {
    host: String,
}

impl Connection {
    fn new(host: &str) -> Self {
        println!("Connecting to {}", host);
        Connection {
            host: host.to_string(),
        }
    }

    fn query(&self, q: &str) -> String {
        format!("Result from {}: {}", self.host, q)
    }
}

impl Drop for Connection {
    fn drop(&mut self) {
        println!("Closing connection to {}", self.host);
    }
}

fn main() {
    // --- Deref: dereferencing smart pointers ---
    let x = 5;
    let y = MyBox::new(x);

    println!("{}", x == 5); // true
    println!("{}", *y == 5); // true  (*y calls deref())

    let boxed = Box::new(10);
    println!("{}", *boxed + 5); // 15

    // Deref coercions — Rust auto-applies deref to match expected types
    let hello = MyBox::new(String::from("hello"));
    print_str(&hello); // hello  (&MyBox<String> -> &String -> &str)
    print_len(&hello); // length: 5

    let s = Box::new(String::from("world"));
    print_str(&s); // world  (&Box<String> -> &String -> &str)

    // --- Drop: cleanup on scope exit ---
    {
        let conn = Connection::new("db.example.com");
        // Connecting to db.example.com
        println!("{}", conn.query("SELECT 1")); // Result from db.example.com: SELECT 1
    } // Closing connection to db.example.com

    // std::mem::drop — force early drop
    let conn2 = Connection::new("cache.example.com");
    // Connecting to cache.example.com
    println!("{}", conn2.query("GET key")); // Result from cache.example.com: GET key
    drop(conn2); // Closing connection to cache.example.com
    println!("connection already closed"); // connection already closed

    // --- MyBox with Drop ---
    {
        let a = MyBox::new(String::from("alpha"));
        let b = MyBox::new(String::from("beta"));
        println!("{} {}", *a, *b); // alpha beta
                                   // Drop order is reverse of creation: beta first, then alpha
    }
    // Dropping MyBox with value: beta
    // Dropping MyBox with value: alpha

    // --- Cow<T>: Clone-on-Write ---
    // Borrowed data until mutation is needed, then clones
    use std::borrow::Cow;

    fn ensure_no_spaces(s: &str) -> Cow<'_, str> {
        if s.contains(' ') {
            Cow::Owned(s.replace(' ', "_")) // had to allocate
        } else {
            Cow::Borrowed(s) // no allocation needed
        }
    }

    let no_spaces = ensure_no_spaces("hello");
    let with_spaces = ensure_no_spaces("hello world");

    println!("{}", no_spaces); // hello   (borrowed, no alloc)
    println!("{}", with_spaces); // hello_world  (owned, allocated)

    // Cow is useful when you might or might not need to modify data
    let items: Vec<Cow<str>> = vec!["clean", "needs fix", "fine"]
        .into_iter()
        .map(ensure_no_spaces)
        .collect();

    for item in &items {
        println!("{}", item);
    }
    // clean
    // needs_fix
    // fine
}
