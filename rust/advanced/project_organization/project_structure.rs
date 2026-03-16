// project_structure.rs — Rust project layout conventions and Cargo features
// Reference lesson. Companion: full_project/

fn main() {
    // -----------------------------------------------------------------------
    // STANDARD BINARY PROJECT
    // -----------------------------------------------------------------------
    // my_project/
    // ├── Cargo.toml
    // ├── Cargo.lock
    // ├── src/
    // │   ├── main.rs              — binary entry point (fn main)
    // │   ├── lib.rs               — optional library root (if project is both bin + lib)
    // │   ├── models/
    // │   │   ├── mod.rs           — declares submodules in models/
    // │   │   └── user.rs          — models::user module
    // │   └── utils/
    // │       ├── mod.rs
    // │       └── formatter.rs
    // ├── tests/                   — integration tests (separate crate, uses your lib)
    // │   └── integration_test.rs
    // ├── examples/                — runnable examples: cargo run --example name
    // │   └── basic_usage.rs
    // ├── benches/                 — benchmarks: cargo bench
    // │   └── my_bench.rs
    // └── target/                  — build output (gitignored)

    // -----------------------------------------------------------------------
    // LIBRARY PROJECT (cargo new my_lib --lib)
    // -----------------------------------------------------------------------
    // my_lib/
    // ├── Cargo.toml
    // └── src/
    //     └── lib.rs               — library root, no main()

    // -----------------------------------------------------------------------
    // BIN + LIB IN THE SAME PROJECT
    // -----------------------------------------------------------------------
    // Having both src/main.rs and src/lib.rs is a common pattern.
    // - lib.rs exposes your public API (reusable, testable)
    // - main.rs is a thin wrapper that calls into the library
    // - Integration tests and other crates can depend on the lib, not the bin
    //
    // In Cargo.toml, both are picked up automatically.
    // You can also declare multiple binaries explicitly:
    //
    // [[bin]]
    // name = "server"
    // path = "src/bin/server.rs"
    //
    // [[bin]]
    // name = "cli"
    // path = "src/bin/cli.rs"

    // -----------------------------------------------------------------------
    // MODULE FILE CONVENTIONS
    // -----------------------------------------------------------------------
    // Two equivalent styles for a module named `models`:
    //
    // Style 1 (classic):
    //   src/models/mod.rs          — module root
    //   src/models/user.rs         — submodule
    //
    // Style 2 (modern, Rust 2018+):
    //   src/models.rs              — module root (no mod.rs needed)
    //   src/models/user.rs         — submodule
    //
    // Both work. Style 2 is preferred in modern Rust.
    // full_project/ uses Style 1 (mod.rs) since it's more commonly seen in the wild.

    // -----------------------------------------------------------------------
    // DECLARING MODULES
    // -----------------------------------------------------------------------
    // mod models;                  — tells Rust to look for src/models.rs or src/models/mod.rs
    // mod models { ... }           — inline module (everything in the same file)
    //
    // use crate::models::User;     — absolute path from crate root
    // use super::models::User;     — relative path, one level up
    // use self::models::User;      — relative path, current module

    // -----------------------------------------------------------------------
    // WORKSPACES (multiple related crates)
    // -----------------------------------------------------------------------
    // my_workspace/
    // ├── Cargo.toml               — workspace manifest
    // │     [workspace]
    // │     members = ["api", "core", "cli"]
    // ├── api/
    // │   ├── Cargo.toml           — [dependencies] core = { path = "../core" }
    // │   └── src/main.rs
    // ├── core/
    // │   ├── Cargo.toml
    // │   └── src/lib.rs
    // └── cli/
    //     ├── Cargo.toml
    //     └── src/main.rs
    //
    // cargo build                  — builds all members
    // cargo test -p core           — test only the core crate
    // cargo run -p api             — run the api binary
    // Shared Cargo.lock across all members — consistent dependency versions

    // -----------------------------------------------------------------------
    // INTEGRATION TESTS (tests/)
    // -----------------------------------------------------------------------
    // Files in tests/ are separate crates that link against your library.
    // They can only access public API (no #[cfg(test)] needed — always compiled for tests).
    //
    // tests/integration_test.rs:
    //   use my_project::some_public_fn;
    //   #[test]
    //   fn it_works() { assert_eq!(some_public_fn(), 42); }
    //
    // cargo test                   — runs unit tests + integration tests
    // cargo test --lib             — unit tests only
    // cargo test --test integration_test  — specific integration test file

    // -----------------------------------------------------------------------
    // USEFUL CARGO COMMANDS FOR PROJECTS
    // -----------------------------------------------------------------------
    // cargo tree                   — show dependency tree
    // cargo audit                  — check for security vulnerabilities
    // cargo outdated               — show outdated dependencies
    // cargo expand                 — show macro-expanded code
    // cargo doc --open             — generate and open documentation
    // cargo publish                — publish to crates.io

    println!("See full_project/ for a hands-on example.");
    println!("Try: cd full_project && cargo test");
}
