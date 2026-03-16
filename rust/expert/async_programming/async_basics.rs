#!/usr/bin/env rust-script
//! ```cargo
//! [package]
//! edition = "2021"
//! [dependencies]
//! tokio = { version = "1", features = ["full"] }
//! ```

// async/await in Rust
//
// async fn returns a Future — a value representing a computation that hasn't happened yet
// .await suspends the current task until the Future resolves
// An async runtime (tokio, async-std) drives futures to completion
//
// Unlike threads: async tasks are lightweight, many can run on few OS threads
// Unlike callbacks: async/await reads like synchronous code

use std::time::Duration;
use tokio::time::sleep;

// --- Basic async function ---
async fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

// --- Async with simulated I/O delay ---
async fn fetch_user(id: u32) -> String {
    sleep(Duration::from_millis(10)).await; // simulate network/db delay
    format!("User(id={})", id)
}

async fn fetch_score(user_id: u32) -> u32 {
    sleep(Duration::from_millis(10)).await;
    user_id * 100
}

// --- Sequential vs concurrent execution ---
async fn sequential() {
    let start = std::time::Instant::now();
    let user = fetch_user(1).await; // wait for user first
    let score = fetch_score(1).await; // then wait for score
    println!("{} -> score {}", user, score); // User(id=1) -> score 100
    println!("sequential: {}ms", start.elapsed().as_millis()); // ~20ms
}

async fn concurrent() {
    let start = std::time::Instant::now();
    // tokio::join! runs both futures concurrently — both start immediately
    let (user, score) = tokio::join!(fetch_user(2), fetch_score(2),);
    println!("{} -> score {}", user, score); // User(id=2) -> score 200
    println!("concurrent: {}ms", start.elapsed().as_millis()); // ~10ms
}

// --- async blocks ---
async fn async_blocks() {
    let result = async {
        sleep(Duration::from_millis(5)).await;
        42
    }
    .await;
    println!("{}", result); // 42
}

// --- Returning errors from async functions ---
async fn parse_number(s: &str) -> Result<i32, String> {
    sleep(Duration::from_millis(1)).await;
    s.parse::<i32>().map_err(|e| e.to_string())
}

// --- Async with ? operator ---
async fn compute(a: &str, b: &str) -> Result<i32, String> {
    let x = parse_number(a).await?;
    let y = parse_number(b).await?;
    Ok(x + y)
}

// --- Spawning concurrent tasks ---
async fn spawn_tasks() {
    let mut handles = vec![];

    for i in 0..5 {
        // tokio::spawn: runs the task concurrently, returns a JoinHandle
        let handle = tokio::spawn(async move {
            sleep(Duration::from_millis(5)).await;
            i * i
        });
        handles.push(handle);
    }

    let mut results = vec![];
    for handle in handles {
        results.push(handle.await.unwrap());
    }
    results.sort();
    println!("{:?}", results); // [0, 1, 4, 9, 16]
}

// --- tokio::select!: race multiple futures, use whichever finishes first ---
async fn select_demo() {
    let fast = async {
        sleep(Duration::from_millis(5)).await;
        "fast"
    };
    let slow = async {
        sleep(Duration::from_millis(50)).await;
        "slow"
    };

    tokio::select! {
        result = fast => println!("won: {}", result),   // won: fast
        result = slow => println!("won: {}", result),
    }
}

// --- #[tokio::main]: sets up the async runtime for main ---
#[tokio::main]
async fn main() {
    // Basic async/await
    let msg = greet("Alice").await;
    println!("{}", msg); // Hello, Alice!

    // Async with delay
    let user = fetch_user(42).await;
    println!("{}", user); // User(id=42)

    // Sequential vs concurrent
    sequential().await; // ~20ms
    concurrent().await; // ~10ms

    // Async blocks
    async_blocks().await; // 42

    // Error handling
    println!("{:?}", parse_number("42").await); // Ok(42)
    println!("{:?}", parse_number("abc").await); // Err("invalid digit...")

    println!("{:?}", compute("10", "32").await); // Ok(42)
    println!("{:?}", compute("10", "x").await); // Err("invalid digit...")

    // Spawning tasks
    spawn_tasks().await; // [0, 1, 4, 9, 16]

    // Select
    select_demo().await; // won: fast
}
