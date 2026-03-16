// Profiling and performance measurement in Rust
//
// Tools:
//   cargo bench          — run benchmarks (criterion or libtest)
//   perf (Linux)         — CPU performance counters, flame graphs
//   flamegraph crate     — generate flame graphs from perf data
//   cargo-flamegraph     — cargo subcommand for flame graphs
//   heaptrack            — heap allocation profiling
//   valgrind/massif      — memory profiling
//   DHAT                 — dynamic heap analysis tool
//   samply               — sampling profiler (cross-platform)
//
// Benchmarking with criterion:
//   cargo add criterion --dev
//   benches/my_bench.rs:
//     use criterion::{black_box, criterion_group, criterion_main, Criterion};
//     fn bench_fn(c: &mut Criterion) {
//         c.bench_function("my fn", |b| b.iter(|| my_fn(black_box(100))));
//     }
//     criterion_group!(benches, bench_fn);
//     criterion_main!(benches);
//   cargo bench

use std::hint::black_box;
use std::time::Instant;

// --- Manual timing (poor man's benchmark) ---
fn time_it<F: Fn() -> R, R>(label: &str, f: F) -> R {
    let start = Instant::now();
    let result = f();
    println!("{}: {:?}", label, start.elapsed());
    result
}

// --- black_box: prevent compiler from optimizing away benchmark code ---
// Without black_box, the compiler may see that a result is unused and
// eliminate the entire computation — giving misleadingly fast results
fn sum_naive(n: u64) -> u64 {
    (1..=n).sum()
}

fn sum_formula(n: u64) -> u64 {
    n * (n + 1) / 2
}

// --- Cache effects: sequential vs random access ---
fn sequential_sum(data: &[i32]) -> i64 {
    data.iter().map(|&x| x as i64).sum()
}

fn strided_sum(data: &[i32], stride: usize) -> i64 {
    let mut sum = 0i64;
    let mut i = 0;
    while i < data.len() {
        sum += data[i] as i64;
        i += stride;
    }
    sum
}

// --- Allocation patterns ---
fn many_small_allocs(n: usize) -> Vec<Box<i32>> {
    (0..n).map(|i| Box::new(i as i32)).collect()
}

fn one_big_alloc(n: usize) -> Vec<i32> {
    (0..n).map(|i| i as i32).collect()
}

// --- String building: bad vs good ---
fn string_concat_bad(parts: &[&str]) -> String {
    let mut result = String::new();
    for part in parts {
        result = result + part; // allocates on every iteration
    }
    result
}

fn string_concat_good(parts: &[&str]) -> String {
    let total_len: usize = parts.iter().map(|s| s.len()).sum();
    let mut result = String::with_capacity(total_len); // one allocation
    for part in parts {
        result.push_str(part);
    }
    result
}

// --- Iterator vs collect: avoid intermediate allocations ---
fn process_bad(v: &[i32]) -> Vec<i32> {
    let evens: Vec<i32> = v.iter().filter(|&&x| x % 2 == 0).copied().collect();
    let doubled: Vec<i32> = evens.iter().map(|&x| x * 2).collect(); // extra allocation
    doubled
}

fn process_good(v: &[i32]) -> Vec<i32> {
    v.iter().filter(|&&x| x % 2 == 0).map(|&x| x * 2).collect() // one allocation, lazy pipeline
}

// --- Cloning vs borrowing ---
fn uses_clone(s: String) -> usize {
    let _copy = s.clone(); // unnecessary clone
    s.len()
}

fn uses_borrow(s: &str) -> usize {
    s.len() // no allocation
}

// --- Capacity pre-allocation ---
fn vec_no_capacity(n: usize) -> Vec<i32> {
    let mut v = Vec::new(); // grows and reallocates multiple times
    for i in 0..n as i32 {
        v.push(i);
    }
    v
}

fn vec_with_capacity(n: usize) -> Vec<i32> {
    let mut v = Vec::with_capacity(n); // one allocation
    for i in 0..n as i32 {
        v.push(i);
    }
    v
}

fn main() {
    // Manual timing
    time_it("sum_naive 1M", || {
        black_box(sum_naive(black_box(1_000_000)))
    });
    time_it("sum_formula 1M", || {
        black_box(sum_formula(black_box(1_000_000)))
    });
    // sum_formula should be dramatically faster

    // Cache effects
    let data: Vec<i32> = (0..100_000).collect();

    let seq_time = {
        let start = Instant::now();
        black_box(sequential_sum(black_box(&data)));
        start.elapsed()
    };

    let strided_time = {
        let start = Instant::now();
        black_box(strided_sum(black_box(&data), 16));
        start.elapsed()
    };

    println!("sequential: {:?}", seq_time); // faster (cache-friendly)
    println!("strided:    {:?}", strided_time); // slower (cache misses)

    // String building
    let parts: Vec<&str> = vec!["hello", " ", "world", "!"];
    let bad = time_it("concat_bad", || string_concat_bad(black_box(&parts)));
    let good = time_it("concat_good", || string_concat_good(black_box(&parts)));
    println!("{} == {}", bad == good, bad); // true hello world!

    // Iterator pipeline
    let nums: Vec<i32> = (1..=20).collect();
    let r1 = process_bad(&nums);
    let r2 = process_good(&nums);
    println!("{:?}", r1 == r2); // true
    println!("{:?}", r1); // [4, 8, 12, 16, 20, 24, 28, 32, 36, 40]

    // Borrow vs clone
    let s = String::from("hello world");
    println!("{}", uses_clone(s.clone())); // 11
    println!("{}", uses_borrow(&s)); // 11

    // Capacity pre-allocation
    let n = 10_000;
    let t1 = {
        let start = Instant::now();
        black_box(vec_no_capacity(black_box(n)));
        start.elapsed()
    };
    let t2 = {
        let start = Instant::now();
        black_box(vec_with_capacity(black_box(n)));
        start.elapsed()
    };
    println!("no capacity:   {:?}", t1);
    println!("with capacity: {:?}", t2); // typically faster

    // Allocation comparison
    let t1 = {
        let start = Instant::now();
        black_box(many_small_allocs(black_box(1000)));
        start.elapsed()
    };
    let t2 = {
        let start = Instant::now();
        black_box(one_big_alloc(black_box(1000)));
        start.elapsed()
    };
    println!("many small allocs: {:?}", t1); // slower
    println!("one big alloc:     {:?}", t2); // faster

    // Key profiling advice:
    // 1. Measure first — don't optimize without data
    // 2. Use cargo bench + criterion for reliable microbenchmarks
    // 3. Use perf + flamegraph to find hot paths in real workloads
    // 4. Avoid premature optimization — write clear code first
    println!("profiling tools done"); // profiling tools done
}
