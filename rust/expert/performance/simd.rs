// SIMD: Single Instruction, Multiple Data
// Process multiple values in parallel using special CPU registers
//
// x86/x64: SSE (128-bit), AVX (256-bit), AVX-512 (512-bit)
// ARM:     NEON (128-bit), SVE (scalable)
//
// Rust SIMD options:
//   1. Auto-vectorization: compiler does it automatically (simplest, less control)
//   2. std::simd (portable_simd): stable in Rust 1.x nightly, stabilizing
//   3. std::arch: platform-specific intrinsics (most control, least portable)
//   4. packed_simd2 / wide crates: third-party portable SIMD

// --- Auto-vectorization: write simple loops, let LLVM vectorize ---
// Compile with: RUSTFLAGS="-C target-cpu=native" cargo build --release
// Then check: cargo-show-asm or godbolt.org

fn sum_f32_auto(v: &[f32]) -> f32 {
    // LLVM will auto-vectorize this with AVX on capable CPUs
    v.iter().sum()
}

fn dot_product_auto(a: &[f32], b: &[f32]) -> f32 {
    // Auto-vectorized: multiply-accumulate loop
    a.iter().zip(b.iter()).map(|(x, y)| x * y).sum()
}

fn scale_auto(v: &mut [f32], factor: f32) {
    // Auto-vectorized: same factor applied to all elements
    for x in v.iter_mut() {
        *x *= factor;
    }
}

// --- Checking if SIMD is available at runtime ---
fn cpu_features() {
    // is_x86_feature_detected! — runtime detection (stable)
    #[cfg(target_arch = "x86_64")]
    {
        println!("SSE2:  {}", is_x86_feature_detected!("sse2"));
        println!("AVX:   {}", is_x86_feature_detected!("avx"));
        println!("AVX2:  {}", is_x86_feature_detected!("avx2"));
        println!("FMA:   {}", is_x86_feature_detected!("fma"));
    }
    #[cfg(not(target_arch = "x86_64"))]
    println!("non-x86 architecture");
}

// --- Manual SIMD with std::arch (platform-specific intrinsics) ---
// These map directly to CPU instructions — maximum control, not portable
#[cfg(target_arch = "x86_64")]
mod x86_simd {
    use std::arch::x86_64::*;

    // Add two arrays of 4 f32 values in parallel using SSE
    // _mm_add_ps: adds 4 f32 values at once (1 instruction instead of 4)
    pub fn add_4f32(a: [f32; 4], b: [f32; 4]) -> [f32; 4] {
        unsafe {
            // Load 4 floats into 128-bit SSE registers
            let va = _mm_loadu_ps(a.as_ptr());
            let vb = _mm_loadu_ps(b.as_ptr());
            // Add all 4 pairs simultaneously
            let result = _mm_add_ps(va, vb);
            // Store back to array
            let mut out = [0f32; 4];
            _mm_storeu_ps(out.as_mut_ptr(), result);
            out
        }
    }

    // Multiply 4 f32 values
    pub fn mul_4f32(a: [f32; 4], b: [f32; 4]) -> [f32; 4] {
        unsafe {
            let va = _mm_loadu_ps(a.as_ptr());
            let vb = _mm_loadu_ps(b.as_ptr());
            let result = _mm_mul_ps(va, vb);
            let mut out = [0f32; 4];
            _mm_storeu_ps(out.as_mut_ptr(), result);
            out
        }
    }

    // Horizontal sum of 4 f32 using SSE3 hadd
    pub fn hsum_4f32(a: [f32; 4]) -> f32 {
        unsafe {
            let v = _mm_loadu_ps(a.as_ptr());
            let shuf = _mm_movehdup_ps(v); // [a1,a1,a3,a3]
            let sums = _mm_add_ps(v, shuf); // [a0+a1, -, a2+a3, -]
            let shuf2 = _mm_movehl_ps(sums, sums); // move high to low
            let result = _mm_add_ss(sums, shuf2); // a0+a1+a2+a3
            _mm_cvtss_f32(result)
        }
    }

    // AVX: operate on 8 f32 at once (if available)
    #[target_feature(enable = "avx")]
    pub unsafe fn add_8f32_avx(a: [f32; 8], b: [f32; 8]) -> [f32; 8] {
        let va = _mm256_loadu_ps(a.as_ptr());
        let vb = _mm256_loadu_ps(b.as_ptr());
        let result = _mm256_add_ps(va, vb);
        let mut out = [0f32; 8];
        _mm256_storeu_ps(out.as_mut_ptr(), result);
        out
    }
}

// --- Scalar fallback for non-x86 ---
#[allow(dead_code)]
fn add_4f32_scalar(a: [f32; 4], b: [f32; 4]) -> [f32; 4] {
    [a[0] + b[0], a[1] + b[1], a[2] + b[2], a[3] + b[3]]
}

// --- Performance comparison: scalar vs SIMD style ---
use std::hint::black_box;
use std::time::Instant;

fn bench_sum(label: &str, data: &[f32]) {
    let start = Instant::now();
    let _sum = black_box(sum_f32_auto(black_box(data)));
    println!("{}: {:?}", label, start.elapsed());
}

fn main() {
    // CPU feature detection
    println!("--- CPU Features ---");
    cpu_features();

    // Auto-vectorization
    println!("\n--- Auto-vectorized ops ---");
    let a: Vec<f32> = (0..1000).map(|x| x as f32).collect();
    let b: Vec<f32> = (0..1000).map(|x| x as f32 * 2.0).collect();
    let mut c = a.clone();

    println!("{:.0}", sum_f32_auto(&a)); // 499500
    println!("{:.0}", dot_product_auto(&a, &b)); // 999000500  (∑ i*2i)

    scale_auto(&mut c, 0.5);
    println!("{:.1}", c[10]); // 5.0 (was 10.0)

    // Manual SIMD (x86_64 only)
    #[cfg(target_arch = "x86_64")]
    {
        println!("\n--- Manual SSE SIMD ---");
        let va = [1.0f32, 2.0, 3.0, 4.0];
        let vb = [5.0f32, 6.0, 7.0, 8.0];

        let sum = x86_simd::add_4f32(va, vb);
        println!("{:?}", sum); // [6.0, 8.0, 10.0, 12.0]

        let product = x86_simd::mul_4f32(va, vb);
        println!("{:?}", product); // [5.0, 12.0, 21.0, 32.0]

        let hsum = x86_simd::hsum_4f32([1.0, 2.0, 3.0, 4.0]);
        println!("{:.0}", hsum); // 10

        if is_x86_feature_detected!("avx") {
            let va8 = [1.0f32, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0];
            let vb8 = [1.0f32; 8];
            let result = unsafe { x86_simd::add_8f32_avx(va8, vb8) };
            println!("{:?}", result); // [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]
        }
    }

    #[cfg(not(target_arch = "x86_64"))]
    {
        println!("\n--- Scalar fallback ---");
        let va = [1.0f32, 2.0, 3.0, 4.0];
        let vb = [5.0f32, 6.0, 7.0, 8.0];
        println!("{:?}", add_4f32_scalar(va, vb));
    }

    // Benchmark
    println!("\n--- Benchmark ---");
    let large: Vec<f32> = (0..1_000_000).map(|x| x as f32).collect();
    bench_sum("sum 1M f32", &large); // very fast with auto-vectorization

    println!("simd done"); // simd done
}
