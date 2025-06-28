// Structs in Rust are custom data types that group related data together
// They're similar to classes in other languages but without inheritance
// Structs are defined at compile-time and all fields must be known
// They support pattern matching and can have methods
// Ownership rules apply to struct fields

// Basic struct definition
#[derive(Debug)] // This allows us to print the struct using {:?}
struct Person {
    name: String,
    age: u32,
    email: String,
    is_active: bool,
}

// Struct with different field types
#[derive(Debug)]
struct Rectangle {
    width: f64,
    height: f64,
}

// Tuple struct (structs with unnamed fields)
#[derive(Debug)]
struct Color(u8, u8, u8); // RGB values

#[derive(Debug)]
struct Point(f64, f64); // x, y coordinates

// Unit struct (struct with no fields)
#[derive(Debug)]
struct Unit;

fn main() {
    println!("=== Basic Struct Creation ===");

    // Creating struct instances
    let person1 = Person {
        name: String::from("Alice"),
        age: 30,
        email: String::from("alice@example.com"),
        is_active: true,
    };
    println!("Person1: {:?}", person1);
    // Person1: Person { name: "Alice", age: 30, email: "alice@example.com", is_active: true }

    // Field order doesn't matter when creating structs
    let person2 = Person {
        email: String::from("bob@example.com"),
        name: String::from("Bob"),
        is_active: false,
        age: 25,
    };
    println!("Person2: {:?}", person2);
    // Person2: Person { name: "Bob", age: 25, email: "bob@example.com", is_active: false }

    println!("\n=== Accessing Struct Fields ===");

    // Accessing fields using dot notation
    println!("Person1's name: {}", person1.name); // Person1's name: Alice
    println!("Person1's age: {}", person1.age); // Person1's age: 30
    println!("Person2 is active: {}", person2.is_active); // Person2 is active: false

    println!("\n=== Mutable Structs ===");

    // To modify struct fields, the entire struct must be mutable
    let mut person3 = Person {
        name: String::from("Charlie"),
        age: 28,
        email: String::from("charlie@example.com"),
        is_active: true,
    };

    println!("Before update: {:?}", person3);
    // Before update: Person { name: "Charlie", age: 28, email: "charlie@example.com", is_active: true }

    person3.age = 29;
    person3.email = String::from("charlie.updated@example.com");

    println!("After update: {:?}", person3);
    // After update: Person { name: "Charlie", age: 29, email: "charlie.updated@example.com", is_active: true }

    println!("\n=== Struct Update Syntax ===");

    // Create a new struct using existing struct values
    let person4 = Person {
        name: String::from("Diana"),
        age: 32,
        ..person1 // Use remaining fields from person1
    };
    println!("Person4: {:?}", person4);
    // Person4: Person { name: "Diana", age: 32, email: "alice@example.com", is_active: true }

    // Note: person1 is moved here because email field contains String (heap data)
    // println!("Person1 after move: {:?}", person1); // This would cause a compile error

    println!("\n=== Creating Structs with Functions ===");

    // Function that returns a struct
    fn build_person(name: String, age: u32) -> Person {
        let email = format!("{}@company.com", name.to_lowercase());
        Person {
            name,
            age,
            email,
            is_active: true,
        }
    }

    let employee = build_person(String::from("Eve"), 26);
    println!("Employee: {:?}", employee);
    // Employee: Person { name: "Eve", age: 26, email: "eve@company.com", is_active: true }

    println!("\n=== Tuple Structs ===");

    // Tuple structs - useful when you want to name a tuple type
    let red = Color(255, 0, 0);
    let green = Color(0, 255, 0);
    let blue = Color(0, 0, 255);

    println!("Red color: {:?}", red); // Red color: Color(255, 0, 0)
    println!("Green color: {:?}", green); // Green color: Color(0, 255, 0)
    println!("Blue color: {:?}", blue); // Blue color: Color(0, 0, 255)

    // Accessing tuple struct fields by index
    println!("Red RGB values: ({}, {}, {})", red.0, red.1, red.2);
    // Red RGB values: (255, 0, 0)

    // Destructuring tuple structs
    let Color(r, g, b) = red;
    println!("Destructured red: R={}, G={}, B={}", r, g, b);
    // Destructured red: R=255, G=0, B=0

    let origin = Point(0.0, 0.0);
    let point1 = Point(3.0, 4.0);

    println!("Origin: {:?}", origin); // Origin: Point(0.0, 0.0)
    println!("Point1: {:?}", point1); // Point1: Point(3.0, 4.0)

    println!("\n=== Unit Structs ===");

    // Unit structs - structs with no data
    // Useful for implementing traits or as markers
    let unit_instance = Unit;
    println!("Unit struct: {:?}", unit_instance); // Unit struct: Unit

    println!("\n=== Pattern Matching with Structs ===");

    // Pattern matching in match expressions
    fn describe_person(person: &Person) -> String {
        match person.age {
            0..=17 => format!("{} is a minor", person.name),
            18..=64 => format!("{} is an adult", person.name),
            _ => format!("{} is a senior", person.name),
        }
    }

    let young_person = Person {
        name: String::from("Frank"),
        age: 16,
        email: String::from("frank@school.com"),
        is_active: true,
    };

    let senior_person = Person {
        name: String::from("Grace"),
        age: 70,
        email: String::from("grace@retired.com"),
        is_active: false,
    };

    println!("{}", describe_person(&young_person)); // Frank is a minor
    println!("{}", describe_person(&employee)); // Eve is an adult
    println!("{}", describe_person(&senior_person)); // Grace is a senior

    // Destructuring in let statements
    let Person { name, age, .. } = employee;
    println!("Destructured - Name: {}, Age: {}", name, age);
    // Destructured - Name: Eve, Age: 26

    println!("\n=== Struct with References (Advanced) ===");

    // Structs can contain references, but need lifetime annotations
    // This is more advanced - for now, we use owned data

    #[derive(Debug)]
    struct Book {
        title: String,
        author: String,
        pages: u32,
        available: bool,
    }

    let book = Book {
        title: String::from("The Rust Programming Language"),
        author: String::from("Steve Klabnik and Carol Nichols"),
        pages: 552,
        available: true,
    };

    println!("Book: {:?}", book);
    // Book: Book { title: "The Rust Programming Language", author: "Steve Klabnik and Carol Nichols", pages: 552, available: true }

    // Function that takes struct by reference (borrowing)
    fn print_book_info(book: &Book) {
        println!(
            "\"{}\" by {} ({} pages)",
            book.title, book.author, book.pages
        );
    }

    print_book_info(&book);
    // "The Rust Programming Language" by Steve Klabnik and Carol Nichols (552 pages)

    // book is still usable here because we borrowed it
    println!("Book is still available: {}", book.available);
    // Book is still available: true

    println!("\n=== Comparing Structs ===");

    // Structs don't automatically implement equality comparison
    // You need to derive PartialEq trait or implement it manually

    #[derive(Debug, PartialEq)]
    struct Coordinate {
        x: i32,
        y: i32,
    }

    let coord1 = Coordinate { x: 10, y: 20 };
    let coord2 = Coordinate { x: 10, y: 20 };
    let coord3 = Coordinate { x: 15, y: 25 };

    println!("coord1 == coord2: {}", coord1 == coord2); // coord1 == coord2: true
    println!("coord1 == coord3: {}", coord1 == coord3); // coord1 == coord3: false

    println!("\n=== Nested Structs ===");

    #[derive(Debug)]
    struct Address {
        street: String,
        city: String,
        postal_code: String,
    }

    #[derive(Debug)]
    struct Employee {
        person: Person,
        employee_id: u32,
        department: String,
        address: Address,
    }

    let emp_address = Address {
        street: String::from("123 Main St"),
        city: String::from("New York"),
        postal_code: String::from("10001"),
    };

    let emp_person = Person {
        name: String::from("Helen"),
        age: 35,
        email: String::from("helen@company.com"),
        is_active: true,
    };

    let employee_full = Employee {
        person: emp_person,
        employee_id: 12345,
        department: String::from("Engineering"),
        address: emp_address,
    };

    println!("Employee: {:#?}", employee_full);
    // Employee: Employee {
    //     person: Person {
    //         name: "Helen",
    //         age: 35,
    //         email: "helen@company.com",
    //         is_active: true,
    //     },
    //     employee_id: 12345,
    //     department: "Engineering",
    //     address: Address {
    //         street: "123 Main St",
    //         city: "New York",
    //         postal_code: "10001",
    //     },
    // }

    // Accessing nested fields
    println!("Employee name: {}", employee_full.person.name);
    // Employee name: Helen
    println!("Employee city: {}", employee_full.address.city);
    // Employee city: New York

    // Run the struct methods examples
    run_struct_methods_examples();
}

