use std::collections::HashMap;

fn main() {
    // Creating HashMaps
    let empty_map: HashMap<String, i32> = HashMap::new();
    let mut scores = HashMap::new();

    // Inserting key-value pairs
    scores.insert(String::from("Alice"), 95);
    scores.insert(String::from("Bob"), 87);
    scores.insert(String::from("Charlie"), 92);
    println!("Initial scores: {:?}", scores); // {"Alice": 95, "Bob": 87, "Charlie": 92}

    // Creating HashMap from vectors
    let teams = vec![String::from("Blue"), String::from("Red")];
    let initial_scores = vec![10, 50];
    let team_scores: HashMap<_, _> = teams.into_iter().zip(initial_scores.into_iter()).collect();
    println!("Team scores: {:?}", team_scores); // {"Blue": 10, "Red": 50}

    // Creating HashMap with collect from array
    let fruit_colors: HashMap<&str, &str> =
        [("apple", "red"), ("banana", "yellow"), ("grape", "purple")]
            .iter()
            .cloned()
            .collect();
    println!("Fruit colors: {:?}", fruit_colors); // {"apple": "red", "banana": "yellow", "grape": "purple"}

    // Accessing values
    let alice_score = scores.get("Alice");
    match alice_score {
        Some(score) => println!("Alice's score: {}", score), // Alice's score: 95
        None => println!("Alice not found"),
    }

    // Using get with unwrap_or for default values
    let dave_score = scores.get("Dave").unwrap_or(&0);
    println!("Dave's score (with default): {}", dave_score); // 0

    // Checking if key exists
    println!("Contains Alice: {}", scores.contains_key("Alice")); // true
    println!("Contains Dave: {}", scores.contains_key("Dave")); // false

    // Getting length and checking if empty
    println!("Number of scores: {}", scores.len()); // 3
    println!("Is empty: {}", scores.is_empty()); // false
    println!("Empty map is empty: {}", empty_map.is_empty()); // true

    // Updating values
    scores.insert(String::from("Alice"), 98); // Overwrites existing value
    println!("After updating Alice: {:?}", scores); // Alice now has 98

    // Insert only if key doesn't exist
    scores.entry(String::from("Dave")).or_insert(85);
    scores.entry(String::from("Alice")).or_insert(100); // Won't overwrite
    println!("After or_insert: {:?}", scores); // Dave: 85, Alice still 98

    // Updating based on old value
    let alice_entry = scores.entry(String::from("Alice")).or_insert(0);
    *alice_entry += 2; // Add 2 to Alice's score
    println!("After incrementing Alice: {:?}", scores); // Alice now has 100

    // More complex entry operations
    let mut word_count = HashMap::new();
    let text = "hello world hello rust world";

    for word in text.split_whitespace() {
        let count = word_count.entry(word).or_insert(0);
        *count += 1;
    }
    println!("Word count: {:?}", word_count); // {"hello": 2, "world": 2, "rust": 1}

    // Removing values
    let removed = scores.remove("Bob");
    match removed {
        Some(score) => println!("Removed Bob with score: {}", score), // 87
        None => println!("Bob not found"),
    }
    println!("After removing Bob: {:?}", scores);

    // Iterating over HashMap
    println!("\nIterating over key-value pairs:");
    for (key, value) in &scores {
        println!("{}: {}", key, value);
    }

    // Iterating over keys only
    println!("\nKeys:");
    for key in scores.keys() {
        println!("Key: {}", key);
    }

    // Iterating over values only
    println!("\nValues:");
    for value in scores.values() {
        println!("Value: {}", value);
    }

    // Mutable iteration over values
    for value in scores.values_mut() {
        *value += 5; // Add 5 to each score
    }
    println!("After adding 5 to all scores: {:?}", scores);

    // Creating HashMap with capacity
    let mut efficient_map: HashMap<i32, String> = HashMap::with_capacity(10);
    efficient_map.insert(1, String::from("One"));
    efficient_map.insert(2, String::from("Two"));
    println!("Efficient map: {:?}", efficient_map); // {1: "One", 2: "Two"}

    // Using different types as keys
    let mut number_names = HashMap::new();
    number_names.insert(1, "one");
    number_names.insert(2, "two");
    number_names.insert(3, "three");
    println!("Number names: {:?}", number_names); // {1: "one", 2: "two", 3: "three"}

    // Using tuples as keys
    let mut coordinates = HashMap::new();
    coordinates.insert((0, 0), "origin");
    coordinates.insert((1, 1), "diagonal");
    coordinates.insert((-1, 0), "left");
    println!("Coordinates: {:?}", coordinates); // {(0, 0): "origin", (1, 1): "diagonal", (-1, 0): "left"}

    // HashMap with struct values
    #[derive(Debug)]
    #[allow(dead_code)]
    struct Player {
        name: String,
        level: u32,
    }

    let mut players = HashMap::new();
    players.insert(
        "player1".to_string(),
        Player {
            name: "Alice".to_string(),
            level: 25,
        },
    );
    players.insert(
        "player2".to_string(),
        Player {
            name: "Bob".to_string(),
            level: 30,
        },
    );
    println!("Players: {:?}", players);

    // Finding max/min values
    if let Some(max_score) = scores.values().max() {
        println!("Highest score: {}", max_score);
    }

    if let Some(min_score) = scores.values().min() {
        println!("Lowest score: {}", min_score);
    }

    // Finding key with max value
    if let Some((name, score)) = scores.iter().max_by_key(|&(_, score)| score) {
        println!("Player with highest score: {} ({})", name, score);
    }

    // Sum of all values
    let total_score: i32 = scores.values().sum();
    println!("Total of all scores: {}", total_score);

    // Filtering HashMap
    let high_scores: HashMap<_, _> = scores
        .iter()
        .filter(|(_, &score)| score > 90)
        .map(|(k, v)| (k.clone(), *v))
        .collect();
    println!("High scores (>90): {:?}", high_scores);

    // Merging HashMaps
    let mut map1 = HashMap::new();
    map1.insert("a", 1);
    map1.insert("b", 2);

    let mut map2 = HashMap::new();
    map2.insert("c", 3);
    map2.insert("b", 20); // Will overwrite map1's "b"

    for (key, value) in map2 {
        map1.insert(key, value);
    }
    println!("Merged map: {:?}", map1); // {"a": 1, "b": 20, "c": 3}

    // Using extend to merge
    let mut base_map = HashMap::new();
    base_map.insert("x", 10);
    base_map.insert("y", 20);

    let extension = [("z", 30), ("x", 100)]; // "x" will be overwritten
    base_map.extend(extension.iter().cloned());
    println!("Extended map: {:?}", base_map); // {"x": 100, "y": 20, "z": 30}

    // Clearing HashMap
    let mut temp_map = HashMap::new();
    temp_map.insert("temp", "value");
    println!("Before clear: {:?}", temp_map); // {"temp": "value"}
    temp_map.clear();
    println!("After clear: {:?}", temp_map); // {}
    println!("Is empty after clear: {}", temp_map.is_empty()); // true

    // HashMap with custom type as key (must implement Hash + Eq)
    #[derive(Hash, Eq, PartialEq, Debug)]
    struct CustomKey {
        id: u32,
        name: String,
    }

    let mut custom_map = HashMap::new();
    custom_map.insert(
        CustomKey {
            id: 1,
            name: "test".to_string(),
        },
        "value1",
    );
    custom_map.insert(
        CustomKey {
            id: 2,
            name: "test2".to_string(),
        },
        "value2",
    );
    println!("Custom key map: {:?}", custom_map);

    // Entry API examples
    let mut letter_count = HashMap::new();
    let letters = "abcabc";

    // Method 1: Using or_insert
    for ch in letters.chars() {
        *letter_count.entry(ch).or_insert(0) += 1;
    }
    println!("Letter count (method 1): {:?}", letter_count); // {'a': 2, 'b': 2, 'c': 2}

    // Method 2: Using or_insert_with for expensive computations
    let mut expensive_operations = HashMap::new();
    let key = "expensive";
    expensive_operations.entry(key).or_insert_with(|| {
        println!("Computing expensive value...");
        42 // This only runs if key doesn't exist
    });

    // Second access won't print "Computing..."
    expensive_operations.entry(key).or_insert_with(|| {
        println!("Computing expensive value...");
        42
    });

    println!("Expensive operations: {:?}", expensive_operations);

    // Ownership considerations
    let mut ownership_demo = HashMap::new();
    let key = String::from("owned_key");
    let value = String::from("owned_value");

    // This moves both key and value into the HashMap
    ownership_demo.insert(key, value);
    // println!("{}", key); // Error: key was moved
    // println!("{}", value); // Error: value was moved

    // Using references when you want to keep ownership
    let mut ref_demo = HashMap::new();
    let ref_key = "ref_key";
    let ref_value = "ref_value";
    ref_demo.insert(ref_key, ref_value); // &str implements Copy, so no move
    println!("Can still use: {} and {}", ref_key, ref_value); // Works fine
}
