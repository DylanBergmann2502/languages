#!/usr/bin/env rust-script
//! ```cargo
//! [package]
//! edition = "2021"
//! [dependencies]
//! tokio = { version = "1", features = ["full"] }
//! tokio-stream = "0.1"
//! futures = "0.3"
//! async-stream = "0.3"
//! ```

// Async streams: asynchronous sequences of values
//
// Stream trait (from futures): like Iterator but async
// trait Stream {
//     type Item;
//     fn poll_next(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Option<Self::Item>>;
// }
//
// None  => stream is done
// Some(v) => next value
//
// tokio-stream: utilities for working with streams in tokio
// async-stream: the stream! macro for generator-style streams

use async_stream::stream;
use futures::stream::{self as fstream, Stream};
use std::pin::Pin;
use std::time::Duration;
use tokio::time::sleep;
use tokio_stream::{self as stream, StreamExt};

// --- Creating streams ---

// iter: from an iterator
fn numbers_stream() -> impl Stream<Item = i32> {
    fstream::iter(vec![1, 2, 3, 4, 5])
}

// stream! macro: generator-style, yield values one at a time
fn countdown(from: i32) -> impl Stream<Item = i32> {
    stream! {
        for i in (1..=from).rev() {
            sleep(Duration::from_millis(5)).await;
            yield i;
        }
    }
}

fn fibonacci() -> impl Stream<Item = u64> {
    stream! {
        let (mut a, mut b) = (0u64, 1u64);
        loop {
            yield a;
            (a, b) = (b, a + b);
        }
    }
}

// Async stream from a channel
fn event_stream(count: u32) -> Pin<Box<dyn Stream<Item = String> + Send>> {
    let (tx, rx) = tokio::sync::mpsc::channel(16);

    tokio::spawn(async move {
        for i in 0..count {
            sleep(Duration::from_millis(5)).await;
            tx.send(format!("event_{}", i)).await.unwrap();
        }
    });

    Box::pin(tokio_stream::wrappers::ReceiverStream::new(rx))
}

#[tokio::main]
async fn main() {
    // --- Consuming a stream ---
    let mut s = numbers_stream();
    while let Some(n) = s.next().await {
        print!("{} ", n);
    }
    println!(); // 1 2 3 4 5

    // --- Stream adaptors (like Iterator adaptors) ---
    // tokio-stream's StreamExt uses plain closures (not async) for map/filter/fold

    // map
    let mapped: Vec<i32> = stream::iter(1..=5).map(|x| x * x).collect().await;
    println!("{:?}", mapped); // [1, 4, 9, 16, 25]

    // filter
    let evens: Vec<i32> = stream::iter(1..=10).filter(|x| x % 2 == 0).collect().await;
    println!("{:?}", evens); // [2, 4, 6, 8, 10]

    // filter_map
    let even_squares: Vec<i32> = stream::iter(1..=10)
        .filter_map(|x| if x % 2 == 0 { Some(x * x) } else { None })
        .collect()
        .await;
    println!("{:?}", even_squares); // [4, 16, 36, 64, 100]

    // take: limit stream length
    let first_three: Vec<i32> = stream::iter(1..).take(3).collect().await;
    println!("{:?}", first_three); // [1, 2, 3]

    // fold: reduce stream to a single value
    let sum: i32 = stream::iter(1..=5).fold(0i32, |acc, x| acc + x).await;
    println!("{}", sum); // 15

    // --- countdown stream (async, with delays) ---
    let mut cd = std::pin::pin!(countdown(5));
    while let Some(n) = cd.next().await {
        print!("{} ", n);
    }
    println!(); // 5 4 3 2 1

    // --- fibonacci stream with take ---
    let fibs: Vec<u64> = std::pin::pin!(fibonacci()).take(10).collect().await;
    println!("{:?}", fibs); // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

    // --- stream from channel ---
    let mut events = event_stream(4);
    while let Some(event) = events.next().await {
        println!("{}", event);
    }
    // event_0
    // event_1
    // event_2
    // event_3

    // --- tokio_stream utilities ---

    // stream::iter (tokio version)
    let mut ts = stream::iter(vec!["a", "b", "c"]);
    while let Some(s) = ts.next().await {
        print!("{} ", s);
    }
    println!(); // a b c

    // StreamExt::timeout: error if item takes too long
    let mut slow_stream = std::pin::pin!(stream! {
        sleep(Duration::from_millis(5)).await;
        yield 1i32;
        sleep(Duration::from_millis(200)).await; // too slow
        yield 2i32;
    });

    let limited = slow_stream.as_mut().timeout(Duration::from_millis(50));
    tokio::pin!(limited);

    while let Some(result) = limited.next().await {
        match result {
            Ok(n) => println!("got: {}", n), // got: 1
            Err(_) => {
                println!("timed out");
                break;
            } // timed out
        }
    }

    println!("async streams done"); // async streams done
}
