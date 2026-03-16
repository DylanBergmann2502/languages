// Mutable static variables
//
// static variables: live for the entire program lifetime ('static lifetime)
// Immutable statics are safe — multiple readers, no data races possible.
// Mutable statics (static mut) are unsafe — reading or writing requires unsafe
// because Rust can't prevent data races in concurrent code.
//
// Use cases:
//   - Global counters or state (single-threaded)
//   - Initialized-once global config
//   - FFI: C libraries often expect global state
//
// Prefer: std::sync::atomic types or lazy_static/once_cell for safe alternatives

// --- Immutable statics (safe) ---
static MAX_CONNECTIONS: u32 = 100;
static APP_NAME: &str = "my_app";
static PRIMES: [u32; 5] = [2, 3, 5, 7, 11];

// --- Mutable statics (unsafe to access) ---
static mut COUNTER: u32 = 0;
static mut LOG_LEVEL: u8 = 1;
static mut BUFFER: [u8; 8] = [0; 8];

// --- Global initialization pattern ---
// A common pattern: initialize once at startup, read-only after that
static mut CONFIG_HOST: &str = "localhost";
static mut CONFIG_PORT: u16 = 8080;

fn init_config(host: &'static str, port: u16) {
    // SAFETY: called once at program startup before any threads are spawned
    unsafe {
        CONFIG_HOST = host;
        CONFIG_PORT = port;
    }
}

fn get_config() -> (&'static str, u16) {
    // SAFETY: config is only written at startup, read-only after
    unsafe { (CONFIG_HOST, CONFIG_PORT) }
}

// --- Mutable static in FFI context ---
// C libraries often maintain global state — this is how Rust interfaces with it
static mut C_ERRNO: i32 = 0;

fn set_errno(code: i32) {
    // SAFETY: single-threaded simulation of C errno
    unsafe {
        C_ERRNO = code;
    }
}

fn get_errno() -> i32 {
    unsafe { C_ERRNO }
}

// --- Safe abstraction over mutable static ---
// Wrap in a struct with safe methods to minimize unsafe surface
struct GlobalCounter;

impl GlobalCounter {
    fn increment() {
        // SAFETY: single-threaded use only
        unsafe {
            COUNTER += 1;
        }
    }

    fn reset() {
        unsafe {
            COUNTER = 0;
        }
    }

    fn value() -> u32 {
        unsafe { COUNTER }
    }
}

// --- Atomic alternative (preferred for thread safety) ---
use std::sync::atomic::{AtomicU32, Ordering};

static SAFE_COUNTER: AtomicU32 = AtomicU32::new(0);

fn main() {
    // Immutable statics — safe, no unsafe needed
    println!("{}", MAX_CONNECTIONS); // 100
    println!("{}", APP_NAME); // my_app
    println!("{:?}", PRIMES); // [2, 3, 5, 7, 11]

    // Mutable static — requires unsafe
    unsafe {
        COUNTER += 1;
        COUNTER += 1;
        let c = COUNTER;
        println!("{}", c); // 2

        LOG_LEVEL = 3;
        let l = LOG_LEVEL;
        println!("{}", l); // 3

        BUFFER[0] = 42;
        BUFFER[1] = 99;
        let b = BUFFER;
        println!("{:?}", &b[..4]); // [42, 99, 0, 0]
    }

    // Safe abstraction over mutable static
    GlobalCounter::reset();
    GlobalCounter::increment();
    GlobalCounter::increment();
    GlobalCounter::increment();
    println!("{}", GlobalCounter::value()); // 3

    // Global config pattern
    init_config("db.example.com", 5432);
    let (host, port) = get_config();
    println!("{}:{}", host, port); // db.example.com:5432

    // FFI errno simulation
    set_errno(0);
    println!("{}", get_errno()); // 0
    set_errno(2); // ENOENT (file not found in real libc)
    println!("{}", get_errno()); // 2

    // Atomic alternative — no unsafe needed, thread-safe
    SAFE_COUNTER.fetch_add(1, Ordering::Relaxed);
    SAFE_COUNTER.fetch_add(1, Ordering::Relaxed);
    SAFE_COUNTER.fetch_add(1, Ordering::Relaxed);
    println!("{}", SAFE_COUNTER.load(Ordering::Relaxed)); // 3

    // Key rule: if you need mutable global state and threads, use atomics or Mutex.
    // static mut is for single-threaded code or FFI where you control the access pattern.
    println!("mutable statics done"); // mutable statics done
}
