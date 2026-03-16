// Understanding rustc optimizations
//
// Rust uses LLVM as its backend — all of LLVM's optimization passes are available.
// Optimization levels:
//   opt-level = 0   — no optimization (default in debug)
//   opt-level = 1   — basic
//   opt-level = 2   — most optimizations
//   opt-level = 3   — aggressive (default in release)
//   opt-level = "s" — optimize for binary size
//   opt-level = "z" — optimize for minimum size
//
// In Cargo.toml:
//   [profile.release]
//   opt-level = 3
//   lto = true        -- link-time optimization (whole-program analysis)
//   codegen-units = 1 -- single codegen unit (better LTO, slower compile)
//   panic = "abort"   -- smaller binary, no unwinding

// --- Inlining ---
// The compiler inlines small functions automatically.
// You can hint with #[inline] or force with #[inline(always)].
// #[inline(never)] prevents inlining (useful for profiling clarity).

#[inline(always)]
fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[inline(never)]
fn expensive_computation(n: u64) -> u64 {
    (1..=n).filter(|x| x % 2 == 0).sum()
}

// --- Zero-cost abstractions ---
// Iterators, closures, generics — compile to the same code as hand-written loops

fn sum_iter(v: &[i32]) -> i32 {
    v.iter().sum()
}

fn sum_loop(v: &[i32]) -> i32 {
    let mut total = 0;
    for &x in v {
        total += x;
    }
    total
}
// Both compile to the same machine code — no overhead for the abstraction

// --- Monomorphization ---
// Generic functions are compiled once per concrete type used
// fn largest<T: PartialOrd>(list: &[T]) -> T
// If called with i32 and f64, compiler emits two specialized versions

fn largest<T: PartialOrd + Copy>(list: &[T]) -> T {
    let mut l = list[0];
    for &item in list {
        if item > l {
            l = item;
        }
    }
    l
}

// --- Bounds checking elimination ---
// The compiler can eliminate bounds checks when it can prove access is safe

fn sum_unchecked(v: &[i32]) -> i32 {
    // Bounds check present — compiler may not always eliminate
    v.iter().sum()
}

fn sum_unsafe(v: &[i32]) -> i32 {
    // Manually skip bounds check — only safe if we know len > 0
    let mut total = 0;
    for i in 0..v.len() {
        total += unsafe { *v.get_unchecked(i) };
    }
    total
}

// --- Branch prediction hints ---
// std::hint::likely/unlikely not yet stable, but cold/hot attributes exist
// Use sparingly — the CPU branch predictor is usually better than manual hints

#[cold]
fn handle_error(msg: &str) {
    println!("Error: {}", msg);
}

fn process(n: i32) -> i32 {
    if n < 0 {
        handle_error("negative input"); // marked cold — unlikely path
        0
    } else {
        n * n
    }
}

// --- const evaluation ---
// Computations known at compile time are evaluated by the compiler

const fn fibonacci(n: u64) -> u64 {
    match n {
        0 => 0,
        1 => 1,
        _ => {
            // Iterative const fn (const fn can't recurse with large n — no TCO)
            let mut a = 0u64;
            let mut b = 1u64;
            let mut i = 2;
            while i <= n {
                let tmp = a + b;
                a = b;
                b = tmp;
                i += 1;
            }
            b
        }
    }
}

const FIB_20: u64 = fibonacci(20); // computed at compile time
const FIB_30: u64 = fibonacci(30);

// --- LLVM intrinsics via std::intrinsics (nightly only) ---
// On stable, use std::hint and specific methods

// --- LTO and codegen-units ---
// LTO (link-time optimization): allows the compiler to optimize across crate boundaries
// codegen-units = 1: compile everything as one unit for better cross-function optimization
//
// In Cargo.toml for release:
// [profile.release]
// lto = "fat"          -- full LTO (slowest compile, best runtime)
// lto = "thin"         -- partial LTO (faster compile, nearly as good)
// codegen-units = 1

// --- PGO: Profile-Guided Optimization ---
// 1. Build with instrumentation: RUSTFLAGS="-Cprofile-generate=/tmp/pgo" cargo build --release
// 2. Run workload to collect data
// 3. Merge profiles: llvm-profdata merge -output=merged.profdata /tmp/pgo/*.profraw
// 4. Rebuild: RUSTFLAGS="-Cprofile-use=merged.profdata" cargo build --release

fn main() {
    // Inlining
    println!("{}", add(2, 3)); // 5  (add() is inlined — zero call overhead)

    println!("{}", expensive_computation(100)); // 2550

    // Zero-cost abstractions
    let v: Vec<i32> = (1..=100).collect();
    println!("{}", sum_iter(&v)); // 5050
    println!("{}", sum_loop(&v)); // 5050  (same machine code)

    // Monomorphization
    println!("{}", largest(&[3, 1, 4, 1, 5, 9])); // 9
    println!("{:.1}", largest(&[3.1, 1.4, 2.7])); // 3.1

    // Bounds checking
    println!("{}", sum_unchecked(&v)); // 5050
    println!("{}", sum_unsafe(&v)); // 5050

    // Cold path
    println!("{}", process(5)); // 25
    println!("{}", process(-1)); // Error: negative input \n 0

    // Compile-time computation
    println!("{}", FIB_20); // 6765  (evaluated at compile time)
    println!("{}", FIB_30); // 832040

    // const in general
    const CACHE_LINE: usize = 64;
    const PAGE_SIZE: usize = 4096;
    println!("{} {}", CACHE_LINE, PAGE_SIZE); // 64 4096

    println!("compiler optimizations done"); // compiler optimizations done
}
