// Modules let you organize code into namespaces within a single file
// mod keyword creates a module
// Items inside are private by default — use `pub` to expose them

// --- Basic module ---
mod greetings {
    pub fn hello(name: &str) -> String {
        format!("Hello, {}!", name)
    }

    pub fn goodbye(name: &str) -> String {
        format!("Goodbye, {}!", name)
    }

    // Private — only accessible within this module
    fn secret() -> &'static str {
        "this is private"
    }

    pub fn reveal() -> &'static str {
        secret() // can call private fn from within the same module
    }
}

// --- Nested modules ---
mod shapes {
    pub mod circle {
        pub fn area(radius: f64) -> f64 {
            std::f64::consts::PI * radius * radius
        }

        pub fn perimeter(radius: f64) -> f64 {
            2.0 * std::f64::consts::PI * radius
        }
    }

    pub mod rectangle {
        pub fn area(width: f64, height: f64) -> f64 {
            width * height
        }

        pub fn perimeter(width: f64, height: f64) -> f64 {
            2.0 * (width + height)
        }
    }

    // Parent module can access child modules
    pub fn largest_area(r: f64, w: f64, h: f64) -> &'static str {
        if circle::area(r) > rectangle::area(w, h) {
            "circle"
        } else {
            "rectangle"
        }
    }
}

// --- Structs and enums in modules ---
mod inventory {
    #[derive(Debug)]
    pub struct Item {
        pub name: String,
        pub quantity: u32,
        price: f64, // private field — only constructable via new()
    }

    impl Item {
        pub fn new(name: &str, quantity: u32, price: f64) -> Item {
            Item {
                name: name.to_string(),
                quantity,
                price,
            }
        }

        pub fn total_value(&self) -> f64 {
            self.quantity as f64 * self.price
        }
    }

    #[derive(Debug)]
    #[allow(dead_code)]
    pub enum Status {
        InStock,
        LowStock(u32),
        OutOfStock,
    }

    pub fn check_status(item: &Item) -> Status {
        match item.quantity {
            0 => Status::OutOfStock,
            1..=5 => Status::LowStock(item.quantity),
            _ => Status::InStock,
        }
    }
}

// --- super and self paths ---
mod math {
    pub fn double(x: i32) -> i32 {
        x * 2
    }

    pub mod advanced {
        pub fn quadruple(x: i32) -> i32 {
            super::double(super::double(x)) // super:: goes up one level
        }

        pub fn info() -> &'static str {
            "advanced math module"
        }
    }
}

fn main() {
    // Calling into modules with full paths
    println!("{}", greetings::hello("Alice")); // Hello, Alice!
    println!("{}", greetings::goodbye("Bob")); // Goodbye, Bob!
    println!("{}", greetings::reveal()); // this is private

    // Nested module paths
    let c_area = shapes::circle::area(5.0);
    println!("{:.2}", c_area); // 78.54

    let r_area = shapes::rectangle::area(4.0, 6.0);
    println!("{:.2}", r_area); // 24.00

    println!("{}", shapes::largest_area(5.0, 4.0, 6.0)); // circle

    println!("{:.2}", shapes::circle::perimeter(3.0)); // 18.85
    println!("{:.2}", shapes::rectangle::perimeter(4.0, 6.0)); // 20.00

    // Structs from modules
    let item = inventory::Item::new("widget", 3, 9.99);
    println!("{}", item.name); // widget
    println!("{}", item.quantity); // 3
    println!("{:.2}", item.total_value()); // 29.97
    // println!("{}", item.price); // error: field `price` is private

    let status = inventory::check_status(&item);
    println!("{:?}", status); // uses the u32 inside LowStock                       // LowStock(3)

    let full_item = inventory::Item::new("bolt", 100, 0.25);
    println!("{:?}", inventory::check_status(&full_item)); // InStock

    let empty_item = inventory::Item::new("gear", 0, 4.50);
    println!("{:?}", inventory::check_status(&empty_item)); // OutOfStock

    // super:: in nested modules
    println!("{}", math::double(5)); // 10
    println!("{}", math::advanced::quadruple(3)); // 12
    println!("{}", math::advanced::info()); // advanced math module
}
