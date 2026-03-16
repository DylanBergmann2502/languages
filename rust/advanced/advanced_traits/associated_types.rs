// Associated types: a way to declare a placeholder type inside a trait
// that implementors must specify.
//
// vs generics: trait Converter<T> allows MULTIPLE impls for one type
//              trait Converter with type Output allows only ONE impl per type

// --- Basic associated type ---
trait Convert {
    type Output; // implementor defines what Output is

    fn convert(&self) -> Self::Output;
}

struct Celsius(f64);
struct Fahrenheit(f64);
struct Kelvin(f64);

impl Convert for Celsius {
    type Output = Fahrenheit;

    fn convert(&self) -> Fahrenheit {
        Fahrenheit(self.0 * 9.0 / 5.0 + 32.0)
    }
}

impl Convert for Fahrenheit {
    type Output = Celsius;

    fn convert(&self) -> Celsius {
        Celsius((self.0 - 32.0) * 5.0 / 9.0)
    }
}

impl Convert for Kelvin {
    type Output = Celsius;

    fn convert(&self) -> Celsius {
        Celsius(self.0 - 273.15)
    }
}

// --- Iterator uses associated types ---
// trait Iterator { type Item; fn next(&mut self) -> Option<Self::Item>; }
// This is why you can write: .map(|x: i32| ...) without specifying types everywhere

struct Countdown {
    count: i32,
}

impl Countdown {
    fn new(start: i32) -> Self {
        Countdown { count: start }
    }
}

impl Iterator for Countdown {
    type Item = i32;

    fn next(&mut self) -> Option<i32> {
        if self.count > 0 {
            let val = self.count;
            self.count -= 1;
            Some(val)
        } else {
            None
        }
    }
}

// --- Associated types in function signatures ---
// Using the associated type in bounds
fn do_convert<T: Convert>(val: &T) -> T::Output {
    val.convert()
}

// --- Associated types with multiple traits ---
trait Container {
    type Item;

    fn first(&self) -> Option<&Self::Item>;
    fn last(&self) -> Option<&Self::Item>;
    fn len(&self) -> usize;
    fn is_empty(&self) -> bool {
        self.len() == 0
    }
}

struct Stack<T> {
    items: Vec<T>,
}

impl<T> Stack<T> {
    fn new() -> Self {
        Stack { items: vec![] }
    }

    fn push(&mut self, item: T) {
        self.items.push(item);
    }
}

impl<T> Container for Stack<T> {
    type Item = T;

    fn first(&self) -> Option<&T> {
        self.items.first()
    }

    fn last(&self) -> Option<&T> {
        self.items.last()
    }

    fn len(&self) -> usize {
        self.items.len()
    }
}

fn print_ends<C: Container>(c: &C)
where
    C::Item: std::fmt::Debug,
{
    println!("first: {:?}, last: {:?}", c.first(), c.last());
}

fn main() {
    // Temperature conversion
    let boiling = Celsius(100.0);
    let f = boiling.convert();
    println!("{:.1}", f.0); // 212.0

    let freezing = Fahrenheit(32.0);
    let c = freezing.convert();
    println!("{:.1}", c.0); // 0.0

    let absolute = Kelvin(373.15);
    let c2 = absolute.convert();
    println!("{:.2}", c2.0); // 100.00

    // do_convert uses T::Output in return type
    let temp = Celsius(37.0);
    let body_f = do_convert(&temp);
    println!("{:.1}", body_f.0); // 98.6

    // Custom iterator with associated type
    let countdown = Countdown::new(5);
    let v: Vec<i32> = countdown.collect();
    println!("{:?}", v); // [5, 4, 3, 2, 1]

    let sum: i32 = Countdown::new(10).sum();
    println!("{}", sum); // 55

    let doubled: Vec<i32> = Countdown::new(4).map(|x| x * 2).collect();
    println!("{:?}", doubled); // [8, 6, 4, 2]

    // Container trait
    let mut stack: Stack<i32> = Stack::new();
    println!("{}", stack.is_empty()); // true

    stack.push(10);
    stack.push(20);
    stack.push(30);

    println!("{}", stack.len()); // 3
    println!("{}", stack.is_empty()); // false
    print_ends(&stack); // first: Some(10), last: Some(30)

    let mut words: Stack<&str> = Stack::new();
    words.push("hello");
    words.push("world");
    print_ends(&words); // first: Some("hello"), last: Some("world")
}
