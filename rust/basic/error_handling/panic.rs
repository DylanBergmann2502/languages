// Understanding panic! in Rust
// panic! is Rust's way of handling unrecoverable errors
// When a panic occurs, the program will terminate (by default)
// Panics unwind the stack, running destructors and cleaning up
// panic! should be used sparingly - prefer Result<T, E> for recoverable errors
// Common causes: index out of bounds, unwrap() on None/Err, explicit panic! calls
// Can be caught with std::panic::catch_unwind for some use cases

use std::panic;
use std::thread;
use std::time::Duration;

// Custom struct to demonstrate Drop trait during panic
#[derive(Debug)]
struct ResourceManager {
    name: String,
    resource_id: u32,
}

impl ResourceManager {
    fn new(name: &str, id: u32) -> Self {
        println!("📦 Creating resource: {} (id: {})", name, id);
        ResourceManager {
            name: name.to_string(),
            resource_id: id,
        }
    }
}

// Drop trait shows what happens during cleanup
impl Drop for ResourceManager {
    fn drop(&mut self) {
        println!(
            "🗑️  Cleaning up resource: {} (id: {})",
            self.name, self.resource_id
        );
    }
}

// Function demonstrating different ways panics can occur
fn demonstrate_panic_causes() {
    println!("=== Common Panic Causes ===");

    // 1. Explicit panic! macro
    fn explicit_panic_demo() {
        println!("About to explicitly panic...");
        panic!("This is an explicit panic with a custom message!");
    }

    // 2. Array/Vector index out of bounds
    fn index_panic_demo() {
        let numbers = vec![1, 2, 3];
        println!("Accessing valid index: {}", numbers[1]); // OK
        println!("About to access invalid index...");
        let _value = numbers[10]; // This will panic!
    }

    // 3. unwrap() on None
    fn option_unwrap_panic_demo() {
        let some_value: Option<i32> = Some(42);
        let none_value: Option<i32> = None;

        println!("Unwrapping Some: {}", some_value.unwrap()); // OK
        println!("About to unwrap None...");
        none_value.unwrap(); // This will panic!
    }

    // 4. unwrap() on Err
    fn result_unwrap_panic_demo() {
        let ok_result: Result<i32, &str> = Ok(42);
        let err_result: Result<i32, &str> = Err("Something went wrong");

        println!("Unwrapping Ok: {}", ok_result.unwrap()); // OK
        println!("About to unwrap Err...");
        err_result.unwrap(); // This will panic!
    }

    // 5. Integer overflow (in debug mode)
    fn overflow_panic_demo() {
        println!("About to cause integer overflow...");
        let max_value = i32::MAX;
        // This would overflow: let _overflow = max_value + 1;
        println!("Max value is: {}", max_value);
    }

    // Note: We'll demonstrate these safely later with catch_unwind
    println!("All panic demos are prepared (but commented out to prevent actual panics)");
    println!("We'll show them safely using catch_unwind later...");
}

// Function demonstrating panic with custom messages
fn custom_panic_messages() {
    println!("\n=== Custom Panic Messages ===");

    fn validate_age(age: i32) -> u32 {
        if age < 0 {
            panic!("Age cannot be negative! Received: {}", age);
        }
        if age > 150 {
            panic!("Age {} is unrealistic for a human!", age);
        }
        age as u32
    }

    fn validate_email(email: &str) -> &str {
        if !email.contains('@') {
            panic!("Invalid email format: '{}' - missing @ symbol", email);
        }
        if email.len() < 5 {
            panic!("Email '{}' is too short (minimum 5 characters)", email);
        }
        email
    }

    // These would panic, so we show the logic instead
    println!("Age validation function ready - would panic on negative or >150");
    println!("Email validation function ready - would panic on invalid format");

    // Example of what the panic messages would look like:
    println!("Example panic messages:");
    println!("  - 'Age cannot be negative! Received: -5'");
    println!("  - 'Age 200 is unrealistic for a human!'");
    println!("  - 'Invalid email format: 'invalid' - missing @ symbol'");
}

