// cargo_basics.rs — Cargo concepts, commands, and project structure
// This file is a reference/notes lesson. The hands-on companion is simple_project/
// Run: rust-script cargo_basics.rs

fn main() {
    // -----------------------------------------------------------------------
    // WHAT IS CARGO?
    // -----------------------------------------------------------------------
    // Cargo is Rust's build system and package manager — like npm for JS,
    // pip for Python, bundler for Ruby, or mix for Elixir.
    // It handles: building, testing, dependencies, publishing.

    // -----------------------------------------------------------------------
    // CREATING A PROJECT
    // -----------------------------------------------------------------------
    // cargo new my_project          — creates a binary project (has main.rs)
    // cargo new my_lib --lib        — creates a library project (has lib.rs)
    // cargo init                    — initialize Cargo in an existing directory
    //
    // Project layout:
    //   my_project/
    //   ├── Cargo.toml              — manifest: name, version, dependencies
    //   ├── Cargo.lock              — locked dependency versions (like package-lock.json)
    //   └── src/
    //       └── main.rs             — entry point for binaries

    // -----------------------------------------------------------------------
    // CARGO.TOML
    // -----------------------------------------------------------------------
    // [package]
    // name = "my_project"
    // version = "0.1.0"
    // edition = "2021"              — Rust edition (2015, 2018, 2021)
    //
    // [dependencies]
    // serde = "1.0"                 — exact minor (^1.0 = >= 1.0.0, < 2.0.0)
    // rand = "0.8.5"                — exact patch
    // my_lib = { path = "../my_lib" } — local path dependency
    // my_crate = { git = "https://github.com/..." } — git dependency
    //
    // [dev-dependencies]            — only for tests and examples
    // pretty_assertions = "1.0"
    //
    // [build-dependencies]          — only for build scripts

    // -----------------------------------------------------------------------
    // ESSENTIAL COMMANDS
    // -----------------------------------------------------------------------
    // cargo build                   — compile (debug mode)
    // cargo build --release         — compile with optimizations
    // cargo run                     — build + run
    // cargo run -- arg1 arg2        — pass args to your program
    // cargo check                   — fast type-check, no binary produced
    // cargo test                    — run all tests
    // cargo clean                   — remove target/ directory
    // cargo doc --open              — generate and open docs in browser
    // cargo fmt                     — format code (like rustfmt)
    // cargo clippy                  — lint (catches common mistakes)

    // -----------------------------------------------------------------------
    // MANAGING DEPENDENCIES
    // -----------------------------------------------------------------------
    // cargo add serde               — add latest serde to Cargo.toml
    // cargo add serde --features derive  — add with specific features
    // cargo add rand@0.10           — add specific version
    // cargo remove serde            — remove a dependency
    // cargo update                  — update Cargo.lock to latest compatible
    // cargo update -p rand          — update only rand

    // -----------------------------------------------------------------------
    // BUILD PROFILES
    // -----------------------------------------------------------------------
    // debug   (cargo build)         — fast compile, slow runtime, debug symbols
    // release (cargo build --release) — slow compile, fast runtime, optimized
    //
    // Customize in Cargo.toml:
    // [profile.release]
    // opt-level = 3                 — 0=none, 1=basic, 2=some, 3=all, "s"=size, "z"=min size
    // debug = false
    //
    // [profile.dev]
    // opt-level = 0
    // debug = true

    // -----------------------------------------------------------------------
    // THE TARGET DIRECTORY
    // -----------------------------------------------------------------------
    // target/
    // ├── debug/                    — debug builds
    // │   └── my_project            — the compiled binary
    // ├── release/                  — release builds
    // └── doc/                      — generated documentation
    //
    // target/ is gitignored by default (like node_modules/)

    // -----------------------------------------------------------------------
    // CARGO.LOCK
    // -----------------------------------------------------------------------
    // Pinned exact versions of every dependency (transitive too).
    // Binaries: commit Cargo.lock (reproducible builds)
    // Libraries: don't commit Cargo.lock (let consumers choose versions)

    // -----------------------------------------------------------------------
    // FEATURES
    // -----------------------------------------------------------------------
    // Crates can have optional features — like plugins/extras
    //
    // [features]
    // default = ["std"]
    // std = []
    // async = ["tokio"]
    //
    // cargo add serde --features derive
    // cargo build --features async
    // cargo build --no-default-features

    // -----------------------------------------------------------------------
    // USEFUL CRATES (the ecosystem)
    // -----------------------------------------------------------------------
    // serde / serde_json  — serialization (like Python's json module)
    // tokio               — async runtime (like asyncio)
    // reqwest             — HTTP client (like Python's requests)
    // clap                — CLI argument parsing (like argparse)
    // tracing             — structured logging
    // anyhow / thiserror  — ergonomic error handling
    // rand                — random number generation
    // chrono              — date/time
    // sqlx                — async SQL (like Django ORM but lower level)
    // axum / actix-web    — web frameworks (like Django/Flask)

    println!("See simple_project/ for a hands-on Cargo project.");
    println!("Try: cd simple_project && cargo run");
}
