use std::fmt;

// Supertraits: a trait that requires another trait to be implemented first
// Syntax: trait Child: Parent { ... }
// The Child trait "inherits" the requirement of Parent

// --- Basic supertrait ---
trait Animal: fmt::Display {
    fn name(&self) -> &str;
    fn sound(&self) -> &str;

    // Can use Display methods since it's required
    fn describe(&self) -> String {
        format!("{} ({})", self, self.sound())
    }
}

struct Dog {
    name: String,
}

struct Cat {
    name: String,
}

// Must implement Display (the supertrait) before Animal
impl fmt::Display for Dog {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Dog({})", self.name)
    }
}

impl fmt::Display for Cat {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Cat({})", self.name)
    }
}

impl Animal for Dog {
    fn name(&self) -> &str {
        &self.name
    }
    fn sound(&self) -> &str {
        "woof"
    }
}

impl Animal for Cat {
    fn name(&self) -> &str {
        &self.name
    }
    fn sound(&self) -> &str {
        "meow"
    }
}

// --- Supertrait chains ---
#[allow(dead_code)]
trait Printable: fmt::Display + fmt::Debug {}

trait Named {
    fn name(&self) -> &str;
}

trait Greetable: Named + fmt::Display {
    fn greet(&self) -> String {
        format!("Hello, I'm {} ({})", self.name(), self)
    }
}

#[derive(Debug)]
struct Person {
    first: String,
    last: String,
}

impl fmt::Display for Person {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} {}", self.first, self.last)
    }
}

impl Named for Person {
    fn name(&self) -> &str {
        &self.first
    }
}

impl Greetable for Person {} // gets greet() for free via default impl
impl Printable for Person {} // marker — requires Display + Debug (both implemented)

// --- Multiple supertraits ---
trait Shape: fmt::Display + fmt::Debug {
    fn area(&self) -> f64;
    fn perimeter(&self) -> f64;

    fn summary(&self) -> String {
        format!(
            "{:?}: area={:.2}, perimeter={:.2}",
            self,
            self.area(),
            self.perimeter()
        )
    }
}

#[derive(Debug)]
struct Circle {
    radius: f64,
}

#[derive(Debug)]
struct Rectangle {
    width: f64,
    height: f64,
}

impl fmt::Display for Circle {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Circle(r={})", self.radius)
    }
}

impl fmt::Display for Rectangle {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Rectangle({}x{})", self.width, self.height)
    }
}

impl Shape for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.radius * self.radius
    }
    fn perimeter(&self) -> f64 {
        2.0 * std::f64::consts::PI * self.radius
    }
}

impl Shape for Rectangle {
    fn area(&self) -> f64 {
        self.width * self.height
    }
    fn perimeter(&self) -> f64 {
        2.0 * (self.width + self.height)
    }
}

fn print_shape(s: &dyn Shape) {
    println!("{}", s.summary());
}

fn main() {
    let dog = Dog {
        name: String::from("Rex"),
    };
    let cat = Cat {
        name: String::from("Whiskers"),
    };

    // Animal trait methods
    println!("{}", dog.name()); // Rex
    println!("{}", dog.sound()); // woof
    println!("{}", dog.describe()); // Dog(Rex) (woof)

    println!("{}", cat.describe()); // Cat(Whiskers) (meow)

    // Display (supertrait) also works directly
    println!("{}", dog); // Dog(Rex)
    println!("{}", cat); // Cat(Whiskers)

    // Person with chained supertraits
    let alice = Person {
        first: String::from("Alice"),
        last: String::from("Smith"),
    };

    println!("{}", alice); // Alice Smith
    println!("{:?}", alice); // Person { first: "Alice", last: "Smith" }
    println!("{}", alice.name()); // Alice
    println!("{}", alice.greet()); // Hello, I'm Alice (Alice Smith)

    // Shape trait with multiple supertraits
    let c = Circle { radius: 5.0 };
    let r = Rectangle {
        width: 4.0,
        height: 6.0,
    };

    print_shape(&c); // Circle(r=5): area=78.54, perimeter=31.42
    print_shape(&r); // Rectangle(4x6): area=24.00, perimeter=20.00

    // Can use Display and Debug since they're required by Shape
    println!("{}", c); // Circle(r=5)
    println!("{:?}", r); // Rectangle { width: 4.0, height: 6.0 }

    let shapes: Vec<Box<dyn Shape>> = vec![
        Box::new(Circle { radius: 3.0 }),
        Box::new(Rectangle {
            width: 2.0,
            height: 5.0,
        }),
        Box::new(Circle { radius: 1.0 }),
    ];

    for shape in &shapes {
        println!("{:.2}", shape.area());
    }
    // 28.27
    // 10.00
    // 3.14
}