// Function demonstrating panic with resource cleanup
fn panic_with_cleanup() {
    println!("\n=== Panic with Resource Cleanup ===");

    fn simulate_work_with_panic() {
        let _resource1 = ResourceManager::new("Database Connection", 1);
        let _resource2 = ResourceManager::new("File Handle", 2);
        let _resource3 = ResourceManager::new("Network Socket", 3);

        println!("🔄 Doing some work...");
        println!("💥 Something went wrong!");

        // Simulate a panic - resources should be cleaned up
        panic!("Simulated failure during work!");
    }

    // We'll use catch_unwind to demonstrate this safely
    println!("Demonstrating resource cleanup during panic...");
    let result = panic::catch_unwind(|| {
        simulate_work_with_panic();
    });

    match result {
        Ok(_) => println!("✅ Work completed successfully"),
        Err(_) => println!("❌ Work panicked, but resources were cleaned up"),
    }
}

// Function demonstrating expect() vs unwrap()
fn expect_vs_unwrap() {
    println!("\n=== expect() vs unwrap() ===");

    // expect() provides custom error messages
    fn demonstrate_expect() {
        let _config_file: Option<String> = None;

        // This would panic with a custom message
        // config_file.expect("Configuration file must be provided at startup");

        println!("expect() provides custom panic messages for better debugging");
        println!("Example: 'Configuration file must be provided at startup'");
    }

    fn demonstrate_unwrap() {
        let _user_input: Result<i32, &str> = Err("invalid input");

        // This would panic with a generic message
        // user_input.unwrap();

        println!("unwrap() provides generic panic messages");
        println!("Example: 'called `Result::unwrap()` on an `Err` value: \"invalid input\"'");
    }

    demonstrate_expect();
    demonstrate_unwrap();

    println!("\n💡 Best Practice:");
    println!("   - Use expect() with descriptive messages for better debugging");
    println!("   - Avoid unwrap() in production code");
    println!("   - Prefer Result<T, E> and proper error handling");
}

// Function demonstrating assert macros
fn assert_macros() {
    println!("\n=== Assert Macros ===");

    // assert! - panics if condition is false
    let x = 5;
    assert!(x > 0, "x must be positive, got: {}", x); // OK
    println!("✅ assert!(x > 0) passed");

    // assert_eq! - panics if values are not equal
    let expected = 42;
    let actual = 42;
    assert_eq!(actual, expected, "Values don't match!"); // OK
    println!("✅ assert_eq!({}, {}) passed", actual, expected);

    // assert_ne! - panics if values are equal
    let a = 10;
    let b = 20;
    assert_ne!(a, b, "Values should be different!"); // OK
    println!("✅ assert_ne!({}, {}) passed", a, b);

    // debug_assert! - only panics in debug builds
    debug_assert!(x < 100, "This only checks in debug mode");
    println!("✅ debug_assert! passed (only checked in debug builds)");

    println!("\n💡 Assert Usage:");
    println!("   - Use for invariants that should never be false");
    println!("   - Great for testing and development");
    println!("   - debug_assert! variants are removed in release builds");
}

// Function demonstrating panic::catch_unwind
fn catching_panics() {
    println!("\n=== Catching Panics with catch_unwind ===");

    // Function that will definitely panic
    fn risky_operation(should_panic: bool) -> i32 {
        if should_panic {
            panic!("Operation failed!");
        }
        42
    }

    // Safe operation
    let result1 = panic::catch_unwind(|| risky_operation(false));
    match result1 {
        Ok(value) => println!("✅ Operation succeeded: {}", value),
        Err(_) => println!("❌ Operation panicked"),
    }

    // Panicking operation
    let result2 = panic::catch_unwind(|| risky_operation(true));
    match result2 {
        Ok(value) => println!("✅ Operation succeeded: {}", value),
        Err(_) => println!("❌ Operation panicked (caught safely)"),
    }

    // Catching panics from standard library functions
    let result3 = panic::catch_unwind(|| {
        let numbers = vec![1, 2, 3];
        numbers[10] // Index out of bounds
    });

    match result3 {
        Ok(value) => println!("✅ Got value: {}", value),
        Err(_) => println!("❌ Index out of bounds panic caught"),
    }

    println!("\n⚠️  Important Notes about catch_unwind:");
    println!("   - Should be used sparingly");
    println!("   - Mainly for FFI boundaries or plugin systems");
    println!("   - Cannot catch all panics (e.g., abort on double panic)");
    println!("   - Prefer proper error handling with Result<T, E>");
}

