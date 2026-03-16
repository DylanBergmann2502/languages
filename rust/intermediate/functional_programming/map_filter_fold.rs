use std::collections::HashMap;

fn main() {
    let numbers = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    // --- MAP ---
    // Transforms each element, returns a new iterator

    let doubled: Vec<i32> = numbers.iter().map(|&x| x * 2).collect();
    println!("{:?}", doubled); // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

    let squares: Vec<i32> = numbers.iter().map(|&x| x * x).collect();
    println!("{:?}", squares); // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

    let strings: Vec<String> = numbers.iter().map(|x| x.to_string()).collect();
    println!("{:?}", strings); // ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    // map over strings
    let words = vec!["hello", "world", "rust"];
    let uppercased: Vec<String> = words.iter().map(|s| s.to_uppercase()).collect();
    println!("{:?}", uppercased); // ["HELLO", "WORLD", "RUST"]

    let lengths: Vec<usize> = words.iter().map(|s| s.len()).collect();
    println!("{:?}", lengths); // [5, 5, 4]

    // --- FILTER ---
    // Keeps only elements that match a predicate

    let evens: Vec<i32> = numbers.iter().filter(|&&x| x % 2 == 0).copied().collect();
    println!("{:?}", evens); // [2, 4, 6, 8, 10]

    let odds: Vec<i32> = numbers.iter().filter(|&&x| x % 2 != 0).copied().collect();
    println!("{:?}", odds); // [1, 3, 5, 7, 9]

    let big: Vec<i32> = numbers.iter().filter(|&&x| x > 5).copied().collect();
    println!("{:?}", big); // [6, 7, 8, 9, 10]

    let long_words: Vec<&&str> = words.iter().filter(|s| s.len() > 4).collect();
    println!("{:?}", long_words); // ["hello", "world"]

    // --- FOLD ---
    // Reduces iterator to a single value with an accumulator
    // fold(initial_value, |accumulator, element| -> new_accumulator)

    let sum = numbers.iter().fold(0, |acc, &x| acc + x);
    println!("{}", sum); // 55

    let product = numbers.iter().fold(1, |acc, &x| acc * x);
    println!("{}", product); // 3628800

    let max = numbers.iter().fold(i32::MIN, |acc, &x| acc.max(x));
    println!("{}", max); // 10

    let min = numbers.iter().fold(i32::MAX, |acc, &x| acc.min(x));
    println!("{}", min); // 1

    // fold to build a String
    let sentence = words.iter().fold(String::new(), |mut acc, &w| {
        if !acc.is_empty() {
            acc.push(' ');
        }
        acc.push_str(w);
        acc
    });
    println!("{}", sentence); // hello world rust

    // fold to count occurrences
    let chars = vec!['a', 'b', 'a', 'c', 'b', 'a'];
    let counts = chars.iter().fold(HashMap::new(), |mut map, &c| {
        *map.entry(c).or_insert(0) += 1;
        map
    });
    println!("{}", counts[&'a']); // 3
    println!("{}", counts[&'b']); // 2
    println!("{}", counts[&'c']); // 1

    // --- CHAINING ---

    // sum of squares of odd numbers
    let result: i32 = numbers
        .iter()
        .filter(|&&x| x % 2 != 0)
        .map(|&x| x * x)
        .sum();
    println!("{}", result); // 1+9+25+49+81 = 165

    // words longer than 3 chars, uppercased, joined
    let mixed = vec!["hi", "rust", "is", "great", "fun"];
    let result: Vec<String> = mixed
        .iter()
        .filter(|s| s.len() > 3)
        .map(|s| s.to_uppercase())
        .collect();
    println!("{:?}", result); // ["RUST", "GREAT"]

    // flat_map — map that flattens one level
    let sentences = vec!["hello world", "rust is cool"];
    let all_words: Vec<&str> = sentences
        .iter()
        .flat_map(|s| s.split_whitespace())
        .collect();
    println!("{:?}", all_words); // ["hello", "world", "rust", "is", "cool"]

    // scan — like fold but yields each intermediate accumulator
    let running_sum: Vec<i32> = numbers
        .iter()
        .scan(0, |acc, &x| {
            *acc += x;
            Some(*acc)
        })
        .collect();
    println!("{:?}", running_sum); // [1, 3, 6, 10, 15, 21, 28, 36, 45, 55]

    // partition — split into two Vecs based on predicate
    let (evens2, odds2): (Vec<i32>, Vec<i32>) = numbers.iter().partition(|&&x| x % 2 == 0);
    println!("{:?}", evens2); // [2, 4, 6, 8, 10]
    println!("{:?}", odds2); // [1, 3, 5, 7, 9]
}
