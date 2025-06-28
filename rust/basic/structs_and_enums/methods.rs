// Methods in Rust - Implementing behavior on structs
// Methods are functions defined within the context of a struct, enum, or trait object
// They're defined in impl blocks and always take &self, &mut self, or self as the first parameter
// Methods are called with dot notation: instance.method()
// Associated functions don't take self and are called with :: syntax like String::new()

// Basic struct for our examples
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

// Implementation block - where we define methods for Rectangle
impl Rectangle {
    // Associated function (no self parameter) - like a constructor
    // Called with Rectangle::new(10, 20)
    fn new(width: u32, height: u32) -> Rectangle {
        Rectangle { width, height }
    }

    // Another associated function - creates a square
    fn square(size: u32) -> Rectangle {
        Rectangle {
            width: size,
            height: size,
        }
    }

    // Method that takes immutable reference to self
    // Can read data but not modify it
    fn area(&self) -> u32 {
        self.width * self.height
    }

    // Method that takes immutable reference to self
    fn perimeter(&self) -> u32 {
        2 * (self.width + self.height)
    }

    // Method that takes another Rectangle as parameter
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }

    // Method that takes mutable reference to self
    // Can modify the struct's data
    fn double_size(&mut self) {
        self.width *= 2;
        self.height *= 2;
    }

    // Method that takes ownership of self (consumes the instance)
    // The instance cannot be used after calling this method
    fn into_square(self) -> Rectangle {
        let size = if self.width > self.height {
            self.width
        } else {
            self.height
        };
        Rectangle::square(size)
    }

    // Method that returns whether it's a square
    fn is_square(&self) -> bool {
        self.width == self.height
    }

    // Method with multiple parameters
    fn resize(&mut self, new_width: u32, new_height: u32) {
        self.width = new_width;
        self.height = new_height;
    }
}

// You can have multiple impl blocks for the same struct
impl Rectangle {
    // Method to get dimensions as a tuple
    fn dimensions(&self) -> (u32, u32) {
        (self.width, self.height)
    }

    // Method that returns a formatted string
    fn describe(&self) -> String {
        format!(
            "Rectangle: {}x{} (area: {})",
            self.width,
            self.height,
            self.area()
        )
    }
}

// Example with a more complex struct
#[derive(Debug)]
struct BankAccount {
    account_number: u32,
    balance: f64,
    account_type: String,
}

impl BankAccount {
    // Constructor
    fn new(account_number: u32, initial_balance: f64, account_type: String) -> BankAccount {
        BankAccount {
            account_number,
            balance: initial_balance,
            account_type,
        }
    }

    // Method to deposit money (mutates balance)
    fn deposit(&mut self, amount: f64) -> Result<(), String> {
        if amount <= 0.0 {
            return Err("Deposit amount must be positive".to_string());
        }
        self.balance += amount;
        Ok(())
    }

    // Method to withdraw money (mutates balance)
    fn withdraw(&mut self, amount: f64) -> Result<(), String> {
        if amount <= 0.0 {
            return Err("Withdrawal amount must be positive".to_string());
        }
        if amount > self.balance {
            return Err("Insufficient funds".to_string());
        }
        self.balance -= amount;
        Ok(())
    }

    // Getter method (immutable reference)
    fn get_balance(&self) -> f64 {
        self.balance
    }

    // Method that checks account status
    fn is_overdrawn(&self) -> bool {
        self.balance < 0.0
    }

    // Method that applies interest
    fn apply_interest(&mut self, rate: f64) {
        self.balance *= 1.0 + rate;
    }
}

// Struct with lifetime parameters can also have methods
#[derive(Debug)]
struct ImportantExcerpt<'a> {
    part: &'a str,
}

impl<'a> ImportantExcerpt<'a> {
    // Method that returns the same lifetime as the struct
    fn level(&self) -> i32 {
        3
    }

    // Method that announces and returns the part
    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention please: {}", announcement);
        self.part
    }
}

