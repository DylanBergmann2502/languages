#!/usr/bin/env rust-script
//! ```cargo
//! [package]
//! edition = "2021"
//! [dependencies]
//! tokio = { version = "1", features = ["full"] }
//! futures = "0.3"
//! ```

// Tokio: the most widely used async runtime for Rust
// Provides: async task scheduler, I/O, timers, channels, sync primitives
//
// #[tokio::main] — sets up a multi-threaded runtime for main
// #[tokio::main(flavor = "current_thread")] — single-threaded runtime
// tokio::Runtime::new() — manual runtime setup

use futures::future::join_all;
use std::sync::Arc;
use std::time::Duration;
use tokio::sync::{Mutex, RwLock, mpsc, oneshot};
use tokio::time::{Instant, sleep, timeout};

// --- Tasks ---
async fn task_demo() {
    // tokio::spawn: schedule a task on the runtime, runs concurrently
    // Returns JoinHandle<T> — like thread::spawn
    let handle = tokio::spawn(async {
        sleep(Duration::from_millis(10)).await;
        42
    });

    println!("{}", handle.await.unwrap()); // 42

    // Spawning multiple tasks
    let handles: Vec<_> = (0..5)
        .map(|i| {
            tokio::spawn(async move {
                sleep(Duration::from_millis(5)).await;
                i * i
            })
        })
        .collect();

    let mut results: Vec<i32> = join_all(handles)
        .await
        .into_iter()
        .map(|r| r.unwrap())
        .collect();
    results.sort();
    println!("{:?}", results); // [0, 1, 4, 9, 16]
}

// --- Timers ---
async fn timer_demo() {
    let start = Instant::now();

    sleep(Duration::from_millis(20)).await;
    println!("slept: {}ms", start.elapsed().as_millis()); // slept: ~20ms

    // timeout: fail if a future takes too long
    let result = timeout(
        Duration::from_millis(5),
        sleep(Duration::from_millis(50)), // takes 50ms
    )
    .await;
    println!("{}", result.is_err()); // true (timed out)

    let result = timeout(
        Duration::from_millis(50),
        sleep(Duration::from_millis(5)), // takes 5ms
    )
    .await;
    println!("{}", result.is_ok()); // true (finished in time)

    // tokio::time::interval: repeating timer
    let mut interval = tokio::time::interval(Duration::from_millis(10));
    let mut ticks = 0;
    loop {
        interval.tick().await;
        ticks += 1;
        if ticks == 3 {
            break;
        }
    }
    println!("ticked {} times", ticks); // ticked 3 times
}

// --- Tokio channels ---
async fn channel_demo() {
    // mpsc: multiple producer, single consumer (async version)
    let (tx, mut rx) = mpsc::channel::<String>(32); // buffer size 32

    let tx2 = tx.clone();

    tokio::spawn(async move {
        tx.send(String::from("hello")).await.unwrap();
        tx.send(String::from("world")).await.unwrap();
    });

    tokio::spawn(async move {
        tx2.send(String::from("from tx2")).await.unwrap();
    });

    // Give tasks a moment to send
    sleep(Duration::from_millis(10)).await;

    // Drain the channel
    let mut msgs = vec![];
    while let Ok(msg) = rx.try_recv() {
        msgs.push(msg);
    }
    msgs.sort();
    println!("{:?}", msgs); // ["from tx2", "hello", "world"]

    // oneshot: send exactly one value (request/response pattern)
    let (resp_tx, resp_rx) = oneshot::channel::<i32>();

    tokio::spawn(async move {
        let result = 42;
        resp_tx.send(result).unwrap();
    });

    println!("{}", resp_rx.await.unwrap()); // 42
}

// --- Tokio sync primitives (async-aware) ---
async fn sync_demo() {
    // tokio::sync::Mutex: async-aware mutex (use instead of std::sync::Mutex in async code)
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..5 {
        let counter = Arc::clone(&counter);
        handles.push(tokio::spawn(async move {
            let mut n = counter.lock().await; // .await instead of .unwrap()
            *n += 1;
        }));
    }

    for h in handles {
        h.await.unwrap();
    }
    println!("{}", *counter.lock().await); // 5

    // tokio::sync::RwLock: async-aware read/write lock
    let data = Arc::new(RwLock::new(vec![1, 2, 3]));

    // Multiple concurrent readers
    let d1 = Arc::clone(&data);
    let d2 = Arc::clone(&data);
    let (r1, r2) = tokio::join!(
        async move { d1.read().await.iter().sum::<i32>() },
        async move { d2.read().await.iter().sum::<i32>() },
    );
    println!("{} {}", r1, r2); // 6 6

    // One writer
    data.write().await.push(4);
    println!("{:?}", *data.read().await); // [1, 2, 3, 4]
}

// --- Blocking code in async context ---
async fn blocking_demo() {
    // tokio::task::spawn_blocking: run CPU-heavy or blocking code on a thread pool
    // Prevents blocking the async executor
    let result = tokio::task::spawn_blocking(|| {
        // This runs on a dedicated thread, not the async runtime thread
        let sum: u64 = (1..=1_000_000).sum();
        sum
    })
    .await
    .unwrap();

    println!("{}", result); // 500000500000
}

#[tokio::main]
async fn main() {
    task_demo().await;
    // 42
    // [0, 1, 4, 9, 16]

    timer_demo().await;
    // slept: ~20ms
    // true (timeout)
    // true (ok)
    // ticked 3 times

    channel_demo().await;
    // ["from tx2", "hello", "world"]
    // 42

    sync_demo().await;
    // 5
    // 6 6
    // [1, 2, 3, 4]

    blocking_demo().await;
    // 500000500000
}
