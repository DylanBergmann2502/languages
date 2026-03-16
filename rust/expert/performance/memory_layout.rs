// Controlling memory layout in Rust
// Layout affects: cache performance, serialization, FFI compatibility, SIMD

use std::mem;

// --- Default Rust layout: compiler chooses order for optimal packing ---
#[allow(dead_code)]
struct Rust {
    a: u8,  // 1 byte
    b: u32, // 4 bytes
    c: u8,  // 1 byte
    d: u16, // 2 bytes
}
// Rust may reorder to: u32(4) + u16(2) + u8(1) + u8(1) = 8 bytes (no padding)

// --- repr(C): C-compatible layout, fields in declaration order ---
#[allow(dead_code)]
#[repr(C)]
struct CLayout {
    a: u8,  // 1 byte + 3 padding
    b: u32, // 4 bytes
    c: u8,  // 1 byte + 1 padding
    d: u16, // 2 bytes
}
// Total: 1+3pad+4+1+1pad+2 = 12 bytes

// --- repr(packed): remove all padding (may cause unaligned access) ---
#[allow(dead_code)]
#[repr(packed)]
struct Packed {
    a: u8,  // 1 byte
    b: u32, // 4 bytes (unaligned!)
    c: u8,  // 1 byte
    d: u16, // 2 bytes (unaligned!)
}
// Total: 1+4+1+2 = 8 bytes (but unaligned reads are slower or UB on some architectures)

// --- repr(align(N)): force minimum alignment ---
#[repr(align(64))] // align to cache line boundary (64 bytes on x86)
#[allow(dead_code)]
struct CacheAligned {
    value: u64,
}
// Prevents false sharing in concurrent code

// --- repr(transparent): for newtypes, same layout as inner type ---
#[repr(transparent)]
struct Meters(f64); // guaranteed same layout as f64

#[repr(transparent)]
#[allow(dead_code)]
struct NonZeroWrapper(std::num::NonZeroU32);

// --- Enum layout optimization ---
// Rust optimizes Option<Box<T>>, Option<&T>, Option<NonZeroU32> to same size as T
// The None variant uses the "null" representation

fn enum_layout() {
    println!("{}", mem::size_of::<Option<Box<i32>>>()); // 8 (same as Box<i32>)
    println!("{}", mem::size_of::<Box<i32>>()); // 8
    println!("{}", mem::size_of::<Option<&i32>>()); // 8 (same as &i32)
    println!("{}", mem::size_of::<Option<std::num::NonZeroU32>>()); // 4 (same as u32)

    // Without the optimization:
    println!("{}", mem::size_of::<Option<u32>>()); // 8 (needs discriminant byte + padding)
    println!("{}", mem::size_of::<Option<i32>>()); // 8
}

// --- Field ordering for minimal size ---
#[allow(dead_code)]
struct BadOrder {
    a: u8,  // 1 + 7 padding
    b: u64, // 8
    c: u8,  // 1 + 3 padding
    d: u32, // 4
}
// Size: 1+7+8+1+3+4 = 24 bytes

#[allow(dead_code)]
struct GoodOrder {
    b: u64, // 8
    d: u32, // 4
    a: u8,  // 1
    c: u8,  // 1
            // 2 padding
}
// Size: 8+4+1+1+2 = 16 bytes

// --- SOA vs AOS: Structure of Arrays vs Array of Structures ---
// AOS (common default): each element is a struct with all fields
#[allow(dead_code)]
struct ParticleAOS {
    x: f32,
    y: f32,
    z: f32,
    vx: f32,
    vy: f32,
    vz: f32,
    mass: f32,
}

// SOA: separate arrays for each field — much more cache-friendly for SIMD/batched ops
#[allow(dead_code)]
struct ParticlesSOA {
    x: Vec<f32>,
    y: Vec<f32>,
    z: Vec<f32>,
    vx: Vec<f32>,
    vy: Vec<f32>,
    vz: Vec<f32>,
    mass: Vec<f32>,
}

// When updating only x positions: AOS wastes cache loading y,z,v*,mass
// SOA loads only the x array — full cache lines used efficiently

fn update_x_aos(particles: &mut [ParticleAOS], dt: f32) {
    for p in particles {
        p.x += p.vx * dt;
    } // touches 28 bytes per particle, uses 4
}

fn update_x_soa(p: &mut ParticlesSOA, dt: f32) {
    for i in 0..p.x.len() {
        p.x[i] += p.vx[i] * dt; // touches only x and vx arrays
    }
}

// --- Box<[T]> vs Vec<T>: when you don't need to resize ---
fn boxed_slice_demo() {
    // Vec<T>: 3 words (ptr + len + capacity)
    // Box<[T]>: 2 words (ptr + len) — one less word, no capacity overhead
    println!("{}", mem::size_of::<Vec<i32>>()); // 24 (3 x 8)
    println!("{}", mem::size_of::<Box<[i32]>>()); // 16 (2 x 8)

    let v: Vec<i32> = vec![1, 2, 3, 4, 5];
    let boxed: Box<[i32]> = v.into_boxed_slice();
    println!("{:?}", boxed); // [1, 2, 3, 4, 5]
    println!("{}", boxed.len()); // 5
}

fn main() {
    // Layout sizes
    println!("{}", mem::size_of::<Rust>()); // 8 (Rust reorders optimally)
    println!("{}", mem::size_of::<CLayout>()); // 12 (C order, has padding)
    println!("{}", mem::size_of::<Packed>()); // 8 (no padding)
    println!("{}", mem::size_of::<CacheAligned>()); // 64 (aligned to cache line)
    println!("{}", mem::align_of::<CacheAligned>()); // 64

    // repr(transparent) — same size as inner type
    println!("{}", mem::size_of::<Meters>()); // 8 (same as f64)
    println!("{}", mem::size_of::<f64>()); // 8

    // Enum layout optimization (null pointer optimization)
    enum_layout();
    // 8, 8, 8, 4, 8, 8

    // Field ordering
    println!("{}", mem::size_of::<BadOrder>()); // 24
    println!("{}", mem::size_of::<GoodOrder>()); // 16

    // SOA demo
    let mut particles = ParticlesSOA {
        x: vec![0.0, 1.0, 2.0],
        y: vec![0.0, 0.0, 0.0],
        z: vec![0.0, 0.0, 0.0],
        vx: vec![1.0, 2.0, 3.0],
        vy: vec![0.0, 0.0, 0.0],
        vz: vec![0.0, 0.0, 0.0],
        mass: vec![1.0, 1.0, 1.0],
    };
    update_x_soa(&mut particles, 0.1);
    println!("{:?}", particles.x); // [0.1, 1.2, 2.3]

    let mut aos = vec![
        ParticleAOS {
            x: 0.0,
            y: 0.0,
            z: 0.0,
            vx: 1.0,
            vy: 0.0,
            vz: 0.0,
            mass: 1.0,
        },
        ParticleAOS {
            x: 1.0,
            y: 0.0,
            z: 0.0,
            vx: 2.0,
            vy: 0.0,
            vz: 0.0,
            mass: 1.0,
        },
    ];
    update_x_aos(&mut aos, 0.1);
    println!("{:.1} {:.1}", aos[0].x, aos[1].x); // 0.1 1.2

    // Box<[T]> vs Vec<T>
    boxed_slice_demo();
    // 24, 16, [1,2,3,4,5], 5

    println!("memory layout done"); // memory layout done
}
