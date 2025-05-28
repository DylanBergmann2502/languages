// Introduction to lifetimes
// Lifetimes prevent dangling references
// They ensure references are valid as long as they're used
// Every reference has a lifetime, often inferred by the compiler

fn main() {
    // Basic lifetime example - compiler infers lifetimes
    let string1 = String::from("hello");
    let result;
    {
        let string2 = String::from("world");
        result = longest(&string1, &string2);
        println!("Longest inside scope: {}", result); // Longest inside scope: hello
    } // string2 goes out of scope here
    // println!("Result: {}", result); // Error: string2 doesn't live long enough

    // Same lifetime scope
    let string3 = String::from("short");
    let string4 = String::from("longer");
    let result2 = longest(&string3, &string4);
    println!("Longest: {}", result2); // Longest: longer

    // String literals have 'static lifetime
    let s1 = "literal"; // &'static str
    let s2 = String::from("heap");
    let result3 = longest_mixed(s1, &s2);
    println!("Mixed longest: {}", result3); // Mixed longest: literal

    // Lifetime annotations in structs
    #[derive(Debug)]
    struct ImportantExcerpt<'a> {
        part: &'a str,
    }

    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    let excerpt = ImportantExcerpt {
        part: first_sentence,
    };
    println!("Excerpt: {:?}", excerpt); // Excerpt: ImportantExcerpt { part: "Call me Ishmael" }

    // Lifetime elision rules
    let s = String::from("hello");
    let len = first_word(&s);
    println!("First word: {}", &s[..len]); // First word: hello

    // Multiple lifetime parameters
    let string5 = String::from("abc");
    let string6 = String::from("xyz");
    let announcement = "Breaking news!";
    let result4 = longest_with_announcement(&string5, &string6, announcement);
    println!("Result with announcement: {}", result4); // Result with announcement: Breaking news! abc

    // Lifetime constraints
    let r;
    {
        let x = 5;
        r = &x;
        // Can use r here while x is still in scope
        println!("r inside scope: {}", r); // r inside scope: 5
    } // x goes out of scope
    // println!("r outside scope: {}", r); // Error: x doesn't live long enough

    // References in function returns
    let string7 = String::from("test");
    let result5 = no_dangle(&string7);
    println!("No dangle: {}", result5); // No dangle: test

    // Different lifetimes in same function
    let long_lived = String::from("long string");
    let result6;
    {
        let short_lived = String::from("short");
        result6 = choose_first(&long_lived, &short_lived);
        println!("Chosen (inside): {}", result6); // Chosen (inside): long string
    }
    println!("Chosen (outside): {}", result6); // Chosen (outside): long string

    // Static lifetime
    let s: &'static str = "I have a static lifetime";
    println!("Static: {}", s); // Static: I have a static lifetime

    // Mutable references with lifetimes
    let mut data = String::from("mutable");
    let result7 = append_world(&mut data);
    println!("Appended: {}", result7); // Appended: mutable world
    println!("Original modified: {}", data); // Original modified: mutable world

    // Complex lifetime example with methods
    impl<'a> ImportantExcerpt<'a> {
        fn level(&self) -> i32 {
            3
        }

        fn announce_and_return_part(&self, announcement: &str) -> &str {
            println!("Attention please: {}", announcement);
            self.part
        }
    }

    let excerpt2 = ImportantExcerpt {
        part: "the quick brown fox",
    };
    println!("Level: {}", excerpt2.level()); // Level: 3
    let part = excerpt2.announce_and_return_part("Listen up!");
    println!("Part: {}", part); // Part: the quick brown fox

    // Lifetime bounds on generic types
    fn longest_generic<'a, T: std::fmt::Display>(x: &'a T, y: &'a T) -> &'a T {
        if x.to_string().len() > y.to_string().len() {
            x
        } else {
            y
        }
    }

    let num1 = 42;
    let num2 = 123;
    let result8 = longest_generic(&num1, &num2);
    println!("Longest number: {}", result8); // Longest number: 123

    // Nested lifetime scopes
    let outer = String::from("outer");
    let result9;
    {
        let inner = String::from("inner string");
        result9 = if outer.len() > inner.len() {
            &outer
        } else {
            &inner
        };
        println!("Nested comparison: {}", result9); // Nested comparison: inner string
    }
    // Can't use result9 here because inner doesn't live long enough

    // Lifetime subtyping
    let string_static: &'static str = "static";
    let result10 = accepts_static(string_static);
    println!("Static accepted: {}", result10); // Static accepted: static
}

// Lifetime annotations are needed when multiple references could have different lifetimes
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// Mixed lifetimes - static and regular
fn longest_mixed<'a>(x: &'static str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// Lifetime elision - compiler infers lifetime
fn first_word(s: &str) -> usize {
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    }
    s.len()
}

// Multiple lifetime parameters with constraint
fn longest_with_announcement<'a, 'b>(x: &'a str, y: &'a str, ann: &'b str) -> &'a str {
    println!("{}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// Correct way to return a reference
fn no_dangle(s: &str) -> &str {
    s
}

// Different input lifetimes, returns first
fn choose_first<'a, 'b>(first: &'a str, _second: &'b str) -> &'a str {
    first
}

// Mutable reference with lifetime
fn append_world<'a>(s: &'a mut String) -> &'a mut String {
    s.push_str(" world");
    s
}

// Function accepting static lifetime
fn accepts_static(s: &'static str) -> &'static str {
    s
}
