// Generic functions
fn largest<T: PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in list {
        if item > largest {
            largest = item;
        }
    }
    largest
}

fn first<T>(list: &[T]) -> &T {
    &list[0]
}

// Generic structs
struct Pair<T> {
    first: T,
    second: T,
}

struct Point<T, U> {
    x: T,
    y: U,
}

// Generic impl
impl<T: std::fmt::Display + PartialOrd> Pair<T> {
    fn new(first: T, second: T) -> Self {
        Pair { first, second }
    }

    fn larger(&self) -> &T {
        if self.first > self.second {
            &self.first
        } else {
            &self.second
        }
    }
}

impl<T: std::fmt::Display, U: std::fmt::Display> Point<T, U> {
    fn new(x: T, y: U) -> Self {
        Point { x, y }
    }

    fn display(&self) {
        println!("({}, {})", self.x, self.y);
    }
}

// Generic enum (like Option and Result in std)
enum MyOption<T> {
    Some(T),
    None,
}

enum MyResult<T, E> {
    Ok(T),
    Err(E),
}

fn divide(a: f64, b: f64) -> MyResult<f64, String> {
    if b == 0.0 {
        MyResult::Err(String::from("Cannot divide by zero"))
    } else {
        MyResult::Ok(a / b)
    }
}

fn main() {
    // Generic functions
    let numbers = vec![34, 50, 25, 100, 65];
    println!("{}", largest(&numbers)); // 100

    let chars = vec!['y', 'm', 'a', 'q'];
    println!("{}", largest(&chars)); // y

    let words = vec!["hello", "world", "rust"];
    println!("{}", first(&words)); // hello

    // Generic structs
    let pair = Pair::new(10, 20);
    println!("{}", pair.larger()); // 20

    let str_pair = Pair::new("apple", "zebra");
    println!("{}", str_pair.larger()); // zebra

    let point_int = Point::new(5, 10);
    point_int.display(); // (5, 10)

    let point_mixed = Point::new(3.14, "hello");
    point_mixed.display(); // (3.14, hello)

    // Generic enum
    let some_val: MyOption<i32> = MyOption::Some(42);
    let none_val: MyOption<i32> = MyOption::None;
    match none_val {
        MyOption::Some(v) => println!("{}", v),
        MyOption::None => println!("nothing"), // nothing
    }

    match some_val {
        MyOption::Some(v) => println!("{}", v), // 42
        MyOption::None => println!("nothing"),
    }

    match divide(10.0, 2.0) {
        MyResult::Ok(v) => println!("{}", v), // 5
        MyResult::Err(e) => println!("{}", e),
    }

    match divide(10.0, 0.0) {
        MyResult::Ok(v) => println!("{}", v),
        MyResult::Err(e) => println!("{}", e), // Cannot divide by zero
    }

    // Generics are monomorphized at compile time — zero runtime cost
    // Vec<T>, HashMap<K,V>, Option<T>, Result<T,E> are all generic types from std
    let mut stack: Vec<i32> = Vec::new();
    stack.push(1);
    stack.push(2);
    stack.push(3);
    println!("{:?}", stack); // [1, 2, 3]
    println!("{:?}", stack.pop()); // Some(3)
}
