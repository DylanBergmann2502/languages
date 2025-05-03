fn main() {
    // IF EXPRESSIONS
    println!("--- IF EXPRESSIONS ---");

    let number = 7;

    // Basic if expression
    if number < 5 {
        println!("condition was true");
    } else {
        println!("condition was false");
    }

    // Multiple conditions with else if
    if number % 2 == 0 {
        println!("{} is even", number);
    } else if number % 3 == 0 {
        println!("{} is divisible by 3", number);
    } else {
        println!("{} is not even or divisible by 3", number);
    }

    // If is an expression, so it can be used on the right side of a let statement
    let condition = true;
    let result = if condition {
        "condition was true"
    } else {
        "condition was false"
    };
    println!("Result: {}", result);

    // Both arms of an if used in assignment must have the same type
    let number = if condition { 5 } else { 6 };
    println!("Number: {}", number);

    // LOOPS
    println!("\n--- LOOPS ---");

    // loop - repeats until explicitly told to stop
    println!("\n-- loop --");

    let mut counter = 0;

    // Basic loop with break
    loop {
        counter += 1;
        println!("Loop iteration: {}", counter);

        if counter >= 3 {
            break; // Exit the loop
        }
    }

    // Returning values from loops
    let mut counter = 0;
    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2; // Return this value when breaking
        }
    };
    println!("Result from loop: {}", result);

    // Nested loops and labels
    println!("\nNested loops with labels:");
    'outer: loop {
        println!("Entered outer loop");

        'inner: loop {
            println!("Entered inner loop");

            // Use the inner label (although not really necessary here)
            break 'inner; // or simply 'break' would work the same here

            // Alternatively, break the outer loop from inside the inner loop:
            // break 'outer;
        }

        println!("Exited inner loop");
        break; // Break the outer loop
    }
    println!("Exited outer loop");

    // while - conditional loop
    println!("\n-- while --");

    let mut number = 3;

    while number != 0 {
        println!("{}!", number);
        number -= 1;
    }
    println!("while loop finished!");

    // for - iterate over collections
    println!("\n-- for --");

    // Iterating over a range
    println!("\nIterating over range 1..4:");
    for i in 1..4 {
        println!("Number: {}", i);
    }

    // Inclusive range
    println!("\nIterating over inclusive range 1..=3:");
    for i in 1..=3 {
        println!("Number: {}", i);
    }

    // Iterating over a collection
    println!("\nIterating over an array:");
    let animals = ["cat", "dog", "fish", "bird"];

    for animal in animals.iter() {
        println!("Animal: {}", animal);
    }

    // Using enumerate to get indices
    println!("\nUsing enumerate:");
    for (index, animal) in animals.iter().enumerate() {
        println!("Animal {} is {}", index, animal);
    }

    // Iterating in reverse with rev()
    println!("\nReverse iteration:");
    for number in (1..4).rev() {
        println!("{}!", number);
    }
    println!("Liftoff!");

    // continue - skip to the next iteration
    println!("\n-- continue --");

    for i in 1..6 {
        if i % 2 == 0 {
            continue; // Skip even numbers
        }
        println!("Odd number: {}", i);
    }

    // MATCH EXPRESSIONS
    println!("\n--- MATCH EXPRESSIONS ---");

    let number = 13;

    // Basic match
    match number {
        // Match a single value
        1 => println!("One!"),
        // Match multiple values
        2 | 3 => println!("Two or Three!"),
        // Match a range
        4..=10 => println!("Between 4 and 10"),
        // Default case (like else)
        _ => println!("Something else: {}", number),
    }

    // Using match as an expression
    let description = match number {
        1 => "one",
        2 => "two",
        _ => "many",
    };
    println!("{} is {}", number, description);

    // Pattern binding with @
    match number {
        n @ 1..=12 => println!("Month number: {}", n),
        n @ 13..=19 => println!("Teen number: {}", n),
        n => println!("Other number: {}", n),
    }

    // IF LET - simplified match for single pattern
    println!("\n--- IF LET ---");

    let some_value = Some(3);

    // Verbose way with match
    match some_value {
        Some(3) => println!("three!"),
        _ => (),
    }

    // Cleaner way with if let
    if let Some(3) = some_value {
        println!("three!");
    }

    // If let with else
    if let Some(x) = some_value {
        println!("Got a value: {}", x);
    } else {
        println!("Didn't get a value");
    }

    // WHILE LET - conditional loop based on pattern match
    println!("\n--- WHILE LET ---");

    let mut stack = Vec::new();
    stack.push(1);
    stack.push(2);
    stack.push(3);

    // Pop values while there are some
    while let Some(top) = stack.pop() {
        println!("Popped: {}", top);
    }
}
