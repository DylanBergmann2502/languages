use std::sync::atomic::{AtomicBool, AtomicI32, AtomicUsize, Ordering};
use std::sync::Arc;
use std::thread;

// Atomic types: thread-safe primitives without Mutex overhead
// Live in std::sync::atomic
// Available: AtomicBool, AtomicI8/I16/I32/I64/Isize, AtomicU8/.../Usize, AtomicPtr
//
// Ordering controls how operations are synchronized across threads:
//   Relaxed  — no ordering guarantees, just atomicity (fastest)
//   Acquire  — ensures subsequent reads see prior writes from the releasing thread
//   Release  — ensures prior writes are visible to the acquiring thread
//   AcqRel   — both Acquire and Release (for read-modify-write ops)
//   SeqCst   — total sequential consistency across all threads (slowest, safest)

fn main() {
    // --- AtomicUsize: lock-free counter ---
    let counter = Arc::new(AtomicUsize::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            counter.fetch_add(1, Ordering::Relaxed);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("{}", counter.load(Ordering::Relaxed)); // 10

    // --- AtomicI32: basic operations ---
    let n = AtomicI32::new(0);

    n.store(42, Ordering::Relaxed);
    println!("{}", n.load(Ordering::Relaxed)); // 42

    let old = n.fetch_add(8, Ordering::Relaxed);
    println!("{}", old); // 42  (returns OLD value)
    println!("{}", n.load(Ordering::Relaxed)); // 50

    let old = n.fetch_sub(20, Ordering::Relaxed);
    println!("{}", old); // 50
    println!("{}", n.load(Ordering::Relaxed)); // 30

    // swap: stores new value, returns old
    let old = n.swap(100, Ordering::Relaxed);
    println!("{}", old); // 30
    println!("{}", n.load(Ordering::Relaxed)); // 100

    // compare_exchange: only stores if current == expected
    // compare_exchange(expected, new, success_ordering, failure_ordering)
    let result = n.compare_exchange(100, 200, Ordering::SeqCst, Ordering::Relaxed);
    println!("{:?}", result); // Ok(100)  — succeeded, returns old value
    println!("{}", n.load(Ordering::Relaxed)); // 200

    let result = n.compare_exchange(999, 300, Ordering::SeqCst, Ordering::Relaxed);
    println!("{:?}", result); // Err(200) — failed, returns current value
    println!("{}", n.load(Ordering::Relaxed)); // 200  — unchanged

    // --- AtomicBool: flags and signals ---
    let running = Arc::new(AtomicBool::new(true));
    let running2 = Arc::clone(&running);

    let handle = thread::spawn(move || {
        let mut count = 0;
        while running2.load(Ordering::Acquire) {
            count += 1;
            if count >= 5 {
                break;
            }
        }
        println!("worker did {} iterations", count); // worker did 5 iterations
    });

    handle.join().unwrap();
    running.store(false, Ordering::Release);

    // --- AtomicBool as a once-init flag ---
    let initialized = Arc::new(AtomicBool::new(false));
    let mut handles = vec![];

    for i in 0..5 {
        let initialized = Arc::clone(&initialized);
        let handle = thread::spawn(move || {
            // Only the first thread to win compare_exchange gets to initialize
            if initialized
                .compare_exchange(false, true, Ordering::AcqRel, Ordering::Relaxed)
                .is_ok()
            {
                println!("thread {} initialized the resource", i);
            } else {
                println!("thread {} skipped — already initialized", i);
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
    // thread X initialized the resource  (exactly once)
    // thread Y skipped — already initialized  (4 times)

    // --- fetch_max / fetch_min ---
    let peak = Arc::new(AtomicI32::new(0));
    let mut handles = vec![];

    for i in [3, 7, 1, 9, 4, 6] {
        let peak = Arc::clone(&peak);
        let handle = thread::spawn(move || {
            peak.fetch_max(i, Ordering::Relaxed);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("{}", peak.load(Ordering::Relaxed)); // 9

    println!("done"); // done
}
