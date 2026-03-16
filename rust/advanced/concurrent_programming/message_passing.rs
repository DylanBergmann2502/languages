use std::sync::mpsc;
use std::thread;
use std::time::Duration;

// mpsc = multiple producer, single consumer
// tx = transmitter (sender), rx = receiver

fn main() {
    // --- Basic channel ---
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        tx.send(String::from("hello from thread")).unwrap();
    });

    let msg = rx.recv().unwrap(); // blocks until message arrives
    println!("{}", msg); // hello from thread

    // --- Sending multiple messages ---
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let messages = vec!["one", "two", "three", "four"];
        for msg in messages {
            tx.send(msg).unwrap();
            thread::sleep(Duration::from_millis(10));
        }
        // tx dropped here — channel closes, rx loop ends
    });

    for received in rx {
        // rx acts as an iterator
        println!("{}", received);
    }
    // one
    // two
    // three
    // four

    // --- Multiple producers (clone the sender) ---
    let (tx, rx) = mpsc::channel();
    let tx2 = tx.clone();

    thread::spawn(move || {
        for i in 0..3 {
            tx.send(format!("tx: {}", i)).unwrap();
            thread::sleep(Duration::from_millis(5));
        }
    });

    thread::spawn(move || {
        for i in 0..3 {
            tx2.send(format!("tx2: {}", i)).unwrap();
            thread::sleep(Duration::from_millis(5));
        }
    });

    let mut all: Vec<String> = rx.iter().collect();
    all.sort(); // sort for deterministic output
    for msg in &all {
        println!("{}", msg);
    }
    // tx2: 0
    // tx2: 1
    // tx2: 2
    // tx: 0
    // tx: 1
    // tx: 2

    // --- try_recv: non-blocking receive ---
    let (tx, rx) = mpsc::channel::<i32>();

    thread::spawn(move || {
        thread::sleep(Duration::from_millis(50));
        tx.send(42).unwrap();
    });

    loop {
        match rx.try_recv() {
            Ok(val) => {
                println!("got: {}", val); // got: 42
                break;
            }
            Err(mpsc::TryRecvError::Empty) => {
                println!("not ready yet..."); // not ready yet... (printed a few times)
                thread::sleep(Duration::from_millis(10));
            }
            Err(mpsc::TryRecvError::Disconnected) => break,
        }
    }

    // --- Using channels for work distribution (worker pool pattern) ---
    let (tx, rx) = mpsc::channel::<u32>();
    let rx = std::sync::Arc::new(std::sync::Mutex::new(rx));

    let mut handles = vec![];
    for id in 0..3 {
        let rx = std::sync::Arc::clone(&rx);
        let handle = thread::spawn(move || {
            loop {
                let job = rx.lock().unwrap().recv();
                match job {
                    Ok(n) => println!("worker {} processing job {}", id, n),
                    Err(_) => break, // channel closed
                }
            }
        });
        handles.push(handle);
    }

    for job in 0..6 {
        tx.send(job).unwrap();
    }
    drop(tx); // close channel so workers exit

    for handle in handles {
        handle.join().unwrap();
    }
    // worker 0 processing job 0
    // worker 1 processing job 1
    // worker 2 processing job 2
    // worker 0 processing job 3
    // ... (distribution order varies)

    println!("all workers done"); // all workers done
}
