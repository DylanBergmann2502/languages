use std::collections::HashMap;
use std::collections::HashSet;
// Bring multiple items from the same path with {}
use std::fmt::{self, Display, Formatter};
// Glob import — brings everything public into scope (use sparingly)
// use std::collections::*;

// Aliasing with `as`
use std::collections::BTreeMap as SortedMap;
use std::collections::HashMap as Map;

// --- Modules to demonstrate use paths ---
mod animals {
    pub mod domestic {
        pub struct Dog {
            pub name: String,
        }

        impl Dog {
            pub fn new(name: &str) -> Dog {
                Dog {
                    name: name.to_string(),
                }
            }

            pub fn speak(&self) -> String {
                format!("{} says woof!", self.name)
            }
        }

        pub struct Cat {
            pub name: String,
        }

        impl Cat {
            pub fn new(name: &str) -> Cat {
                Cat {
                    name: name.to_string(),
                }
            }

            pub fn speak(&self) -> String {
                format!("{} says meow!", self.name)
            }
        }
    }

    pub mod wild {
        pub struct Wolf {
            pub name: String,
        }

        impl Wolf {
            pub fn new(name: &str) -> Wolf {
                Wolf {
                    name: name.to_string(),
                }
            }

            pub fn speak(&self) -> String {
                format!("{} says howl!", self.name)
            }
        }
    }
}

mod geometry {
    pub const PI: f64 = std::f64::consts::PI;

    pub fn circle_area(r: f64) -> f64 {
        PI * r * r
    }

    pub fn square_area(s: f64) -> f64 {
        s * s
    }
}

// Re-exporting — bring into scope AND expose to outside callers
// pub use makes it part of this module's public API
mod prelude {
    pub use super::animals::domestic::Cat;
    pub use super::animals::domestic::Dog;
    pub use super::geometry::circle_area;
}

// Custom Display using fmt::Display brought in via use
struct Point {
    x: f64,
    y: f64,
}

impl Display for Point {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

fn main() {
    // Without use — full path every time
    let map1 = std::collections::HashMap::<&str, i32>::new();
    println!("{}", map1.len()); // 0

    // With use at top — just the type name
    let mut map2: HashMap<&str, i32> = HashMap::new();
    map2.insert("a", 1);
    map2.insert("b", 2);
    println!("{}", map2["a"]); // 1

    let mut set: HashSet<i32> = HashSet::new();
    set.insert(1);
    set.insert(2);
    set.insert(1); // duplicate ignored
    println!("{}", set.len()); // 2

    // Alias — Map and SortedMap instead of full names
    let mut scores: Map<&str, u32> = Map::new();
    scores.insert("alice", 95);
    scores.insert("bob", 87);
    println!("{}", scores["alice"]); // 95

    let mut ordered: SortedMap<&str, u32> = SortedMap::new();
    ordered.insert("zebra", 1);
    ordered.insert("apple", 2);
    ordered.insert("mango", 3);
    for (k, v) in &ordered {
        println!("{}: {}", k, v);
    }
    // apple: 2
    // mango: 3
    // zebra: 1

    // Using nested module paths
    let dog = animals::domestic::Dog::new("Rex");
    println!("{}", dog.speak()); // Rex says woof!

    // Bringing into local scope with use inside a function
    use animals::domestic::Cat;
    use animals::wild::Wolf;

    let cat = Cat::new("Whiskers");
    let wolf = Wolf::new("Grey");
    println!("{}", cat.speak()); // Whiskers says meow!
    println!("{}", wolf.speak()); // Grey says howl!

    // Nested path shorthand
    use animals::domestic::{Cat as C, Dog as D};
    let d = D::new("Buddy");
    let c = C::new("Luna");
    println!("{}", d.speak()); // Buddy says woof!
    println!("{}", c.speak()); // Luna says meow!

    // Re-exported items from prelude
    use prelude::{Cat as PCat, Dog as PDog, circle_area};
    let pd = PDog::new("Max");
    let pc = PCat::new("Milo");
    println!("{}", pd.speak()); // Max says woof!
    println!("{}", pc.speak()); // Milo says meow!
    println!("{:.2}", circle_area(5.0)); // 78.54

    // geometry constants and fns via use
    use geometry::{circle_area as ca, square_area};
    println!("{:.2}", ca(3.0)); // 28.27
    println!("{:.2}", square_area(4.0)); // 16.00

    // Custom Display — fmt brought in at top
    let p = Point { x: 3.0, y: 4.0 };
    println!("{}", p); // (3, 4)
}
