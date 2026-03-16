// Overview of essential Rust crates
// The Rust ecosystem ("crates.io") has ~150k crates.
// This covers the ones you'll encounter in almost every real project.

fn main() {
    // -----------------------------------------------------------------------
    // SERIALIZATION
    // -----------------------------------------------------------------------
    // serde — the de-facto serialization framework
    //   cargo add serde --features derive
    //   cargo add serde_json
    //
    // use serde::{Serialize, Deserialize};
    //
    // #[derive(Serialize, Deserialize, Debug)]
    // struct User { name: String, age: u32, active: bool }
    //
    // let user = User { name: "Alice".into(), age: 30, active: true };
    // let json = serde_json::to_string(&user).unwrap();
    // // {"name":"Alice","age":30,"active":true}
    //
    // let back: User = serde_json::from_str(&json).unwrap();
    //
    // Other formats: serde_yaml, serde_toml, bincode, messagepack, cbor
    println!("serde: serialization/deserialization framework");

    // -----------------------------------------------------------------------
    // ERROR HANDLING
    // -----------------------------------------------------------------------
    // anyhow — easy error handling for applications (not libraries)
    //   cargo add anyhow
    //
    // use anyhow::{Result, Context, bail};
    //
    // fn load_config(path: &str) -> Result<Config> {
    //     let content = std::fs::read_to_string(path)
    //         .context("failed to read config file")?;
    //     let config: Config = serde_json::from_str(&content)
    //         .context("failed to parse config")?;
    //     Ok(config)
    // }
    //
    // thiserror — ergonomic custom error types for libraries
    //   cargo add thiserror
    //
    // #[derive(Debug, thiserror::Error)]
    // enum AppError {
    //     #[error("user not found: {0}")]
    //     NotFound(String),
    //     #[error("database error: {0}")]
    //     Database(#[from] sqlx::Error),
    // }
    println!("anyhow + thiserror: ergonomic error handling");

    // -----------------------------------------------------------------------
    // ASYNC RUNTIME
    // -----------------------------------------------------------------------
    // tokio — the standard async runtime
    //   cargo add tokio --features full
    //
    // #[tokio::main]
    // async fn main() { ... }
    //
    // tokio provides: tasks, timers, I/O, channels, sync primitives
    // async-std — alternative runtime (simpler API, less ecosystem)
    println!("tokio: async runtime");

    // -----------------------------------------------------------------------
    // HTTP CLIENT
    // -----------------------------------------------------------------------
    // reqwest — ergonomic HTTP client (built on tokio + hyper)
    //   cargo add reqwest --features json
    //
    // let resp = reqwest::get("https://api.example.com/users")
    //     .await?
    //     .json::<Vec<User>>()
    //     .await?;
    //
    // let client = reqwest::Client::new();
    // let resp = client.post("/api/login")
    //     .json(&LoginRequest { email, password })
    //     .send().await?;
    println!("reqwest: HTTP client");

    // -----------------------------------------------------------------------
    // WEB FRAMEWORKS
    // -----------------------------------------------------------------------
    // axum — modern, ergonomic web framework (by tokio team)
    //   cargo add axum tokio --features full
    //
    // use axum::{routing::get, Router};
    // async fn handler() -> &'static str { "Hello, World!" }
    // let app = Router::new().route("/", get(handler));
    // axum::Server::bind(&"0.0.0.0:3000".parse().unwrap())
    //     .serve(app.into_make_service()).await.unwrap();
    //
    // actix-web — high performance, actor-based
    // warp — filter-based routing
    println!("axum / actix-web: web frameworks");

    // -----------------------------------------------------------------------
    // CLI
    // -----------------------------------------------------------------------
    // clap — argument parsing (derive API)
    //   cargo add clap --features derive
    //
    // #[derive(Parser)]
    // #[command(name = "myapp")]
    // struct Cli {
    //     #[arg(short, long)]
    //     verbose: bool,
    //     #[arg(value_name = "FILE")]
    //     input: PathBuf,
    // }
    // let cli = Cli::parse();
    println!("clap: CLI argument parsing");

    // -----------------------------------------------------------------------
    // DATABASE
    // -----------------------------------------------------------------------
    // sqlx — async SQL, compile-time query verification
    //   cargo add sqlx --features runtime-tokio-tls,postgres
    //
    // let pool = PgPoolOptions::new().connect(&database_url).await?;
    // let users = sqlx::query_as!(User, "SELECT * FROM users WHERE active = $1", true)
    //     .fetch_all(&pool).await?;
    //
    // diesel — sync ORM (like ActiveRecord/Django ORM)
    // sea-orm — async ORM built on sqlx
    println!("sqlx / diesel / sea-orm: database access");

    // -----------------------------------------------------------------------
    // LOGGING AND TRACING
    // -----------------------------------------------------------------------
    // tracing — structured, async-aware instrumentation
    //   cargo add tracing tracing-subscriber
    //
    // use tracing::{info, warn, error, instrument};
    //
    // #[instrument]
    // async fn process_request(id: u32) {
    //     info!(request_id = id, "processing");
    //     warn!("something unusual");
    // }
    //
    // log — simpler logging facade (tracing is preferred for new projects)
    println!("tracing / log: structured logging");

    // -----------------------------------------------------------------------
    // RANDOM
    // -----------------------------------------------------------------------
    // rand — random number generation
    //   cargo add rand
    //
    // use rand::Rng;
    // let mut rng = rand::rng();
    // let n: u32 = rng.random_range(1..=100);
    // let choice = rng.random::<bool>();
    println!("rand: random number generation");

    // -----------------------------------------------------------------------
    // DATE/TIME
    // -----------------------------------------------------------------------
    // chrono — date, time, timezone handling
    //   cargo add chrono
    //
    // use chrono::{Utc, Local, DateTime, Duration};
    // let now: DateTime<Utc> = Utc::now();
    // let tomorrow = now + Duration::days(1);
    // println!("{}", now.format("%Y-%m-%d %H:%M:%S"));
    //
    // time — lighter alternative, no_std compatible
    println!("chrono / time: date and time");

    // -----------------------------------------------------------------------
    // CONCURRENCY
    // -----------------------------------------------------------------------
    // rayon — data parallelism with work-stealing thread pool
    //   cargo add rayon
    //
    // use rayon::prelude::*;
    // let sum: i64 = (1..=1_000_000i64).into_par_iter().sum();
    // let doubled: Vec<i32> = v.par_iter().map(|&x| x * 2).collect();
    //
    // crossbeam — channels, scoped threads, lock-free structures
    println!("rayon / crossbeam: concurrency utilities");

    // -----------------------------------------------------------------------
    // TESTING
    // -----------------------------------------------------------------------
    // proptest / quickcheck — property-based testing
    //   cargo add proptest --dev
    //
    // proptest! {
    //     #[test]
    //     fn test_sort(mut v: Vec<i32>) {
    //         v.sort();
    //         for w in v.windows(2) { assert!(w[0] <= w[1]); }
    //     }
    // }
    //
    // mockall — auto-generate mock implementations of traits
    // insta — snapshot testing
    println!("proptest / mockall / insta: testing utilities");

    // -----------------------------------------------------------------------
    // USEFUL UTILITIES
    // -----------------------------------------------------------------------
    // itertools — extra iterator adaptors (cartesian_product, chunk_by, etc.)
    // once_cell / lazy_static — lazy initialization of statics
    // bytes — efficient byte buffer manipulation (used heavily in networking)
    // indexmap — ordered HashMap (insertion-order preserved)
    // parking_lot — faster Mutex/RwLock replacements
    // dashmap — concurrent HashMap
    println!("itertools / once_cell / bytes / indexmap: utilities");

    println!("\nExplore the ecosystem at https://crates.io and https://lib.rs");
}
