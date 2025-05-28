fn main() {
    // Creating vectors
    let empty_vec: Vec<i32> = Vec::new(); // Empty vector, type annotation needed
    let numbers = vec![1, 2, 3, 4, 5]; // Using vec! macro
    let zeros = vec![0; 5]; // Create vector with 5 zeros
    println!("Empty vector: {:?}", empty_vec); // []
    println!("Numbers: {:?}", numbers); // [1, 2, 3, 4, 5]
    println!("Zeros: {:?}", zeros); // [0, 0, 0, 0, 0]

    // Vector with capacity (performance optimization)
    let with_capacity: Vec<i32> = Vec::with_capacity(10);
    println!("Capacity before adding: {}", with_capacity.capacity()); // 10
    println!("Length before adding: {}", with_capacity.len()); // 0

    // Adding elements
    let mut fruits = Vec::new();
    fruits.push("apple");
    fruits.push("banana");
    fruits.push("orange");
    println!("Fruits after push: {:?}", fruits); // ["apple", "banana", "orange"]

    // Extending with multiple elements
    let mut more_fruits = vec!["grape", "mango"];
    fruits.append(&mut more_fruits); // more_fruits becomes empty
    println!("Fruits after append: {:?}", fruits); // ["apple", "banana", "orange", "grape", "mango"]
    println!("More fruits after append: {:?}", more_fruits); // []

    // Extend without moving
    let additional = vec!["kiwi", "strawberry"];
    fruits.extend(additional.iter().cloned());
    println!("Fruits after extend: {:?}", fruits); // ["apple", "banana", "orange", "grape", "mango", "kiwi", "strawberry"]

    // Accessing elements
    let numbers = vec![10, 20, 30, 40, 50];
    println!("First element: {}", numbers[0]); // 10 (panics if out of bounds)
    println!("Last element: {}", numbers[numbers.len() - 1]); // 50

    // Safe access with get()
    match numbers.get(0) {
        Some(value) => println!("Safe first element: {}", value), // Safe first element: 10
        None => println!("Index out of bounds"),
    }

    match numbers.get(10) {
        Some(value) => println!("Element at index 10: {}", value),
        None => println!("Index 10 is out of bounds"), // This will execute
    }

    // First and last elements
    println!("First: {:?}", numbers.first()); // Some(10)
    println!("Last: {:?}", numbers.last()); // Some(50)

    let empty: Vec<i32> = Vec::new();
    println!("First of empty: {:?}", empty.first()); // None

    // Vector properties
    println!("Length: {}", numbers.len()); // 5
    println!("Is empty: {}", numbers.is_empty()); // false
    println!("Capacity: {}", numbers.capacity()); // Usually >= 5

    // Removing elements
    let mut removable = vec![1, 2, 3, 4, 5];
    let popped = removable.pop(); // Remove from end
    println!("Popped: {:?}, Vector: {:?}", popped, removable); // Some(5), [1, 2, 3, 4]

    let removed = removable.remove(1); // Remove at index 1
    println!("Removed: {}, Vector: {:?}", removed, removable); // 2, [1, 3, 4]

    // Insert at specific position
    removable.insert(1, 99);
    println!("After insert at 1: {:?}", removable); // [1, 99, 3, 4]

    // Swapping elements
    let mut swappable = vec!["a", "b", "c", "d"];
    swappable.swap(0, 3);
    println!("After swap(0, 3): {:?}", swappable); // ["d", "b", "c", "a"]

    // Clearing and truncating
    let mut clearable = vec![1, 2, 3, 4, 5];
    println!("Before clear: {:?}", clearable); // [1, 2, 3, 4, 5]
    clearable.clear();
    println!("After clear: {:?}", clearable); // []

    let mut truncatable = vec![1, 2, 3, 4, 5];
    truncatable.truncate(3);
    println!("After truncate(3): {:?}", truncatable); // [1, 2, 3]

    // Iteration
    let data = vec![1, 2, 3, 4, 5];

    // Immutable iteration
    print!("Values: ");
    for value in &data {
        print!("{} ", value); // 1 2 3 4 5
    }
    println!();

    // Mutable iteration
    let mut mutable_data = vec![1, 2, 3, 4, 5];
    for value in &mut mutable_data {
        *value *= 2;
    }
    println!("After doubling: {:?}", mutable_data); // [2, 4, 6, 8, 10]

    // Iteration with index
    for (index, value) in data.iter().enumerate() {
        println!("Index {}: {}", index, value); // Index 0: 1, etc.
    }

    // Consuming the vector
    let consumable = vec!["hello", "world"];
    for item in consumable {
        println!("Consumed: {}", item); // hello, world
    }
    // println!("{:?}", consumable); // Error: consumable was moved

    // Slicing vectors
    let slice_data = vec![1, 2, 3, 4, 5, 6, 7, 8];
    let slice = &slice_data[1..4]; // Elements 1, 2, 3 (indices 1, 2, 3)
    println!("Slice [1..4]: {:?}", slice); // [2, 3, 4]

    let first_three = &slice_data[..3];
    println!("First three: {:?}", first_three); // [1, 2, 3]

    let last_three = &slice_data[slice_data.len() - 3..];
    println!("Last three: {:?}", last_three); // [6, 7, 8]

    // Searching in vectors
    let search_data = vec![10, 20, 30, 40, 50];
    println!("Contains 30: {}", search_data.contains(&30)); // true

    match search_data.iter().position(|&x| x == 30) {
        Some(index) => println!("Found 30 at index: {}", index), // Found 30 at index: 2
        None => println!("30 not found"),
    }

    // Find first element matching condition
    match search_data.iter().find(|&&x| x > 25) {
        Some(value) => println!("First value > 25: {}", value), // First value > 25: 30
        None => println!("No value > 25 found"),
    }

    // Sorting vectors
    let mut sortable = vec![3, 1, 4, 1, 5, 9, 2, 6];
    println!("Before sort: {:?}", sortable); // [3, 1, 4, 1, 5, 9, 2, 6]

    sortable.sort();
    println!("After sort: {:?}", sortable); // [1, 1, 2, 3, 4, 5, 6, 9]

    sortable.sort_by(|a, b| b.cmp(a)); // Reverse order
    println!("Reverse sorted: {:?}", sortable); // [9, 6, 5, 4, 3, 2, 1, 1]

    // Sorting strings
    let mut words = vec!["banana", "apple", "cherry", "date"];
    words.sort();
    println!("Sorted words: {:?}", words); // ["apple", "banana", "cherry", "date"]

    // Deduplication (requires sorted vector)
    let mut with_duplicates = vec![1, 1, 2, 2, 3, 3, 4];
    with_duplicates.dedup();
    println!("After dedup: {:?}", with_duplicates); // [1, 2, 3, 4]

    // Functional operations with iterators
    let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // Map - transform each element
    let squares: Vec<i32> = numbers.iter().map(|x| x * x).collect();
    println!("Squares: {:?}", squares); // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

    // Filter - keep elements matching condition
    let evens: Vec<&i32> = numbers.iter().filter(|&x| x % 2 == 0).collect();
    println!("Evens: {:?}", evens); // [2, 4, 6, 8, 10]

    // Chain operations
    let processed: Vec<i32> = numbers
        .iter()
        .filter(|&x| x % 2 == 0) // Keep evens
        .map(|x| x * x) // Square them
        .collect();
    println!("Even squares: {:?}", processed); // [4, 16, 36, 64, 100]

    // Fold/reduce operations
    let sum: i32 = numbers.iter().sum();
    println!("Sum: {}", sum); // 55

    let product: i32 = numbers.iter().product();
    println!("Product: {}", product); // 3628800

    // Custom fold
    let sum_of_squares: i32 = numbers.iter().fold(0, |acc, x| acc + x * x);
    println!("Sum of squares: {}", sum_of_squares); // 385

    // Converting between Vec<T> and other types
    let string_vec = vec!["hello", "world", "rust"];
    let joined = string_vec.join(" ");
    println!("Joined: {}", joined); // hello world rust

    // From string to vector of chars
    let text = "hello";
    let char_vec: Vec<char> = text.chars().collect();
    println!("Chars: {:?}", char_vec); // ['h', 'e', 'l', 'l', 'o']

    // Split string into vector
    let csv = "apple,banana,orange";
    let fruit_vec: Vec<&str> = csv.split(',').collect();
    println!("Split fruits: {:?}", fruit_vec); // ["apple", "banana", "orange"]

    // Nested vectors (2D arrays)
    let mut matrix = vec![vec![1, 2, 3], vec![4, 5, 6], vec![7, 8, 9]];
    println!("Matrix: {:?}", matrix); // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    println!("Element at [1][2]: {}", matrix[1][2]); // 6

    // Modifying nested vector
    matrix[0][0] = 99;
    println!("Modified matrix: {:?}", matrix); // [[99, 2, 3], [4, 5, 6], [7, 8, 9]]

    // Retaining elements based on condition
    let mut filter_vec = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    filter_vec.retain(|&x| x % 2 == 0);
    println!("Retained evens: {:?}", filter_vec); // [2, 4, 6, 8, 10]

    // Reversing
    let mut reversible = vec![1, 2, 3, 4, 5];
    reversible.reverse();
    println!("Reversed: {:?}", reversible); // [5, 4, 3, 2, 1]

    // Splitting vectors
    let mut splittable = vec![1, 2, 3, 4, 5, 6];
    let second_half = splittable.split_off(3); // Split at index 3
    println!("First half: {:?}", splittable); // [1, 2, 3]
    println!("Second half: {:?}", second_half); // [4, 5, 6]

    // Checking if vector is sorted
    let sorted_vec = vec![1, 2, 3, 4, 5];
    let unsorted_vec = vec![3, 1, 4, 2, 5];
    println!(
        "Is sorted_vec sorted: {}",
        sorted_vec.windows(2).all(|w| w[0] <= w[1])
    ); // true
    println!(
        "Is unsorted_vec sorted: {}",
        unsorted_vec.windows(2).all(|w| w[0] <= w[1])
    ); // false
}
