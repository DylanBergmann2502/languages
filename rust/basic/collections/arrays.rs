fn main() {
    // Creating arrays - fixed size known at compile time
    let numbers = [1, 2, 3, 4, 5]; // Type inferred as [i32; 5]
    let explicit: [i32; 5] = [1, 2, 3, 4, 5]; // Explicit type annotation
    let zeros = [0; 10]; // Create array with 10 zeros
    let chars = ['a', 'b', 'c', 'd']; // Character array
    println!("Numbers: {:?}", numbers); // [1, 2, 3, 4, 5]
    println!("Explicit: {:?}", explicit); // [1, 2, 3, 4, 5]
    println!("Zeros: {:?}", zeros); // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    println!("Chars: {:?}", chars); // ['a', 'b', 'c', 'd']

    // Array properties
    println!("Length of numbers: {}", numbers.len()); // 5
    println!("Length of zeros: {}", zeros.len()); // 10
    println!("Is numbers empty: {}", numbers.is_empty()); // false

    let empty: [i32; 0] = [];
    println!("Empty array: {:?}", empty); // []
    println!("Is empty array empty: {}", empty.is_empty()); // true

    // Accessing array elements
    println!("First element: {}", numbers[0]); // 1
    println!("Last element: {}", numbers[4]); // 5
    println!("Last element (len-1): {}", numbers[numbers.len() - 1]); // 5

    // Safe access with get()
    match numbers.get(0) {
        Some(value) => println!("Safe first element: {}", value), // Safe first element: 1
        None => println!("Index out of bounds"),
    }

    match numbers.get(10) {
        Some(value) => println!("Element at index 10: {}", value),
        None => println!("Index 10 is out of bounds"), // This will execute
    }

    // First and last methods
    println!("First: {:?}", numbers.first()); // Some(1)
    println!("Last: {:?}", numbers.last()); // Some(5)

    // Modifying arrays (must be mutable)
    let mut mutable_array = [1, 2, 3, 4, 5];
    println!("Before modification: {:?}", mutable_array); // [1, 2, 3, 4, 5]
    mutable_array[0] = 99;
    mutable_array[4] = 88;
    println!("After modification: {:?}", mutable_array); // [99, 2, 3, 4, 88]

    // Swapping elements
    mutable_array.swap(1, 3);
    println!("After swap(1, 3): {:?}", mutable_array); // [99, 4, 3, 2, 88]

    // Filling array with a value
    let mut fillable = [0; 5];
    fillable.fill(42);
    println!("After fill(42): {:?}", fillable); // [42, 42, 42, 42, 42]

    // Reversing array
    let mut reversible = [1, 2, 3, 4, 5];
    reversible.reverse();
    println!("Reversed: {:?}", reversible); // [5, 4, 3, 2, 1]

    // Sorting arrays
    let mut unsorted = [3, 1, 4, 1, 5, 9, 2, 6];
    println!("Before sort: {:?}", unsorted); // [3, 1, 4, 1, 5, 9, 2, 6]
    unsorted.sort();
    println!("After sort: {:?}", unsorted); // [1, 1, 2, 3, 4, 5, 6, 9]

    // Sort in reverse order
    unsorted.sort_by(|a, b| b.cmp(a));
    println!("Reverse sorted: {:?}", unsorted); // [9, 6, 5, 4, 3, 2, 1, 1]

    // Sorting strings
    let mut words = ["banana", "apple", "cherry", "date"];
    words.sort();
    println!("Sorted words: {:?}", words); // ["apple", "banana", "cherry", "date"]

    // Array slices - borrowing parts of arrays
    let full_array = [1, 2, 3, 4, 5, 6, 7, 8];
    let slice = &full_array[1..4]; // Elements at indices 1, 2, 3
    println!("Slice [1..4]: {:?}", slice); // [2, 3, 4]

    let first_three = &full_array[..3]; // First 3 elements
    println!("First three: {:?}", first_three); // [1, 2, 3]

    let last_three = &full_array[5..]; // From index 5 to end
    println!("Last three: {:?}", last_three); // [6, 7, 8]

    let entire_slice = &full_array[..]; // Entire array as slice
    println!("Entire slice: {:?}", entire_slice); // [1, 2, 3, 4, 5, 6, 7, 8]

    // Slice properties
    println!("Slice length: {}", slice.len()); // 3
    println!("Slice is empty: {}", slice.is_empty()); // false

    // Modifying through mutable slices - FIXED VERSION
    let mut modifiable = [1, 2, 3, 4, 5];
    println!("Before modifying slice: {:?}", modifiable); // [1, 2, 3, 4, 5]

    // Create scope to limit lifetime of mutable borrow
    {
        let mutable_slice = &mut modifiable[1..4];
        mutable_slice[0] = 99; // Modifies modifiable[1]
        mutable_slice[2] = 88; // Modifies modifiable[3]
    } // mutable_slice goes out of scope here, ending the mutable borrow

    println!("After modifying slice: {:?}", modifiable); // [1, 99, 3, 88, 5]

    // Iteration over arrays
    let fruits = ["apple", "banana", "cherry"];

    // Immutable iteration
    print!("Fruits: ");
    for fruit in &fruits {
        print!("{} ", fruit); // apple banana cherry
    }
    println!();

    // Iteration with index
    for (index, fruit) in fruits.iter().enumerate() {
        println!("Index {}: {}", index, fruit); // Index 0: apple, etc.
    }

    // Mutable iteration
    let mut numbers_mut = [1, 2, 3, 4, 5];
    for number in &mut numbers_mut {
        *number *= 2;
    }
    println!("After doubling: {:?}", numbers_mut); // [2, 4, 6, 8, 10]

    // Consuming iteration (ownership moved)
    let consumable = [10, 20, 30];
    for value in consumable {
        println!("Consumed: {}", value); // 10, 20, 30
    }
    // Array is still accessible because it implements Copy
    println!("Still accessible: {:?}", consumable); // [10, 20, 30]

    // Searching in arrays
    let search_array = [10, 20, 30, 40, 50];
    println!("Contains 30: {}", search_array.contains(&30)); // true
    println!("Contains 99: {}", search_array.contains(&99)); // false

    // Finding position
    match search_array.iter().position(|&x| x == 30) {
        Some(index) => println!("Found 30 at index: {}", index), // Found 30 at index: 2
        None => println!("30 not found"),
    }

    // Find first element matching condition
    match search_array.iter().find(|&&x| x > 25) {
        Some(value) => println!("First value > 25: {}", value), // First value > 25: 30
        None => println!("No value > 25 found"),
    }

    // Functional operations with iterators
    let data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // Map - transform each element
    let squares: Vec<i32> = data.iter().map(|x| x * x).collect();
    println!("Squares: {:?}", squares); // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

    // Filter - keep elements matching condition
    let evens: Vec<&i32> = data.iter().filter(|&x| x % 2 == 0).collect();
    println!("Evens: {:?}", evens); // [2, 4, 6, 8, 10]

    // Chain operations
    let processed: Vec<i32> = data
        .iter()
        .filter(|&x| x % 2 == 0) // Keep evens
        .map(|x| x * x) // Square them
        .collect();
    println!("Even squares: {:?}", processed); // [4, 16, 36, 64, 100]

    // Fold/reduce operations
    let sum: i32 = data.iter().sum();
    println!("Sum: {}", sum); // 55

    let product: i32 = data.iter().product();
    println!("Product: {}", product); // 3628800

    // Custom fold
    let sum_of_squares: i32 = data.iter().fold(0, |acc, x| acc + x * x);
    println!("Sum of squares: {}", sum_of_squares); // 385

    // Checking conditions
    let all_positive = data.iter().all(|&x| x > 0);
    println!("All positive: {}", all_positive); // true

    let any_greater_than_5 = data.iter().any(|&x| x > 5);
    println!("Any > 5: {}", any_greater_than_5); // true

    // Splitting arrays
    let split_data = [1, 2, 3, 4, 5, 6, 7, 8];
    let (left, right) = split_data.split_at(4);
    println!("Left half: {:?}", left); // [1, 2, 3, 4]
    println!("Right half: {:?}", right); // [5, 6, 7, 8]

    // Chunking arrays
    let chunk_data = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    for chunk in chunk_data.chunks(3) {
        println!("Chunk: {:?}", chunk); // [1, 2, 3], [4, 5, 6], [7, 8, 9]
    }

    // Windows - overlapping slices
    let window_data = [1, 2, 3, 4, 5];
    for window in window_data.windows(3) {
        println!("Window: {:?}", window); // [1, 2, 3], [2, 3, 4], [3, 4, 5]
    }

    // Comparing arrays
    let array1 = [1, 2, 3];
    let array2 = [1, 2, 3];
    let array3 = [3, 2, 1];
    println!("array1 == array2: {}", array1 == array2); // true
    println!("array1 == array3: {}", array1 == array3); // false
    println!("array1 < array3: {}", array1 < array3); // true (lexicographic)

    // Converting between arrays and other types
    let array_to_vec = [1, 2, 3, 4, 5];
    let as_vec: Vec<i32> = array_to_vec.to_vec();
    println!("Array as Vec: {:?}", as_vec); // [1, 2, 3, 4, 5]

    // From slice to array (requires exact size match)
    let slice_data = [1, 2, 3, 4, 5];
    let slice = &slice_data[1..4]; // [2, 3, 4]

    // Convert slice to array using try_into
    use std::convert::TryInto;
    let array_from_slice: [i32; 3] = slice.try_into().unwrap();
    println!("Array from slice: {:?}", array_from_slice); // [2, 3, 4]

    // Multi-dimensional arrays
    let matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
    println!("Matrix: {:?}", matrix); // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    println!("Element at [1][2]: {}", matrix[1][2]); // 6

    // Iterating over 2D array
    for (row_index, row) in matrix.iter().enumerate() {
        for (col_index, value) in row.iter().enumerate() {
            println!("matrix[{}][{}] = {}", row_index, col_index, value);
        }
    }

    // Copying arrays
    let original = [1, 2, 3, 4, 5];
    let copied = original; // Arrays implement Copy trait
    println!("Original: {:?}", original); // [1, 2, 3, 4, 5]
    println!("Copied: {:?}", copied); // [1, 2, 3, 4, 5]

    // Cloning arrays (same as copy for primitive types)
    let cloned = original.clone();
    println!("Cloned: {:?}", cloned); // [1, 2, 3, 4, 5]

    // Array of strings (non-Copy type)
    let string_array = ["hello", "world", "rust"];
    let string_slice = &string_array[..]; // Create slice
    println!("String array: {:?}", string_array); // ["hello", "world", "rust"]
    println!("String slice: {:?}", string_slice); // ["hello", "world", "rust"]

    // Binary search (requires sorted array)
    let sorted_array = [1, 3, 5, 7, 9, 11, 13, 15];
    match sorted_array.binary_search(&7) {
        Ok(index) => println!("Found 7 at index: {}", index), // Found 7 at index: 3
        Err(index) => println!("7 would be inserted at index: {}", index),
    }

    match sorted_array.binary_search(&8) {
        Ok(index) => println!("Found 8 at index: {}", index),
        Err(index) => println!("8 would be inserted at index: {}", index), // 8 would be inserted at index: 4
    }
}