fn main() {
    println!("=== Rectangle Methods Examples ===");

    // Using associated functions (constructors)
    let rect1 = Rectangle::new(30, 50);
    println!("Rectangle 1: {:?}", rect1); // Rectangle { width: 30, height: 50 }

    let square = Rectangle::square(25);
    println!("Square: {:?}", square); // Rectangle { width: 25, height: 25 }

    // Using methods that take &self (immutable reference)
    println!("Rectangle 1 area: {}", rect1.area()); // 1500
    println!("Rectangle 1 perimeter: {}", rect1.perimeter()); // 160
    println!("Rectangle 1 is square: {}", rect1.is_square()); // false
    println!("Square is square: {}", square.is_square()); // true

    // Method that takes another struct as parameter
    let rect2 = Rectangle::new(10, 40);
    println!("Can rect1 hold rect2? {}", rect1.can_hold(&rect2)); // true
    println!("Can rect2 hold rect1? {}", rect2.can_hold(&rect1)); // false

    // Using methods that take &mut self (mutable reference)
    let mut rect3 = Rectangle::new(5, 10);
    println!("Before doubling: {:?}", rect3); // Rectangle { width: 5, height: 10 }
    rect3.double_size();
    println!("After doubling: {:?}", rect3); // Rectangle { width: 10, height: 20 }

    rect3.resize(15, 25);
    println!("After resize: {:?}", rect3); // Rectangle { width: 15, height: 25 }

    // Using methods from multiple impl blocks
    println!("Dimensions: {:?}", rect3.dimensions()); // (15, 25)
    println!("Description: {}", rect3.describe()); // Rectangle: 15x25 (area: 375)

    // Using method that takes ownership of self
    let rect4 = Rectangle::new(8, 12);
    println!("Before conversion: {:?}", rect4); // Rectangle { width: 8, height: 12 }
    let converted_square = rect4.into_square();
    println!("After conversion to square: {:?}", converted_square); // Rectangle { width: 12, height: 12 }
                                                                    // rect4 can no longer be used here because it was moved

    println!("\n=== BankAccount Methods Examples ===");

    // Creating a bank account
    let mut account = BankAccount::new(12345, 1000.0, "Savings".to_string());
    println!("Initial account: {:?}", account);

    // Using getter method
    println!("Current balance: ${:.2}", account.get_balance()); // $1000.00

    // Depositing money
    match account.deposit(250.0) {
        Ok(()) => println!("Deposit successful"),
        Err(e) => println!("Deposit failed: {}", e),
    }
    println!("Balance after deposit: ${:.2}", account.get_balance()); // $1250.00

    // Withdrawing money
    match account.withdraw(300.0) {
        Ok(()) => println!("Withdrawal successful"),
        Err(e) => println!("Withdrawal failed: {}", e),
    }
    println!("Balance after withdrawal: ${:.2}", account.get_balance()); // $950.00

    // Trying to withdraw more than balance
    match account.withdraw(1500.0) {
        Ok(()) => println!("Withdrawal successful"),
        Err(e) => println!("Withdrawal failed: {}", e), // This will fail
    }

    // Checking account status
    println!("Is overdrawn: {}", account.is_overdrawn()); // false

    // Applying interest
    account.apply_interest(0.05); // 5% interest
    println!("Balance after 5% interest: ${:.2}", account.get_balance()); // $997.50

    println!("\n=== Lifetime Methods Examples ===");

    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    let excerpt = ImportantExcerpt {
        part: first_sentence,
    };

    println!("Excerpt level: {}", excerpt.level()); // 3
    let returned_part = excerpt.announce_and_return_part("Everyone listen up!");
    println!("Returned part: {}", returned_part); // Call me Ishmael

    println!("\n=== Method Syntax vs Function Syntax ===");

    let rect = Rectangle::new(3, 4);

    // These are equivalent - method syntax vs function syntax:
    println!("Method syntax: {}", rect.area()); // 12
    println!("Function syntax: {}", Rectangle::area(&rect)); // 12

    // Associated functions must use :: syntax
    let new_rect = Rectangle::square(5);
    println!("Created with associated function: {:?}", new_rect);
}

// Key takeaways:
// 1. Methods are defined in impl blocks
// 2. &self for methods that read data
// 3. &mut self for methods that modify data
// 4. self for methods that take ownership
// 5. Associated functions don't take self (like constructors)
// 6. You can have multiple impl blocks for the same struct
// 7. Method syntax (instance.method()) vs function syntax (Type::method(&instance))
// 8. Associated functions are called with :: syntax (Type::function())
