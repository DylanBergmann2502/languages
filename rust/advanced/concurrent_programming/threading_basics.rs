use std::thread;
use std::time::Duration;

fn main() {
    // --- Spawning a basic thread ---
    let handle = thread::spawn(|| {
        for i in 1..=5 {
            println!("spawned thread: {}", i);
            thread::sleep(Duration::from_millis(10));
        }
    });

    for i in 1..=3 {
        println!("main thread: {}", i);
        thread::sleep(Duration::from_millis(10));
    }

    // join() blocks main thread until spawned thread finishes
    handle.join().unwrap();
    // main thread: 1
    // spawned thread: 1
    // main thread: 2
    // spawned thread: 2
    // ... (interleaved, order not guaranteed)

    // --- move closures with threads ---
    // Thread closures must own their data — use move
    let data = vec![1, 2, 3, 4, 5];

    let handle = thread::spawn(move || {
        println!("{:?}", data); // [1, 2, 3, 4, 5]
    });

    handle.join().unwrap();
    // println!("{:?}", data); // error: data moved into thread

    // --- Multiple threads ---
    let mut handles = vec![];

    for i in 0..5 {
        let handle = thread::spawn(move || {
            println!("thread {} starting", i);
            thread::sleep(Duration::from_millis(5));
            println!("thread {} done", i);
            i * i // threads can return values
        });
        handles.push(handle);
    }

    let results: Vec<i32> = handles.into_iter().map(|h| h.join().unwrap()).collect();
    println!("{:?}", results); // [0, 1, 4, 9, 16] (order matches spawn order)

    // --- Thread builder: naming threads and setting stack size ---
    let handle = thread::Builder::new()
        .name(String::from("worker"))
        .spawn(|| {
            let name = thread::current().name().unwrap_or("unknown").to_string();
            println!("running as thread: {}", name); // running as thread: worker
        })
        .unwrap();

    handle.join().unwrap();

    // --- Handling panics in threads ---
    // A panic in a spawned thread doesn't crash the whole program
    // join() returns Err if the thread panicked
    let handle = thread::spawn(|| {
        panic!("something went wrong in thread");
    });

    match handle.join() {
        Ok(_) => println!("thread finished fine"),
        Err(_) => println!("thread panicked — caught safely"), // thread panicked — caught safely
    }

    // --- thread::current and thread::sleep ---
    let main_name = thread::current().name().unwrap_or("main").to_string();
    println!("current thread: {}", main_name); // current thread: main

    // thread::yield_now() hints the scheduler to switch threads
    let handle = thread::spawn(|| {
        thread::yield_now();
        println!("yielded and resumed"); // yielded and resumed
    });
    handle.join().unwrap();

    println!("all done"); // all done
}
