//! This file demonstrates all types of comments in Rust
//! Inner doc comments go at the very top of the file

fn main() {
    // LINE COMMENTS

    // This is a single-line comment
    // Line comments start with // and continue until the end of the line
    // They are the most common type of comment in Rust code

    let x = 5; // Comments can also appear at the end of lines with code

    /* BLOCK COMMENTS */

    /* This is a block comment.
       Block comments can span multiple lines.
       They start with /* and end with */
    */

    /*
     * Some people prefer to add an asterisk at the beginning of each line
     * in a multi-line block comment. This is just a style preference.
     * Rust doesn't care either way.
     */

    /* Block comments /* can be nested */ like this */

    // Block comments are less common in Rust compared to line comments
    // Most Rustaceans prefer to use line comments for typical code documentation

    /*
    Block comments are useful when you need to temporarily
    comment out a large section of code:

    let unused_variable = 10;
    println!("This code won't run");
    for i in 0..10 {
        println!("{}", i);
    }
    */

    // DOCUMENTATION COMMENTS

    // Documentation comments are special comments that generate documentation
    // They use three slashes (///) or exclamation points (//!)

    // Call the function to avoid unused function warning
    let result = example_function(5);
    println!("Result of example_function(5): {}", result);

    // Documentation comments are commonly used for functions, structs, enums, etc.
    // They describe what the code does, parameters, return values, examples,
    // and other useful information.

    // Inner documentation comments (//!) are used to document the container
    // (module, crate, file) rather than a specific item.
    // These typically appear at the top of a file or module.

    // Comment conventions and best practices:

    // 1. Use line comments for explanations of code
    let complicated_calculation = {
        // Calculate the square of the sum of x and y
        let x = 5;
        let y = 10;
        (x + y) * (x + y)
    };
    println!(
        "Complicated calculation result: {}",
        complicated_calculation
    );

    // 2. Use documentation comments for public API

    // 3. Write comments that explain WHY, not WHAT
    // Bad:  // Increment x by 1
    // Good: // Compensate for the off-by-one error in the loop

    // 4. Keep comments updated when code changes

    // 5. Use TODOs for temporary notes
    // TODO: Refactor this to use a more efficient algorithm
    let sum: i32 = (1..101).sum();
    println!("Sum from 1 to 100: {}", sum);

    // 6. Use FIXME for code that needs attention
    // FIXME: This approach may cause overflow for large inputs

    // Generating documentation:
    // You can generate HTML documentation with 'cargo doc'
    // View it with 'cargo doc --open'

    // Using comments for debugging:
    // println!("Debug: x = {}", x); // Temporarily comment out debug prints

    // Remember, the best code is self-documenting!
    // Use clear variable and function names, and add comments for complex logic
    let user_age = 30; // More clear than 'let a = 30;'
    println!("User age: {}", user_age);

    // Demonstrate the string_utils module
    use_string_utils();

    // Using the unused variable to avoid warning
    println!("The variable x = {}", x);
}

/// This is a documentation comment (///)
/// Documentation comments support Markdown formatting
///
/// # Examples
///
/// ```
/// // You can include code examples that will be tested
/// let x = example_function(5);
/// assert_eq!(x, 10);
/// ```
fn example_function(x: i32) -> i32 {
    x * 2
}

/// This module contains utilities for working with strings.
///
/// The module provides functions to manipulate and analyze string data.
mod string_utils {
    /// Counts the number of words in a string, separated by whitespace.
    ///
    /// # Arguments
    ///
    /// * `text` - The string to analyze
    ///
    /// # Returns
    ///
    /// The number of words in the text
    ///
    /// # Examples
    ///
    /// ```
    /// let count = string_utils::count_words("Hello world");
    /// assert_eq!(count, 2);
    /// ```
    pub fn count_words(text: &str) -> usize {
        text.split_whitespace().count()
    }
}

// Demonstrate the string_utils module
fn use_string_utils() {
    let text = "Rust is awesome for systems programming";
    let word_count = string_utils::count_words(text);
    println!("Word count: {}", word_count);
}
