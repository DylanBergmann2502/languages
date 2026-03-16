// Low-level OS concepts in Rust
// Virtual memory, process model, system calls, signals, environment

use std::alloc::{GlobalAlloc, Layout, System};
use std::collections::HashMap;
use std::env;
use std::sync::atomic::{AtomicUsize, Ordering};

// --- Custom allocator: track allocations ---
// GlobalAlloc: implement your own heap allocator
// This one wraps the system allocator and counts bytes

struct TrackingAllocator {
    allocated: AtomicUsize,
}

impl TrackingAllocator {
    const fn new() -> Self {
        TrackingAllocator {
            allocated: AtomicUsize::new(0),
        }
    }

    fn bytes_allocated(&self) -> usize {
        self.allocated.load(Ordering::Relaxed)
    }
}

unsafe impl GlobalAlloc for TrackingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let ptr = System.alloc(layout);
        if !ptr.is_null() {
            self.allocated.fetch_add(layout.size(), Ordering::Relaxed);
        }
        ptr
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        System.dealloc(ptr, layout);
        self.allocated.fetch_sub(layout.size(), Ordering::Relaxed);
    }
}

#[global_allocator]
static ALLOCATOR: TrackingAllocator = TrackingAllocator::new();

// --- Memory layout: alignment and padding ---
#[repr(C)]
#[allow(dead_code)]
struct Unpadded {
    a: u8,  // 1 byte
    b: u8,  // 1 byte
    c: u16, // 2 bytes
    d: u32, // 4 bytes
}

#[repr(C)]
#[allow(dead_code)]
struct Padded {
    a: u8, // 1 byte
    // 3 bytes padding (to align b to 4-byte boundary)
    b: u32, // 4 bytes
    c: u8,  // 1 byte
            // 3 bytes padding (to align struct size to 4 bytes)
}

// Rust reorders fields by default for optimal packing (no #[repr(C)])
#[allow(dead_code)]
struct Optimized {
    a: u8,
    b: u32,
    c: u8,
}

// --- Virtual memory: stack vs heap ---
fn stack_vs_heap() {
    // Stack: fast, fixed size, automatic cleanup, LIFO
    let stack_array = [0u8; 1024]; // 1KB on the stack
    println!("stack array: {} bytes", stack_array.len()); // 1024

    // Heap: flexible size, manual (or RAII) management, slower allocation
    let before = ALLOCATOR.bytes_allocated();
    let heap_vec: Vec<u8> = vec![0; 1024]; // 1KB on the heap
    let after = ALLOCATOR.bytes_allocated();
    println!("heap allocated: {} bytes", after - before); // 1024
    println!("heap vec len: {}", heap_vec.len()); // 1024

    // Box: single heap-allocated value
    let heap_int = Box::new(42i32);
    println!("boxed: {}", heap_int); // 42
}

// --- Process model ---
fn process_info() {
    // Environment variables
    env::set_var("MY_VAR", "hello");
    println!("{}", env::var("MY_VAR").unwrap()); // hello
    println!(
        "{}",
        env::var("NONEXISTENT").unwrap_or_else(|_| "default".to_string())
    ); // default

    // All env vars
    let mut vars: Vec<(String, String)> = env::vars().collect();
    vars.sort_by_key(|(k, _)| k.clone());
    let rust_vars: Vec<_> = vars.iter().filter(|(k, _)| k.starts_with("RUST")).collect();
    println!("RUST* env vars: {}", rust_vars.len()); // varies by system

    // Command line args (simulated — would be populated by OS when running a real binary)
    let args: Vec<String> = env::args().collect();
    println!("arg count: {}", args.len()); // 1+ (first is program name)
    println!("program: {}", args[0].split('/').last().unwrap_or("?")); // binary name

    // Current working directory
    let cwd = env::current_dir().unwrap();
    println!("cwd: {}", cwd.display()); // /path/to/current/dir
}

// --- Memory layout details ---
fn memory_layout() {
    // size_of and align_of
    println!("{}", std::mem::size_of::<Unpadded>()); // 8  (1+1+2+4, no padding needed)
    println!("{}", std::mem::size_of::<Padded>()); // 12 (1+3pad+4+1+3pad)
    println!("{}", std::mem::size_of::<Optimized>()); // 8  (Rust reorders: u32+u8+u8+1pad)

    println!("{}", std::mem::align_of::<Padded>()); // 4

    // Stack addresses go down (on most architectures)
    let a = 1i32;
    let b = 2i32;
    let a_addr = &a as *const i32 as usize;
    let b_addr = &b as *const i32 as usize;
    println!("a > b in memory: {}", a_addr > b_addr); // true (stack grows down)

    // Heap addresses are generally higher than stack in modern OSes
    let heap = Box::new(0i32);
    let heap_addr = heap.as_ref() as *const i32 as usize;
    println!("heap addr: {:#x}", heap_addr); // varies
}

// --- Manual memory management with Layout ---
fn manual_alloc() {
    use std::alloc::{alloc, dealloc};

    let layout = Layout::array::<i32>(10).unwrap();

    let ptr = unsafe { alloc(layout) } as *mut i32;
    assert!(!ptr.is_null());

    // Write values
    for i in 0..10 {
        unsafe {
            ptr.add(i).write(i as i32 * i as i32);
        }
    }

    // Read values
    let values: Vec<i32> = (0..10).map(|i| unsafe { *ptr.add(i) }).collect();
    println!("{:?}", values); // [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

    // Must free manually
    unsafe {
        dealloc(ptr as *mut u8, layout);
    }
}

// --- Implementing a simple arena allocator ---
struct Arena {
    buf: Vec<u8>,
    pos: usize,
}

impl Arena {
    fn new(size: usize) -> Self {
        Arena {
            buf: vec![0; size],
            pos: 0,
        }
    }

    fn alloc<T: Copy + Default>(&mut self) -> Option<&mut T> {
        let align = std::mem::align_of::<T>();
        let size = std::mem::size_of::<T>();
        // align up
        let aligned = (self.pos + align - 1) & !(align - 1);
        if aligned + size > self.buf.len() {
            return None;
        }
        let ptr = &mut self.buf[aligned] as *mut u8 as *mut T;
        self.pos = aligned + size;
        unsafe {
            *ptr = T::default();
            Some(&mut *ptr)
        }
    }

    fn used(&self) -> usize {
        self.pos
    }
}

fn main() {
    stack_vs_heap();
    // 1024, 1024, 42

    process_info();
    // hello, default, ...

    memory_layout();
    // 8, 12, 8, 4, true, ...

    manual_alloc();
    // [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

    // Arena allocator
    let mut arena = Arena::new(256);
    let a = arena.alloc::<i32>().unwrap() as *mut i32;
    let b = arena.alloc::<f64>().unwrap() as *mut f64;
    unsafe {
        *a = 42;
        *b = 3.14;
        println!("{}", *a); // 42
        println!("{:.2}", *b); // 3.14
    }
    println!("arena used: {} bytes", arena.used()); // 16 (4 + 4pad + 8)

    // Allocation tracking
    let before = ALLOCATOR.bytes_allocated();
    let _v: Vec<i32> = (0..100).collect();
    let after = ALLOCATOR.bytes_allocated();
    println!("vec allocated: {} bytes", after - before); // 400

    // HashMap allocation
    let before = ALLOCATOR.bytes_allocated();
    let mut map: HashMap<i32, i32> = HashMap::new();
    for i in 0..10 {
        map.insert(i, i * i);
    }
    let after = ALLOCATOR.bytes_allocated();
    println!("hashmap allocated: >0: {}", after > before); // true

    println!("os concepts done"); // os concepts done
}