fn run_struct_methods_examples() {
    // Implementation blocks - adding methods to structs
    impl Rectangle {
        // Associated function (like static method) - called with ::
        fn new(width: f64, height: f64) -> Rectangle {
            Rectangle { width, height }
        }

        // Method - takes &self as first parameter
        fn area(&self) -> f64 {
            self.width * self.height
        }

        // Method that takes ownership of self
        fn consume_and_get_area(self) -> f64 {
            self.width * self.height
        }

        // Method that mutates self
        fn scale(&mut self, factor: f64) {
            self.width *= factor;
            self.height *= factor;
        }

        // Method that takes another Rectangle as parameter
        fn can_hold(&self, other: &Rectangle) -> bool {
            self.width > other.width && self.height > other.height
        }
    }

    impl Person {
        // Associated function - constructor
        fn new(name: String, age: u32, email: String) -> Person {
            Person {
                name,
                age,
                email,
                is_active: true,
            }
        }

        // Method to get full description
        fn full_description(&self) -> String {
            format!("{} ({} years old) - {}", self.name, self.age, self.email)
        }

        // Method to check if person is adult
        fn is_adult(&self) -> bool {
            self.age >= 18
        }

        // Method to deactivate account
        fn deactivate(&mut self) {
            self.is_active = false;
        }

        // Method that consumes self and returns a new Person with updated email
        fn change_email(mut self, new_email: String) -> Person {
            self.email = new_email;
            self
        }
    }

    impl Color {
        // Associated function for common colors
        fn red() -> Color {
            Color(255, 0, 0)
        }

        fn green() -> Color {
            Color(0, 255, 0)
        }

        fn blue() -> Color {
            Color(0, 0, 255)
        }

        fn black() -> Color {
            Color(0, 0, 0)
        }

        fn white() -> Color {
            Color(255, 255, 255)
        }

        // Method to get brightness (0-255)
        fn brightness(&self) -> u8 {
            ((self.0 as u16 + self.1 as u16 + self.2 as u16) / 3) as u8
        }

        // Method to check if color is grayscale
        fn is_grayscale(&self) -> bool {
            self.0 == self.1 && self.1 == self.2
        }
    }

    // You can have multiple impl blocks for the same struct
    impl Rectangle {
        // Another method in a separate impl block
        fn perimeter(&self) -> f64 {
            2.0 * (self.width + self.height)
        }

        // Method with multiple parameters
        fn resize(&mut self, new_width: f64, new_height: f64) {
            self.width = new_width;
            self.height = new_height;
        }
    }

    println!("\n=== Struct Methods and Associated Functions ===");

    // Using associated functions (constructors)
    let rect1 = Rectangle::new(10.0, 5.0);
    println!("Rectangle created with new(): {:?}", rect1);
    // Rectangle created with new(): Rectangle { width: 10.0, height: 5.0 }

    let person = Person::new(String::from("John"), 25, String::from("john@example.com"));
    println!("Person created with new(): {:?}", person);
    // Person created with new(): Person { name: "John", age: 25, email: "john@example.com", is_active: true }

    // Using methods
    println!("Rectangle area: {}", rect1.area());
    // Rectangle area: 50
    println!("Rectangle perimeter: {}", rect1.perimeter());
    // Rectangle perimeter: 30

    println!("Person description: {}", person.full_description());
    // Person description: John (25 years old) - john@example.com
    println!("Is adult: {}", person.is_adult());
    // Is adult: true

    // Using color associated functions
    let red = Color::red();
    let custom_color = Color(128, 64, 192);

    println!("Red color: {:?}", red);
    // Red color: Color(255, 0, 0)
    println!("Red brightness: {}", red.brightness());
    // Red brightness: 85
    println!("Is red grayscale: {}", red.is_grayscale());
    // Is red grayscale: false

    println!("Custom color brightness: {}", custom_color.brightness());
    // Custom color brightness: 128

    // Mutable methods
    let mut rect2 = Rectangle::new(8.0, 6.0);
    println!("Before scaling: {:?}", rect2);
    // Before scaling: Rectangle { width: 8.0, height: 6.0 }

    rect2.scale(2.0);
    println!("After scaling by 2: {:?}", rect2);
    // After scaling by 2: Rectangle { width: 16.0, height: 12.0 }

    rect2.resize(20.0, 15.0);
    println!("After resizing: {:?}", rect2);
    // After resizing: Rectangle { width: 20.0, height: 15.0 }

    // Method that takes another struct as parameter
    let small_rect = Rectangle::new(5.0, 3.0);
    println!("Can rect2 hold small_rect: {}", rect2.can_hold(&small_rect));
    // Can rect2 hold small_rect: true

    // Mutable person methods
    let mut person2 = Person::new(String::from("Alice"), 30, String::from("alice@example.com"));

    println!("Before deactivation: {:?}", person2);
    // Before deactivation: Person { name: "Alice", age: 30, email: "alice@example.com", is_active: true }

    person2.deactivate();
    println!("After deactivation: {:?}", person2);
    // After deactivation: Person { name: "Alice", age: 30, email: "alice@example.com", is_active: false }

    // Method that consumes self
    let person3 = Person::new(String::from("Bob"), 28, String::from("bob@old.com"));

    println!("Before email change: {:?}", person3);
    // Before email change: Person { name: "Bob", age: 28, email: "bob@old.com", is_active: true }

    let person3_updated = person3.change_email(String::from("bob@new.com"));
    println!("After email change: {:?}", person3_updated);
    // After email change: Person { name: "Bob", age: 28, email: "bob@new.com", is_active: true }

    // person3 is no longer accessible here because it was moved
    // println!("{:?}", person3); // This would cause a compile error

    // Method that consumes self and returns value
    let rect_for_consumption = Rectangle::new(4.0, 3.0);
    let area = rect_for_consumption.consume_and_get_area();
    println!("Area from consumed rectangle: {}", area);
    // Area from consumed rectangle: 12

    // rect_for_consumption is no longer accessible
    // println!("{:?}", rect_for_consumption); // This would cause a compile error

    println!("\n=== Method Call Syntax vs Function Syntax ===");

    let rect = Rectangle::new(6.0, 4.0);

    // These are equivalent:
    println!("Method syntax: {}", rect.area());
    // Method syntax: 24

    println!("Function syntax: {}", Rectangle::area(&rect));
    // Function syntax: 24

    // Associated functions must use :: syntax
    let new_rect = Rectangle::new(7.0, 8.0);
    println!("New rectangle: {:?}", new_rect);
    // New rectangle: Rectangle { width: 7.0, height: 8.0 }
}
