fn main() {
    // Creating tuples - heterogeneous collections with fixed size
    let empty_tuple = (); // Unit type, zero-sized
    let single = (42,); // Single element tuple (note the comma!)
    let pair = (1, 2); // Two elements
    let triple = (1, "hello", 3.14); // Mixed types
    let nested = ((1, 2), (3, 4)); // Nested tuples

    println!("Empty tuple: {:?}", empty_tuple); // ()
    println!("Single: {:?}", single); // (42,)
    println!("Pair: {:?}", pair); // (1, 2)
    println!("Triple: {:?}", triple); // (1, "hello", 3.14)
    println!("Nested: {:?}", nested); // ((1, 2), (3, 4))

    // Explicit type annotations
    let coordinates: (i32, i32) = (10, 20);
    let person: (String, u32, bool) = ("Alice".to_string(), 25, true);
    let point_3d: (f64, f64, f64) = (1.0, 2.5, -3.2);

    println!("Coordinates: {:?}", coordinates); // (10, 20)
    println!("Person: {:?}", person); // ("Alice", 25, true)
    println!("3D Point: {:?}", point_3d); // (1.0, 2.5, -3.2)

    // Accessing tuple elements by index
    let data = (100, "Rust", true, 3.14);
    println!("First element: {}", data.0); // 100
    println!("Second element: {}", data.1); // Rust
    println!("Third element: {}", data.2); // true
    println!("Fourth element: {}", data.3); // 3.14

    // Modifying mutable tuples
    let mut mutable_tuple = (1, "hello", false);
    println!("Before modification: {:?}", mutable_tuple); // (1, "hello", false)
    mutable_tuple.0 = 99;
    mutable_tuple.2 = true;
    println!("After modification: {:?}", mutable_tuple); // (99, "hello", true)

    // Destructuring - extracting values from tuples
    let point = (5, 10);
    let (x, y) = point;
    println!("x: {}, y: {}", x, y); // x: 5, y: 10

    // Destructuring with different types
    let mixed = (42, "world", 2.71);
    let (number, text, float_val) = mixed;
    println!("Number: {}, Text: {}, Float: {}", number, text, float_val); // Number: 42, Text: world, Float: 2.71

    // Partial destructuring
    let rgb = (255, 128, 0);
    let (red, _green, blue) = rgb;
    println!("Red: {}, Blue: {}", red, blue); // Red: 255, Blue: 0

    // Using .. to ignore multiple values
    let large_tuple = (1, 2, 3, 4, 5, 6);
    let (first, .., last) = large_tuple;
    println!("First: {}, Last: {}", first, last); // First: 1, Last: 6

    let (_first_two, ..) = large_tuple;
    // This doesn't work - you can't destructure partial tuples this way
    // Instead, access by index or destructure completely

    // Destructuring in function parameters
    fn print_point(point: (i32, i32)) {
        let (x, y) = point;
        println!("Point coordinates: ({}, {})", x, y);
    }

    fn print_point_direct((x, y): (i32, i32)) {
        println!("Direct destructuring: ({}, {})", x, y);
    }

    print_point((15, 25)); // Point coordinates: (15, 25)
    print_point_direct((30, 40)); // Direct destructuring: (30, 40)

    // Tuples in pattern matching
    let status_code = (200, "OK");
    match status_code {
        (200, message) => println!("Success: {}", message), // Success: OK
        (404, message) => println!("Not found: {}", message),
        (500, message) => println!("Server error: {}", message),
        (code, message) => println!("Other status {}: {}", code, message),
    }

    // Matching with guards
    let response = (201, "Created", 1024);
    match response {
        (code, msg, size) if code >= 200 && code < 300 => {
            println!("Success {}: {}, {} bytes", code, msg, size); // Success 201: Created, 1024 bytes
        }
        (code, msg, _) if code >= 400 => {
            println!("Error {}: {}", code, msg);
        }
        _ => println!("Other response"),
    }

    // Tuples as return values - multiple return values
    fn divide_with_remainder(dividend: i32, divisor: i32) -> (i32, i32) {
        (dividend / divisor, dividend % divisor)
    }

    let (quotient, remainder) = divide_with_remainder(17, 5);
    println!("17 ÷ 5 = {} remainder {}", quotient, remainder); // 17 ÷ 5 = 3 remainder 2

    // Returning multiple types
    fn get_user_info() -> (String, u32, Vec<String>) {
        (
            "Alice".to_string(),
            30,
            vec!["admin".to_string(), "user".to_string()],
        )
    }

    let (name, age, roles) = get_user_info();
    println!("User: {}, Age: {}, Roles: {:?}", name, age, roles); // User: Alice, Age: 30, Roles: ["admin", "user"]

    // Tuples in collections
    let points = vec![(1, 2), (3, 4), (5, 6)];
    println!("Points: {:?}", points); // [(1, 2), (3, 4), (5, 6)]

    for (x, y) in &points {
        println!("Point: ({}, {})", x, y); // Point: (1, 2), etc.
    }

    // Map with tuple values
    use std::collections::HashMap;
    let mut coordinates: HashMap<String, (f64, f64)> = HashMap::new();
    coordinates.insert("home".to_string(), (40.7128, -74.0060));
    coordinates.insert("work".to_string(), (40.7589, -73.9851));

    for (location, (lat, lon)) in &coordinates {
        println!("{}: ({}, {})", location, lat, lon); // home: (40.7128, -74.0060), etc.
    }

    // Swapping values using tuples
    let mut a = 10;
    let mut b = 20;
    println!("Before swap: a = {}, b = {}", a, b); // Before swap: a = 10, b = 20

    // Traditional way (without temporary variable)
    let temp = (a, b);
    a = temp.1;
    b = temp.0;
    println!("After swap: a = {}, b = {}", a, b); // After swap: a = 20, b = 10

    // Elegant tuple swap
    let mut x = 100;
    let mut y = 200;
    (x, y) = (y, x);
    println!("Swapped: x = {}, y = {}", x, y); // Swapped: x = 200, y = 100

    // Multiple assignment
    let mut first = 1;
    let mut second = 2;
    let mut third = 3;
    (first, second, third) = (third, first, second); // Rotate values
    println!("Rotated: {}, {}, {}", first, second, third); // Rotated: 3, 1, 2

    // Comparing tuples - lexicographic ordering
    let tuple1 = (1, 2, 3);
    let tuple2 = (1, 2, 3);
    let tuple3 = (1, 2, 4);
    let tuple4 = (2, 1, 1);

    println!("tuple1 == tuple2: {}", tuple1 == tuple2); // true
    println!("tuple1 == tuple3: {}", tuple1 == tuple3); // false
    println!("tuple1 < tuple3: {}", tuple1 < tuple3); // true
    println!("tuple1 < tuple4: {}", tuple1 < tuple4); // true

    // Sorting tuples
    let mut pairs = vec![(3, "c"), (1, "a"), (2, "b")];
    pairs.sort();
    println!("Sorted pairs: {:?}", pairs); // [(1, "a"), (2, "b"), (3, "c")]

    // Sort by second element
    let mut scores = vec![("Alice", 85), ("Bob", 92), ("Charlie", 78)];
    scores.sort_by(|a, b| a.1.cmp(&b.1)); // Sort by score
    println!("Sorted by score: {:?}", scores); // [("Charlie", 78), ("Alice", 85), ("Bob", 92)]

    // Tuple methods and traits
    let copyable = (1, 2, 3);
    let copied = copyable; // Tuples implement Copy if all elements do
    println!("Original: {:?}, Copied: {:?}", copyable, copied); // Both accessible

    let cloneable = ("hello".to_string(), vec![1, 2, 3]);
    let cloned = cloneable.clone(); // Clone when elements don't implement Copy
    println!("Cloned tuple: {:?}", cloned); // ("hello", [1, 2, 3])

    // Nested tuple destructuring
    let nested_data = ((1, 2), ("a", "b"), (true, false));
    let ((num1, num2), (char1, char2), (bool1, bool2)) = nested_data;
    println!(
        "Nested destructuring: {}, {}, {}, {}, {}, {}",
        num1, num2, char1, char2, bool1, bool2
    ); // 1, 2, a, b, true, false

    // Partial nested destructuring
    let complex = ((10, 20), (30, 40, 50));
    let ((a, b), (c, _, e)) = complex; // Ignore middle element of second tuple
    println!("Partial nested: {}, {}, {}, {}", a, b, c, e); // 10, 20, 30, 50

    // Using tuples with iterators
    let numbers = vec![1, 2, 3, 4, 5];
    let letters = vec!['a', 'b', 'c', 'd', 'e'];

    // Zip creates tuples
    let zipped: Vec<(i32, char)> = numbers
        .iter()
        .zip(letters.iter())
        .map(|(&n, &c)| (n, c))
        .collect();
    println!("Zipped: {:?}", zipped); // [(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd'), (5, 'e')]

    // Enumerate creates tuples with indices
    let enumerated: Vec<(usize, i32)> = numbers.iter().enumerate().map(|(i, &n)| (i, n)).collect();
    println!("Enumerated: {:?}", enumerated); // [(0, 1), (1, 2), (2, 3), (3, 4), (4, 5)]

    // Tuple as function argument for flexible APIs
    fn process_coordinate<T>(coord: T)
    where
        T: Into<(f64, f64)>,
    {
        let (x, y) = coord.into();
        println!("Processing coordinate: ({}, {})", x, y);
    }

    // This would require implementing From/Into for custom types
    // process_coordinate((1.0, 2.0)); // Direct tuple

    // Real-world example: Result with tuple
    fn parse_name_age(input: &str) -> Result<(String, u32), String> {
        let parts: Vec<&str> = input.split(',').collect();
        if parts.len() != 2 {
            return Err("Invalid format".to_string());
        }

        let name = parts[0].trim().to_string();
        let age = parts[1]
            .trim()
            .parse::<u32>()
            .map_err(|_| "Invalid age".to_string())?;

        Ok((name, age))
    }

    match parse_name_age("Alice, 25") {
        Ok((name, age)) => println!("Parsed: {} is {} years old", name, age), // Parsed: Alice is 25 years old
        Err(e) => println!("Error: {}", e),
    }

    match parse_name_age("Invalid input") {
        Ok((name, age)) => println!("Parsed: {} is {} years old", name, age),
        Err(e) => println!("Error: {}", e), // Error: Invalid format
    }

    // Large tuples (up to 12 elements in std library)
    let large = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
    println!("Large tuple: {:?}", large);
    println!("12th element: {}", large.11); // 12

    // Converting tuples to arrays (same type elements)
    let homogeneous_tuple = (1, 2, 3, 4);
    // let array: [i32; 4] = homogeneous_tuple.into(); // Not directly possible
    // You'd need to destructure and reconstruct
    let (a, b, c, d) = homogeneous_tuple;
    let array = [a, b, c, d];
    println!("Tuple to array: {:?}", array); // [1, 2, 3, 4]

    // Unit type usage - functions that don't return values
    fn print_message() -> () {
        println!("This function returns unit type");
    }

    let unit_result = print_message(); // This function returns unit type
    println!("Unit result: {:?}", unit_result); // ()
}