// Function demonstrating panic in threads
fn panic_in_threads() {
    println!("\n=== Panic in Threads ===");

    println!("🧵 Spawning thread that will panic...");

    let handle = thread::spawn(|| {
        println!("  Thread: Starting work...");
        thread::sleep(Duration::from_millis(100));
        println!("  Thread: About to panic!");
        panic!("Thread panic! This won't crash the main program.");
    });

    // Wait for the thread and handle its panic
    match handle.join() {
        Ok(_) => println!("✅ Thread completed successfully"),
        Err(_) => println!("❌ Thread panicked, but main program continues"),
    }

    println!("🚀 Main thread continues running after child thread panic");

    // Multiple threads, some panic, some don't
    println!("\n🧵 Spawning multiple threads...");
    let mut handles = vec![];

    for i in 0..3 {
        let handle = thread::spawn(move || {
            thread::sleep(Duration::from_millis(50 * i));
            if i == 1 {
                panic!("Thread {} panicked!", i);
            }
            println!("  Thread {} completed successfully", i);
            i * 10
        });
        handles.push(handle);
    }

    // Collect results
    for (i, handle) in handles.into_iter().enumerate() {
        match handle.join() {
            Ok(result) => println!("✅ Thread {} result: {}", i, result),
            Err(_) => println!("❌ Thread {} panicked", i),
        }
    }
}

// Function demonstrating when to use panic vs Result
fn panic_vs_result_guidelines() {
    println!("\n=== When to Use panic! vs Result ===");

    println!("🚨 Use panic! for:");
    println!("   ✓ Programming errors (bugs in your code)");
    println!("   ✓ Invariant violations that should never happen");
    println!("   ✓ Prototype/example code");
    println!("   ✓ Tests (assert! macros)");
    println!("   ✓ Situations where continuing would be unsafe");

    println!("\n✅ Use Result<T, E> for:");
    println!("   ✓ Expected error conditions");
    println!("   ✓ I/O operations (file not found, network errors)");
    println!("   ✓ User input validation");
    println!("   ✓ Parsing operations");
    println!("   ✓ Any recoverable error");

    // Examples of good panic usage
    fn safe_divide(a: f64, b: f64) -> f64 {
        if b == 0.0 {
            panic!("Division by zero is a programming error!"); // Could be Result instead
        }
        a / b
    }

    fn get_array_element<T>(arr: &[T], index: usize) -> &T {
        if index >= arr.len() {
            panic!(
                "Index {} out of bounds for array of length {}",
                index,
                arr.len()
            );
        }
        &arr[index]
    }

    // Examples of Result usage (better approach)
    fn safe_divide_result(a: f64, b: f64) -> Result<f64, &'static str> {
        if b == 0.0 {
            Err("Cannot divide by zero")
        } else {
            Ok(a / b)
        }
    }

    fn parse_positive_number(s: &str) -> Result<u32, String> {
        let num: u32 = s.parse().map_err(|_| "Invalid number format".to_string())?;
        if num == 0 {
            Err("Number must be positive".to_string())
        } else {
            Ok(num)
        }
    }

    println!("\n📝 Code Examples:");
    println!("   - panic! for array bounds checking (or use get() method)");
    println!("   - Result for division by zero in user-facing functions");
    println!("   - Result for parsing user input");
    println!("   - panic! for internal invariant violations");
}

