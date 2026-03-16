// The Iterator trait: anything that yields a sequence of values
// Core method: fn next(&mut self) -> Option<Self::Item>

// Implementing a custom iterator
struct Counter {
    count: u32,
    max: u32,
}

impl Counter {
    fn new(max: u32) -> Counter {
        Counter { count: 0, max }
    }
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<u32> {
        if self.count < self.max {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}

fn main() {
    // Creating iterators from collections
    let v = vec![1, 2, 3, 4, 5];

    // iter() — yields &T (borrows)
    let sum: i32 = v.iter().sum();
    println!("{}", sum); // 15
    println!("{:?}", v); // [1, 2, 3, 4, 5] — v still usable

    // into_iter() — yields T (consumes)
    let v2 = vec![10, 20, 30];
    let doubled: Vec<i32> = v2.into_iter().map(|x| x * 2).collect();
    println!("{:?}", doubled); // [20, 40, 60]
                               // v2 is moved, can't use it anymore

    // iter_mut() — yields &mut T
    let mut v3 = vec![1, 2, 3];
    v3.iter_mut().for_each(|x| *x *= 10);
    println!("{:?}", v3); // [10, 20, 30]

    // Consuming adapters (consume the iterator, produce a value)
    let nums = vec![1, 2, 3, 4, 5];
    println!("{}", nums.iter().sum::<i32>()); // 15
    println!("{}", nums.iter().product::<i32>()); // 120
    println!("{}", nums.iter().count()); // 5
    println!("{:?}", nums.iter().max()); // Some(5)
    println!("{:?}", nums.iter().min()); // Some(1)
    println!("{}", nums.iter().any(|&x| x > 3)); // true
    println!("{}", nums.iter().all(|&x| x > 0)); // true

    // Iterator adapters (lazy — produce new iterators)
    let evens: Vec<i32> = nums.iter().filter(|&&x| x % 2 == 0).copied().collect();
    println!("{:?}", evens); // [2, 4]

    let squares: Vec<i32> = nums.iter().map(|&x| x * x).collect();
    println!("{:?}", squares); // [1, 4, 9, 16, 25]

    // Chaining adapters
    let result: Vec<i32> = nums
        .iter()
        .filter(|&&x| x % 2 != 0)
        .map(|&x| x * x)
        .collect();
    println!("{:?}", result); // [1, 9, 25]

    // take and skip
    let first_three: Vec<i32> = nums.iter().take(3).copied().collect();
    println!("{:?}", first_three); // [1, 2, 3]

    let skip_two: Vec<i32> = nums.iter().skip(2).copied().collect();
    println!("{:?}", skip_two); // [3, 4, 5]

    // enumerate
    let fruits = vec!["apple", "banana", "cherry"];
    for (i, fruit) in fruits.iter().enumerate() {
        println!("{}: {}", i, fruit);
    }
    // 0: apple
    // 1: banana
    // 2: cherry

    // zip — combine two iterators
    let a = vec![1, 2, 3];
    let b = vec!["one", "two", "three"];
    let zipped: Vec<(i32, &&str)> = a.iter().copied().zip(b.iter()).collect();
    println!("{:?}", zipped); // [(1, "one"), (2, "two"), (3, "three")]

    // flatten
    let nested = vec![vec![1, 2], vec![3, 4], vec![5]];
    let flat: Vec<i32> = nested.into_iter().flatten().collect();
    println!("{:?}", flat); // [1, 2, 3, 4, 5]

    // Custom iterator
    let counter = Counter::new(5);
    let collected: Vec<u32> = counter.collect();
    println!("{:?}", collected); // [1, 2, 3, 4, 5]

    // Custom iterator with adapters — all Iterator methods work for free
    let sum: u32 = Counter::new(5).sum();
    println!("{}", sum); // 15

    let evens: Vec<u32> = Counter::new(10).filter(|x| x % 2 == 0).collect();
    println!("{:?}", evens); // [2, 4, 6, 8, 10]
}
