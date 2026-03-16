use std::sync::{Arc, Mutex};
use std::thread;

// Send and Sync are marker traits — no methods, just signal thread safety to the compiler
//
// Send:  a type can be TRANSFERRED (moved) to another thread
// Sync:  a type can be SHARED (referenced) across threads (&T is Send if T: Sync)
//
// Almost all primitive types are Send + Sync
// Exceptions:
//   Rc<T>     — not Send (non-atomic refcount, unsafe to move to another thread)
//   RefCell<T> — not Sync (runtime borrow check is not thread-safe)
//   raw pointers — neither Send nor Sync (unsafe by default)

// --- Demonstrating Send ---
// A type is Send if it's safe to move to another thread
fn send_to_thread<T: Send + 'static>(val: T) -> thread::JoinHandle<T> {
    thread::spawn(move || val)
}

// --- Demonstrating Sync ---
// A type is Sync if &T can be shared across threads
fn share_across_threads<T: Sync + Send + 'static>(val: Arc<T>) {
    let mut handles = vec![];
    for _ in 0..3 {
        let v = Arc::clone(&val);
        handles.push(thread::spawn(move || {
            let _ = &*v; // just access it
        }));
    }
    for h in handles {
        h.join().unwrap();
    }
}

// --- Custom type: Send + Sync by default if all fields are ---
#[derive(Debug)]
struct SafeCounter {
    value: Mutex<i32>, // Mutex<i32> is Send + Sync
}

impl SafeCounter {
    fn new() -> Self {
        SafeCounter {
            value: Mutex::new(0),
        }
    }

    fn increment(&self) {
        *self.value.lock().unwrap() += 1;
    }

    fn get(&self) -> i32 {
        *self.value.lock().unwrap()
    }
}

// SafeCounter is Send + Sync automatically because Mutex<i32> is Send + Sync

// --- A type that is NOT thread-safe (wraps Rc) ---
// Can't be sent across threads — compiler enforces this
// struct NotSafe { inner: Rc<i32> }
// thread::spawn(move || { let _ = NotSafe { inner: Rc::new(1) }; });
// ^ error: `Rc<i32>` cannot be sent between threads safely

// --- Manually implementing Send (unsafe) ---
// Only needed for raw pointers or FFI types
// In practice, almost never needed
#[allow(dead_code)]
struct MyPointer(*mut i32);

// SAFETY: we guarantee this pointer is only accessed from one thread at a time
unsafe impl Send for MyPointer {}

fn main() {
    // Send: moving values to threads
    let handle = send_to_thread(String::from("hello"));
    println!("{}", handle.join().unwrap()); // hello

    let handle = send_to_thread(vec![1, 2, 3]);
    println!("{:?}", handle.join().unwrap()); // [1, 2, 3]

    // Sync: sharing references across threads via Arc
    let shared = Arc::new(vec![10, 20, 30]);
    share_across_threads(shared);
    println!("shared safely"); // shared safely

    // Arc<T> is Send + Sync when T: Send + Sync
    let data = Arc::new(42i32);
    let data2 = Arc::clone(&data);
    let handle = thread::spawn(move || {
        println!("{}", *data2); // 42
    });
    handle.join().unwrap();

    // SafeCounter used across threads
    let counter = Arc::new(SafeCounter::new());
    let mut handles = vec![];

    for _ in 0..5 {
        let c = Arc::clone(&counter);
        handles.push(thread::spawn(move || c.increment()));
    }
    for h in handles {
        h.join().unwrap();
    }
    println!("{}", counter.get()); // 5

    // Compile-time guarantees summary:
    // Arc<T>          — Send + Sync when T: Send + Sync (shared ownership, threads)
    // Mutex<T>        — Send when T: Send, Sync when T: Send (interior mutability, threads)
    // Arc<Mutex<T>>   — the go-to pattern for shared mutable state across threads
    // Rc<T>           — NOT Send, NOT Sync (single-thread only)
    // RefCell<T>      — Send when T: Send, NOT Sync (single-thread interior mutability)

    println!("Send + Sync enforced at compile time — no runtime cost"); // Send + Sync enforced at compile time — no runtime cost
}
