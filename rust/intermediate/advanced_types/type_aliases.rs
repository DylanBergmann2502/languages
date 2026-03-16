use std::collections::HashMap;

// Basic type alias — just a shorter name, same type underneath
type Kilometers = i32;
type Meters = i32;

// Simplifying complex types
type Thunk = Box<dyn Fn() -> String>;
type UserMap = HashMap<String, Vec<String>>;
type Result<T> = std::result::Result<T, String>;

// Generic type alias
type Pair<T> = (T, T);
type Grid<T> = Vec<Vec<T>>;

fn make_greeting(name: &str) -> Thunk {
    let name = name.to_string();
    Box::new(move || format!("Hello, {}!", name))
}

fn add_user_tag(map: &mut UserMap, user: &str, tag: &str) {
    map.entry(user.to_string())
        .or_insert_with(Vec::new)
        .push(tag.to_string());
}

fn parse_number(s: &str) -> Result<i32> {
    s.parse::<i32>().map_err(|e| e.to_string())
}

fn swap<T: Copy>(pair: Pair<T>) -> Pair<T> {
    (pair.1, pair.0)
}

fn main() {
    // Basic aliases — Kilometers and Meters are both i32
    let distance: Kilometers = 5;
    let also_distance: Meters = 5;
    println!("{}", distance + also_distance); // 10
                                              // Note: aliases don't prevent mixing — they're the same type

    // Thunk — avoids repeating Box<dyn Fn() -> String> everywhere
    let greet = make_greeting("Alice");
    println!("{}", greet()); // Hello, Alice!

    let greet2: Thunk = Box::new(|| String::from("Hey there!"));
    println!("{}", greet2()); // Hey there!

    // UserMap — cleaner than HashMap<String, Vec<String>>
    let mut users: UserMap = HashMap::new();
    add_user_tag(&mut users, "alice", "admin");
    add_user_tag(&mut users, "alice", "editor");
    add_user_tag(&mut users, "bob", "viewer");
    println!("{:?}", users.get("alice")); // Some(["admin", "editor"])
    println!("{:?}", users.get("bob")); // Some(["viewer"])

    // Custom Result<T> alias hides the error type
    println!("{:?}", parse_number("42")); // Ok(42)
    println!("{:?}", parse_number("abc")); // Err("invalid digit found in string")

    // Generic alias Pair<T>
    let coords: Pair<f64> = (3.0, 4.0);
    println!("{:?}", coords); // (3.0, 4.0)
    println!("{:?}", swap(coords)); // (4.0, 3.0)

    let names: Pair<&str> = ("Alice", "Bob");
    println!("{:?}", swap(names)); // ("Bob", "Alice")

    // Grid<T> — Vec<Vec<T>>
    let grid: Grid<i32> = vec![vec![1, 2, 3], vec![4, 5, 6], vec![7, 8, 9]];
    for row in &grid {
        println!("{:?}", row);
    }
    // [1, 2, 3]
    // [4, 5, 6]
    // [7, 8, 9]
}