// Function demonstrating panic hooks
fn panic_hooks() {
    println!("\n=== Custom Panic Hooks ===");

    // Set a custom panic hook
    panic::set_hook(Box::new(|panic_info| {
        println!("🔥 CUSTOM PANIC HANDLER TRIGGERED!");

        if let Some(location) = panic_info.location() {
            println!(
                "📍 Panic occurred in file '{}' at line {}",
                location.file(),
                location.line()
            );
        }

        if let Some(message) = panic_info.payload().downcast_ref::<&str>() {
            println!("💬 Panic message: {}", message);
        }

        println!("🧹 Custom cleanup logic could go here...");
    }));

    println!("✅ Custom panic hook installed");

    // Demonstrate the custom hook (safely)
    let result = panic::catch_unwind(|| {
        panic!("This panic will trigger our custom handler!");
    });

    match result {
        Ok(_) => println!("No panic occurred"),
        Err(_) => println!("Panic was caught after custom handler ran"),
    }

    // Reset to default panic hook
    let _ = panic::take_hook();
    println!("🔄 Reset to default panic hook");

    println!("\n💡 Panic Hook Use Cases:");
    println!("   - Logging panics to files or external services");
    println!("   - Custom crash reporting");
    println!("   - Cleanup operations before program termination");
    println!("   - Different panic behavior in production vs development");
}

// Function demonstrating panic safety in unsafe code
fn panic_and_unsafe() {
    println!("\n=== Panic Safety Considerations ===");

    println!("⚠️  Panic Safety Rules:");
    println!("   1. Don't panic while holding exclusive access to shared data");
    println!("   2. Be careful with panic in Drop implementations");
    println!("   3. Consider panic safety when writing unsafe code");
    println!("   4. Use RAII (Resource Acquisition Is Initialization)");

    // Example of panic-safe code
    struct PanicSafeCounter {
        count: std::cell::RefCell<i32>,
    }

    impl PanicSafeCounter {
        fn new() -> Self {
            PanicSafeCounter {
                count: std::cell::RefCell::new(0),
            }
        }

        fn increment_safely(&self) -> Result<i32, &'static str> {
            let mut count = self
                .count
                .try_borrow_mut()
                .map_err(|_| "Counter is already borrowed")?;

            *count += 1;
            Ok(*count)
        }

        // This could cause issues if it panics while borrowed
        fn increment_unsafely(&self) {
            let mut count = self.count.borrow_mut();
            *count += 1;
            // If panic happens here, RefCell stays borrowed!
        }
    }

    println!("📦 Example: PanicSafeCounter uses try_borrow_mut for safety");
    println!("   - Safe version returns Result");
    println!("   - Unsafe version could leave RefCell in bad state");
}

fn main() {
    println!("🦀 Understanding panic! in Rust");
    println!("================================");

    demonstrate_panic_causes();
    custom_panic_messages();
    panic_with_cleanup();
    expect_vs_unwrap();
    assert_macros();
    catching_panics();
    panic_in_threads();
    panic_vs_result_guidelines();
    panic_hooks();
    panic_and_unsafe();

    println!("\n=== Summary ===");
    println!("panic! is Rust's mechanism for unrecoverable errors:");
    println!("✓ Unwinds the stack and runs destructors");
    println!("✓ Should be used sparingly - prefer Result<T, E>");
    println!("✓ Can be caught with catch_unwind (use carefully)");
    println!("✓ Thread panics don't crash the main program");
    println!("✓ Custom panic hooks allow custom handling");
    println!("✓ Be mindful of panic safety in your code");
    println!("✓ Use assert! macros for testing and invariants");

    println!("\n🎯 Remember: panic! means 'this should never happen'");
    println!("   For expected errors, use Result<T, E> instead!");
}

// Key takeaways:
// 1. panic! is for unrecoverable errors and programming bugs
// 2. Panics unwind the stack and run destructors (cleanup)
// 3. Use Result<T, E> for recoverable errors
// 4. expect() is better than unwrap() for debugging
// 5. Assert macros are great for testing and invariants
// 6. catch_unwind can catch panics but use sparingly
// 7. Thread panics are isolated from the main thread
// 8. Custom panic hooks allow custom error handling
// 9. Be careful about panic safety in unsafe code
// 10. panic! should be rare in production code
