// benchmarking_basics.rs — Simple performance testing in Rust
// Benchmarks require Cargo — see sample_workspace/app/benches/benchmarks.rs
// Run: rust-script benchmarking_basics.rs

use std::time::Instant;

// Functions we'll benchmark manually in this script
fn square(x: i32) -> i32 {
    x * x
}

fn factorial_iterative(n: u64) -> u64 {
    (1..=n).product()
}

fn factorial_recursive(n: u64) -> u64 {
    if n <= 1 {
        1
    } else {
        n * factorial_recursive(n - 1)
    }
}

fn is_prime(n: u64) -> bool {
    if n < 2 {
        return false;
    }
    for i in 2..=(n as f64).sqrt() as u64 {
        if n % i == 0 {
            return false;
        }
    }
    true
}

fn bubble_sort(mut v: Vec<i32>) -> Vec<i32> {
    let n = v.len();
    for i in 0..n {
        for j in 0..n - 1 - i {
            if v[j] > v[j + 1] {
                v.swap(j, j + 1);
            }
        }
    }
    v
}

// Simple manual timer helper
fn bench<F: Fn()>(name: &str, iterations: u32, f: F) {
    let start = Instant::now();
    for _ in 0..iterations {
        f();
    }
    let elapsed = start.elapsed();
    let avg_ns = elapsed.as_nanos() / iterations as u128;
    println!(
        "{:<35} {:>8} iters  {:>10.3?}  avg: {:>6} ns",
        name, iterations, elapsed, avg_ns
    );
}

fn main() {
    // -----------------------------------------------------------------------
    // MANUAL BENCHMARKING with std::time::Instant
    // -----------------------------------------------------------------------
    // Good for quick comparisons — not statistically rigorous.
    // For production benchmarks, use criterion (see sample_workspace/).
    // Note: simple ops (square, factorial) show 0 ns avg because the compiler
    // optimizes them away in debug builds. This is exactly why criterion uses
    // black_box() — to prevent the compiler from cheating.

    println!("{:-<75}", "");
    println!(
        "{:<35} {:>8}        {:>10}  {:>12}",
        "benchmark", "iters", "total", "avg/iter"
    );
    println!("{:-<75}", "");

    bench("square(1000)", 1_000_000, || {
        let _ = square(1000);
    });

    bench("factorial_iterative(15)", 1_000_000, || {
        let _ = factorial_iterative(15);
    });

    bench("factorial_recursive(15)", 1_000_000, || {
        let _ = factorial_recursive(15);
    });

    bench("is_prime(999983)", 100_000, || {
        let _ = is_prime(999983);
    });

    let data: Vec<i32> = (0..100).rev().collect();
    bench("bubble_sort(100 reversed)", 1_000, || {
        let _ = bubble_sort(data.clone());
    });

    let data_sorted: Vec<i32> = (0..100).collect();
    bench("bubble_sort(100 already sorted)", 1_000, || {
        let _ = bubble_sort(data_sorted.clone());
    });

    println!("{:-<75}", "");

    // -----------------------------------------------------------------------
    // CRITERION — the standard benchmarking library
    // -----------------------------------------------------------------------
    // criterion provides:
    //   - Statistical analysis (mean, median, std dev)
    //   - Warmup runs to avoid cold-start bias
    //   - Comparison between runs (regression detection)
    //   - HTML reports with graphs
    //   - black_box() to prevent compiler from optimizing away benchmarked code
    //
    // Setup in Cargo.toml:
    //
    // [dev-dependencies]
    // criterion = { version = "0.5", features = ["html_reports"] }
    //
    // [[bench]]
    // name = "benchmarks"
    // harness = false           # disable default test harness, criterion uses its own
    //
    // benches/benchmarks.rs:
    //
    // use criterion::{black_box, criterion_group, criterion_main, Criterion};
    //
    // fn bench_factorial(c: &mut Criterion) {
    //     c.bench_function("factorial 15", |b| {
    //         b.iter(|| factorial(black_box(15)))
    //                          ^^^^^^^^^^
    //                          prevents compiler from optimizing the call away
    //     });
    // }
    //
    // criterion_group!(benches, bench_factorial);
    // criterion_main!(benches);
    //
    // Commands:
    // cargo bench                    — run all benchmarks
    // cargo bench -p app             — run benchmarks for specific workspace member
    // cargo bench -- factorial       — run only benchmarks matching "factorial"
    // cargo bench -- --save-baseline main   — save results as baseline "main"
    // cargo bench -- --baseline main        — compare against saved baseline

    // -----------------------------------------------------------------------
    // black_box — prevent optimization
    // -----------------------------------------------------------------------
    // The compiler may optimize away code it knows has no side effects.
    // black_box(x) is a hint that tells the compiler "treat x as used".
    //
    // Without black_box:
    //   b.iter(|| factorial(15))   // compiler may compute this at compile time!
    //
    // With black_box:
    //   b.iter(|| factorial(black_box(15)))  // compiler must compute at runtime

    println!("See sample_workspace/app/benches/benchmarks.rs for criterion usage.");
    println!("Run: cd sample_workspace && cargo bench -p app");
}
