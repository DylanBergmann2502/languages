#!/usr/bin/env rust-script
//! ```cargo
//! [package]
//! edition = "2021"
//! [dependencies]
//! tokio = { version = "1", features = ["full"] }
//! futures = "0.3"
//! ```

// The Future trait: the foundation of async Rust
//
// trait Future {
//     type Output;
//     fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output>;
// }
//
// Poll::Pending  — not ready yet, will wake cx.waker() when ready
// Poll::Ready(v) — computation complete, returns value v
//
// You rarely implement Future manually — async fn does it for you.
// But understanding it helps debug complex async code.

use futures::future::{self, FutureExt};
use std::future::Future;
use std::pin::Pin;
use std::task::{Context, Poll};
use std::time::{Duration, Instant};
use tokio::time::sleep;

// --- Manual Future implementation ---
// A future that resolves after a deadline
struct ReadyAfter {
    deadline: Instant,
    value: i32,
}

impl ReadyAfter {
    fn new(delay_ms: u64, value: i32) -> Self {
        ReadyAfter {
            deadline: Instant::now() + Duration::from_millis(delay_ms),
            value,
        }
    }
}

impl Future for ReadyAfter {
    type Output = i32;

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<i32> {
        if Instant::now() >= self.deadline {
            Poll::Ready(self.value)
        } else {
            // Schedule a wakeup so the runtime tries again
            let waker = cx.waker().clone();
            let deadline = self.deadline;
            tokio::spawn(async move {
                let remaining = deadline.saturating_duration_since(Instant::now());
                sleep(remaining).await;
                waker.wake();
            });
            Poll::Pending
        }
    }
}

// --- Chaining futures with combinators ---
async fn double(n: i32) -> i32 {
    n * 2
}
async fn add_one(n: i32) -> i32 {
    n + 1
}
async fn to_string(n: i32) -> String {
    format!("result: {}", n)
}

// --- futures crate: combinators ---
async fn combinators_demo() {
    // future::ready: immediately resolved future (like Promise.resolve)
    let val = future::ready(42).await;
    println!("{}", val); // 42

    // future::lazy: only starts computing when polled
    let lazy = future::lazy(|_| 100);
    println!("{}", lazy.await); // 100

    // .map on a future (transforms the output)
    let doubled = future::ready(21).map(|x| x * 2).await;
    println!("{}", doubled); // 42

    // .then: chain futures (like flatMap / andThen)
    let chained = future::ready(5)
        .then(|x| async move { x * x })
        .then(|x| async move { format!("squared: {}", x) })
        .await;
    println!("{}", chained); // squared: 25

    // future::join: run two futures concurrently, wait for both
    let (a, b) = future::join(future::ready(10), future::ready(20)).await;
    println!("{} {}", a, b); // 10 20

    // future::join_all: wait for a Vec of futures
    let futures_vec = vec![future::ready(1), future::ready(2), future::ready(3)];
    let results = future::join_all(futures_vec).await;
    println!("{:?}", results); // [1, 2, 3]

    // future::select: race two futures
    let fast = Box::pin(future::ready("fast"));
    let slow = Box::pin(async {
        sleep(Duration::from_millis(50)).await;
        "slow"
    });

    match future::select(fast, slow).await {
        future::Either::Left((val, _)) => println!("left won: {}", val), // left won: fast
        future::Either::Right((val, _)) => println!("right won: {}", val),
    }
}

// --- Pin<T>: prevents a future from being moved in memory ---
// Futures can contain self-references (e.g. a reference to data within the same struct).
// If the future is moved, those references become invalid.
// Pin<&mut T> guarantees the value won't move.
//
// In practice: Box::pin() or tokio::pin!() when you need to pin a future.

async fn pinning_demo() {
    // async fn + .await handles pinning for you automatically
    // You only need to think about Pin when:
    //   - Storing futures in structs
    //   - Calling poll() manually
    //   - Using select! with futures that don't impl Unpin

    // Box::pin: heap-allocate and pin a future
    let pinned: Pin<Box<dyn Future<Output = i32>>> = Box::pin(async { 42 });
    println!("{}", pinned.await); // 42

    // tokio::pin!: stack-pin a future (for use with select!)
    let fut = async { 99 };
    tokio::pin!(fut);
    println!("{}", fut.await); // 99
}

// --- Async trait methods (requires boxing) ---
// async fn in traits isn't directly stable in all contexts
// Common pattern: return Box<dyn Future<...> + Send>

trait AsyncProcessor {
    fn process<'a>(&'a self, input: i32) -> Pin<Box<dyn Future<Output = i32> + Send + 'a>>;
}

struct Doubler;

impl AsyncProcessor for Doubler {
    fn process<'a>(&'a self, input: i32) -> Pin<Box<dyn Future<Output = i32> + Send + 'a>> {
        Box::pin(async move { input * 2 })
    }
}

#[tokio::main]
async fn main() {
    // Manual Future implementation
    let result = ReadyAfter::new(10, 42).await;
    println!("{}", result); // 42

    // Async chaining
    let n = double(5).await;
    let n = add_one(n).await;
    let s = to_string(n).await;
    println!("{}", s); // result: 11

    // Combinators
    combinators_demo().await;
    // 42, 100, 42, squared: 25, 10 20, [1, 2, 3], left won: fast

    // Pinning
    pinning_demo().await; // 42, 99

    // Async trait
    let processor = Doubler;
    let result = processor.process(21).await;
    println!("{}", result); // 42
}
