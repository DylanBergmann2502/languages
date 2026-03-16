use std::sync::{Arc, Mutex, RwLock};
use std::thread;

fn main() {
    // --- Mutex<T>: mutual exclusion — only one thread accesses data at a time ---
    // Arc<T>: Atomic Reference Count — like Rc<T> but thread-safe
    // Arc<Mutex<T>> is the standard pattern for shared mutable state across threads

    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap(); // blocks until lock acquired
            *num += 1;
            // MutexGuard dropped here — lock released automatically
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("{}", *counter.lock().unwrap()); // 10

    // --- Mutex with more complex data ---
    let shared_vec: Arc<Mutex<Vec<i32>>> = Arc::new(Mutex::new(vec![]));
    let mut handles = vec![];

    for i in 0..5 {
        let shared_vec = Arc::clone(&shared_vec);
        let handle = thread::spawn(move || {
            let mut v = shared_vec.lock().unwrap();
            v.push(i * i);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    let mut result = shared_vec.lock().unwrap().clone();
    result.sort();
    println!("{:?}", result); // [0, 1, 4, 9, 16]

    // --- try_lock: non-blocking attempt ---
    let m = Arc::new(Mutex::new(42));
    let m2 = Arc::clone(&m);

    let _guard = m.lock().unwrap(); // hold the lock

    // try_lock fails immediately if already locked
    match m2.try_lock() {
        Ok(val) => println!("got: {}", val),
        Err(_) => println!("lock busy"), // lock busy
    }
    drop(_guard); // release lock

    match m2.try_lock() {
        Ok(val) => println!("got: {}", val), // got: 42
        Err(_) => println!("lock busy"),
    }

    // --- RwLock<T>: multiple readers OR one writer ---
    // More efficient than Mutex when reads are frequent and writes are rare
    let data = Arc::new(RwLock::new(vec![1, 2, 3, 4, 5]));
    let mut handles = vec![];

    // Spawn 4 reader threads — all can read simultaneously
    for i in 0..4 {
        let data = Arc::clone(&data);
        let handle = thread::spawn(move || {
            let r = data.read().unwrap(); // read lock — multiple allowed
            println!("reader {}: sum = {}", i, r.iter().sum::<i32>());
        });
        handles.push(handle);
    }

    // Spawn 1 writer thread
    {
        let data = Arc::clone(&data);
        let handle = thread::spawn(move || {
            let mut w = data.write().unwrap(); // write lock — exclusive
            w.push(6);
            println!("writer added 6: {:?}", *w);
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
    // reader 0: sum = 15  (or 21 if writer ran first)
    // reader 1: sum = 15
    // reader 2: sum = 15
    // reader 3: sum = 15
    // writer added 6: [1, 2, 3, 4, 5, 6]

    // Final state
    let final_data = data.read().unwrap();
    println!("{:?}", *final_data); // [1, 2, 3, 4, 5, 6]

    // --- Deadlock warning ---
    // Never lock the same Mutex twice in the same thread — it will deadlock
    // Never acquire locks in different orders across threads — it will deadlock
    // Keep lock scope as small as possible (drop early if needed)

    let m = Mutex::new(0);
    {
        let mut val = m.lock().unwrap();
        *val = 99;
    } // lock released here
    println!("{}", m.lock().unwrap()); // 99
}
