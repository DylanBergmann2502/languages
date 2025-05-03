// booleans.rs

fn main() {
    // Boolean type in Rust
    let true_value: bool = true;
    let false_value: bool = false;

    println!("true_value: {}", true_value); // true
    println!("false_value: {}", false_value); // false

    // Type inference works for booleans
    let inferred_bool = true;
    println!("\nInferred boolean: {}", inferred_bool); // true

    // Logical operations
    println!("\nLogical operations:");
    let a = true;
    let b = false;

    // Using the variables to avoid warnings
    println!("a && b: {}", a && b); // false
    println!("a || b: {}", a || b); // true

    println!("\ntrue && true: {}", true && true); // true
    println!("true && false: {}", true && false); // false
    println!("false && true: {}", false && true); // false
    println!("false && false: {}", false && false); // false

    println!("\ntrue || true: {}", true || true); // true
    println!("true || false: {}", true || false); // true
    println!("false || true: {}", false || true); // true
    println!("false || false: {}", false || false); // false

    println!("\n!true: {}", !true); // false
    println!("!false: {}", !false); // true

    // Short-circuit evaluation
    println!("\nShort-circuit evaluation:");

    fn expensive_computation() -> bool {
        println!("Expensive computation called!");
        true
    }

    // The second operand is not evaluated if the first determines the result
    println!("false && expensive_computation():");
    let result = false && expensive_computation(); // expensive_computation() is not called
    println!("Result: {}", result); // false

    println!("\ntrue || expensive_computation():");
    let result = true || expensive_computation(); // expensive_computation() is not called
    println!("Result: {}", result); // true

    println!("\ntrue && expensive_computation():");
    let result = true && expensive_computation(); // expensive_computation() IS called
    println!("Result: {}", result); // true

    // Comparison operations return booleans
    println!("\nComparison operations:");
    println!("5 > 3: {}", 5 > 3); // true
    println!("5 < 3: {}", 5 < 3); // false
    println!("5 == 5: {}", 5 == 5); // true
    println!("5 != 5: {}", 5 != 5); // false
    println!("5 >= 5: {}", 5 >= 5); // true
    println!("5 <= 5: {}", 5 <= 5); // true

    // Booleans in control flow
    println!("\nControl flow with booleans:");
    let condition = true;

    if condition {
        println!("Condition is true");
    } else {
        println!("Condition is false");
    }

    // Using boolean expressions directly
    let age = 25;
    if age >= 18 {
        println!("Adult");
    } else {
        println!("Minor");
    }

    // Boolean methods
    println!("\nBoolean methods:");
    let b = true;

    // The then() method runs a closure if true
    let result = b.then(|| 42);
    println!("true.then(|| 42): {:?}", result); // Some(42)

    let b = false;
    let result = b.then(|| 42);
    println!("false.then(|| 42): {:?}", result); // None

    // The then_some() method returns Some(value) if true
    let b = true;
    let result = b.then_some(42);
    println!("true.then_some(42): {:?}", result); // Some(42)

    let b = false;
    let result = b.then_some(42);
    println!("false.then_some(42): {:?}", result); // None

    // Converting to/from integers
    println!("\nConversion with integers:");
    let true_as_int = true as i32;
    let false_as_int = false as i32;

    println!("true as i32: {}", true_as_int); // 1
    println!("false as i32: {}", false_as_int); // 0

    // Note: You cannot cast integers to bool directly
    // This won't compile: let bool_from_int = 1 as bool;
    // Instead, use comparison:
    let bool_from_int = 1 != 0;
    println!("1 != 0: {}", bool_from_int); // true

    // Pattern matching with booleans
    println!("\nPattern matching:");
    let value = true;

    match value {
        true => println!("It's true!"),
        false => println!("It's false!"),
    }

    // You can also use if let with booleans (though it's unusual)
    if let true = value {
        println!("Value is true");
    }

    // Booleans implement common traits
    println!("\nTrait implementations:");

    // Display trait
    println!("Display: {}", true); // true

    // Debug trait
    println!("Debug: {:?}", false); // false

    // PartialEq and Eq traits (for equality comparison)
    println!("true == true: {}", true == true); // true
    println!("true == false: {}", true == false); // false

    // Ord trait (for ordering)
    println!("false < true: {}", false < true); // true (false is considered less than true)

    // Default trait
    let default_bool: bool = Default::default();
    println!("Default bool: {}", default_bool); // false

    // Using booleans in structs
    #[derive(Debug)]
    struct User {
        name: String,
        is_active: bool,
        is_admin: bool,
    }

    let user = User {
        name: String::from("Alice"),
        is_active: true,
        is_admin: false,
    };

    println!("\nStruct with booleans: {:?}", user);
    // Let's actually access the fields to avoid dead code warnings
    println!("User {} is active: {}", user.name, user.is_active);
    println!("User {} is admin: {}", user.name, user.is_admin);

    // Bitwise operations on booleans
    println!("\nBitwise operations on booleans:");
    println!("true & true: {}", true & true); // true
    println!("true & false: {}", true & false); // false
    println!("true | false: {}", true | false); // true
    println!("true ^ true: {}", true ^ true); // false (XOR)
    println!("true ^ false: {}", true ^ false); // true

    // Note: & and | don't short-circuit like && and ||
    fn side_effect() -> bool {
        println!("Side effect executed!");
        true
    }

    println!("\nDifference between && and &:");
    println!("false && side_effect():");
    let _ = false && side_effect(); // side_effect() is NOT called

    println!("\nfalse & side_effect():");
    let _ = false & side_effect(); // side_effect() IS called

    // Size of bool
    println!("\nSize of bool: {} byte", std::mem::size_of::<bool>()); // 1 byte

    // Booleans in collections
    let bool_array: [bool; 4] = [true, false, true, false];
    println!("\nBoolean array: {:?}", bool_array);

    let bool_vec: Vec<bool> = vec![true, true, false];
    println!("Boolean vector: {:?}", bool_vec);

    // Practical example: form validation
    fn validate_password(password: &str) -> bool {
        let has_minimum_length = password.len() >= 8;
        let has_uppercase = password.chars().any(|c| c.is_uppercase());
        let has_lowercase = password.chars().any(|c| c.is_lowercase());
        let has_digit = password.chars().any(|c| c.is_digit(10));

        has_minimum_length && has_uppercase && has_lowercase && has_digit
    }

    println!("\nPassword validation:");
    println!("'password': {}", validate_password("password")); // false
    println!("'Password123': {}", validate_password("Password123")); // true
}
