// Stack-only data and the Copy trait vs Clone
// Copy trait: for types that can be duplicated by copying bits
// Clone trait: for types that need explicit duplication

fn main() {
    // Copy trait - automatic for stack-stored simple types
    let x = 5;
    let y = x; // x is copied, not moved
    println!("x: {}, y: {}", x, y); // x: 5, y: 5

    // Types that implement Copy
    let a: i32 = 42;
    let b = a;
    println!("Both valid: a = {}, b = {}", a, b); // Both valid: a = 42, b = 42

    let c: f64 = 3.14;
    let d = c;
    println!("Floats: c = {}, d = {}", c, d); // Floats: c = 3.14, d = 3.14

    let e: bool = true;
    let f = e;
    println!("Bools: e = {}, f = {}", e, f); // Bools: e = true, f = true

    let g: char = 'A';
    let h = g;
    println!("Chars: g = {}, h = {}", g, h); // Chars: g = A, h = A

    // Tuples of Copy types also implement Copy
    let point = (3, 5);
    let another_point = point;
    println!("Tuples: {:?} and {:?}", point, another_point); // Tuples: (3, 5) and (3, 5)

    // Arrays of Copy types implement Copy
    let arr1 = [1, 2, 3, 4, 5];
    let arr2 = arr1;
    println!("Arrays: {:?} and {:?}", arr1, arr2); // Arrays: [1, 2, 3, 4, 5] and [1, 2, 3, 4, 5]

    // String doesn't implement Copy (heap-allocated)
    let s1 = String::from("hello");
    let s2 = s1; // s1 is moved, not copied
    // println!("s1: {}", s1);  // Error: value borrowed after move
    println!("s2: {}", s2); // s2: hello

    // Clone trait - explicit deep copy
    let s3 = String::from("world");
    let s4 = s3.clone(); // Deep copy
    println!("Both valid: s3 = {}, s4 = {}", s3, s4); // Both valid: s3 = world, s4 = world

    // Vectors need clone
    let v1 = vec![1, 2, 3];
    let v2 = v1.clone();
    println!("Vectors: {:?} and {:?}", v1, v2); // Vectors: [1, 2, 3] and [1, 2, 3]

    // Custom struct with Copy
    #[derive(Debug, Copy, Clone)]
    #[allow(dead_code)]
    struct Point {
        x: i32,
        y: i32,
    }

    let p1 = Point { x: 10, y: 20 };
    let p2 = p1; // Copy happens automatically
    println!("Points: {:?} and {:?}", p1, p2); // Points: Point { x: 10, y: 20 } and Point { x: 10, y: 20 }

    // Custom struct without Copy (contains String)
    #[derive(Debug, Clone)]
    #[allow(dead_code)]
    struct Person {
        name: String,
        age: u32,
    }

    let person1 = Person {
        name: String::from("Alice"),
        age: 30,
    };

    let person2 = person1; // person1 is moved
    // println!("{:?}", person1);  // Error: value borrowed after move
    println!("{:?}", person2); // Person { name: "Alice", age: 30 }

    let person3 = Person {
        name: String::from("Bob"),
        age: 25,
    };
    let person4 = person3.clone(); // Explicit clone
    println!("Both valid: {:?} and {:?}", person3, person4);
    // Both valid: Person { name: "Bob", age: 25 } and Person { name: "Bob", age: 25 }

    // References always copy (the reference, not the data)
    let s5 = String::from("reference");
    let r1 = &s5;
    let r2 = r1; // r1 is copied (both point to s5)
    println!("References: {} and {}", r1, r2); // References: reference and reference

    // Function demonstrating Copy behavior
    fn takes_copy(x: i32) {
        println!("Got: {}", x);
    }

    let num = 42;
    takes_copy(num);
    println!("Still have: {}", num); // Still have: 42

    // Function demonstrating move behavior
    fn takes_ownership(s: String) {
        println!("Got: {}", s);
    }

    let s6 = String::from("moved");
    takes_ownership(s6);
    // println!("s6: {}", s6);  // Error: value borrowed after move

    // Clone in collections
    let original = vec![String::from("a"), String::from("b")];
    let cloned = original.clone();
    println!("Original: {:?}", original); // Original: ["a", "b"]
    println!("Cloned: {:?}", cloned); // Cloned: ["a", "b"]

    // Partial moves and clones
    #[derive(Debug, Clone)]
    struct Container {
        value: String,
        count: i32, // Copy type
    }

    let c1 = Container {
        value: String::from("data"),
        count: 10,
    };

    let c2 = Container {
        value: c1.value.clone(), // Need to clone String
        count: c1.count,         // Copy happens automatically
    };

    println!("c1: {:?}", c1); // c1: Container { value: "data", count: 10 }
    println!("c2: {:?}", c2); // c2: Container { value: "data", count: 10 }

    // Option and Result with Copy types
    let maybe_num: Option<i32> = Some(42);
    let copy_maybe = maybe_num; // Copy happens
    println!("Both valid: {:?} and {:?}", maybe_num, copy_maybe);
    // Both valid: Some(42) and Some(42)

    // Option with non-Copy types needs clone
    let maybe_string: Option<String> = Some(String::from("hello"));
    let clone_maybe = maybe_string.clone();
    println!("Both valid: {:?} and {:?}", maybe_string, clone_maybe);
    // Both valid: Some("hello") and Some("hello")

    // Understanding when to use Clone
    let expensive_data = vec![0; 1000000]; // Large vector
    let start = std::time::Instant::now();
    let cloned_data = expensive_data.clone();
    let duration = start.elapsed();
    println!("Clone took: {:?}", duration);
    println!(
        "Original len: {}, Cloned len: {}",
        expensive_data.len(),
        cloned_data.len()
    );
    // Original len: 1000000, Cloned len: 1000000
}
