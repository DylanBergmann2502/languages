// Unsafe Rust: opt into operations the compiler can't verify safe
//
// `unsafe` does NOT mean the code WILL crash — it means YOU are responsible
// for upholding safety guarantees the compiler normally enforces.
//
// Five things only allowed inside `unsafe {}`:
//   1. Dereference raw pointers
//   2. Call unsafe functions or methods
//   3. Access or modify mutable static variables
//   4. Implement unsafe traits
//   5. Access fields of unions

// --- When to use unsafe ---
// - FFI (calling C libraries)
// - Performance-critical inner loops where you can prove safety
// - Low-level data structures (linked lists, arenas)
// - Interfacing with hardware or OS primitives
//
// Rule: minimize unsafe scope, document WHY it's safe, prefer safe abstractions

// --- 1. Raw pointers ---
// *const T — immutable raw pointer
// *mut T   — mutable raw pointer
// Unlike references:
//   - Can be null
//   - No lifetime tracking
//   - No borrow checker enforcement
//   - Multiple mutable raw pointers to same location are allowed

fn raw_pointer_demo() {
    let x = 42i32;
    let y = &x as *const i32; // create raw pointer from reference
    let mut z = 10i32;
    let w = &mut z as *mut i32; // mutable raw pointer

    // Creating raw pointers is safe — dereferencing requires unsafe
    unsafe {
        println!("{}", *y); // 42
        *w = 99;
        println!("{}", *w); // 99
    }
    println!("{}", z); // 99

    // Raw pointer arithmetic — dangerous, must ensure valid memory
    let arr = [10, 20, 30, 40, 50i32];
    let ptr = arr.as_ptr();
    unsafe {
        println!("{}", *ptr); // 10
        println!("{}", *ptr.add(2)); // 30
        println!("{}", *ptr.add(4)); // 50
    }
}

// --- 2. Unsafe functions ---
// Must be called inside unsafe blocks
// Signals: caller must uphold invariants the compiler can't check

unsafe fn dangerous(ptr: *const i32) -> i32 {
    *ptr
}

// Safe wrapper — encapsulates unsafe, exposes safe API
fn safe_read(val: &i32) -> i32 {
    // SAFETY: val is a valid reference, guaranteed non-null and aligned
    unsafe { dangerous(val as *const i32) }
}

// --- 3. Splitting a slice unsafely (like slice::split_at_mut) ---
// Safe Rust can't have two mutable borrows to different parts of a slice
// Unsafe lets us do this when we can prove they don't overlap
fn split_at_mut_demo(slice: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
    let len = slice.len();
    assert!(mid <= len);
    let ptr = slice.as_mut_ptr();
    // SAFETY: mid <= len, so both slices are within bounds and non-overlapping
    unsafe {
        (
            std::slice::from_raw_parts_mut(ptr, mid),
            std::slice::from_raw_parts_mut(ptr.add(mid), len - mid),
        )
    }
}

// --- 4. Unsafe trait ---
// A trait is unsafe when implementing it requires upholding invariants
// the compiler can't verify (e.g. Send, Sync)
unsafe trait MyUnsafeTrait {
    fn value(&self) -> i32;
}

struct SafeWrapper(i32);

// SAFETY: SafeWrapper only contains i32, which is always safe to use as described
unsafe impl MyUnsafeTrait for SafeWrapper {
    fn value(&self) -> i32 {
        self.0
    }
}

// --- 5. std::mem utilities often used with unsafe ---
fn mem_demo() {
    // mem::transmute: reinterpret bits as a different type (extremely dangerous)
    // SAFETY: f32 and u32 are the same size (4 bytes), valid to transmute
    let f: f32 = 1.0;
    // transmute shown here for educational purposes; in practice use f32::to_bits()
    #[allow(unnecessary_transmutes)]
    let bits: u32 = unsafe { std::mem::transmute(f) };
    println!("1.0f32 bits: {:#010x}", bits); // 0x3f800000

    // mem::zeroed: creates a zero-bit value — only safe for types where all-zeros is valid
    let n: i32 = unsafe { std::mem::zeroed() };
    println!("{}", n); // 0

    // mem::size_of and align_of — safe, just info
    println!("{}", std::mem::size_of::<i32>()); // 4
    println!("{}", std::mem::align_of::<i64>()); // 8
}

fn main() {
    raw_pointer_demo();
    // 42
    // 99
    // 99
    // 10
    // 30
    // 50

    let val = 77i32;
    println!("{}", safe_read(&val)); // 77

    let mut v = vec![1, 2, 3, 4, 5];
    let (left, right) = split_at_mut_demo(&mut v, 2);
    left[0] = 10;
    right[0] = 30;
    println!("{:?}", left); // [10, 2]
    println!("{:?}", right); // [30, 4, 5]

    let w = SafeWrapper(42);
    // SAFETY: SafeWrapper upholds MyUnsafeTrait's requirements
    println!("{}", w.value()); // 42

    mem_demo();
    // 0x3f800000
    // 0
    // 4
    // 8

    // Key principle: unsafe blocks should be as small as possible.
    // Build safe abstractions over unsafe code so callers don't need to think about it.
    println!("unsafe used carefully"); // unsafe used carefully
}
