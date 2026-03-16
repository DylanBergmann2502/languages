// advanced_cargo.rs — Profiles, features, and workspaces
// Reference lesson — hands-on companion is sample_workspace/
// Run: rust-script advanced_cargo.rs

fn main() {
    // -----------------------------------------------------------------------
    // BUILD PROFILES
    // -----------------------------------------------------------------------
    // Profiles control how rustc compiles your code.
    // Two built-in profiles: dev (cargo build) and release (cargo build --release)
    //
    // Customize in Cargo.toml:
    //
    // [profile.dev]
    // opt-level = 0        # no optimization — fast compile, slow runtime
    // debug = true         # include debug symbols
    // overflow-checks = true
    //
    // [profile.release]
    // opt-level = 3        # full optimization — slow compile, fast runtime
    // debug = false
    // lto = true           # link-time optimization (even faster, slower to compile)
    // codegen-units = 1    # single codegen unit — better optimization, slower compile
    // panic = "abort"      # smaller binary, no unwinding
    //
    // Custom profiles — inherit from existing ones:
    //
    // [profile.bench-dev]
    // inherits = "dev"
    // opt-level = 2
    //
    // opt-level values:
    //   0 = no optimization
    //   1 = basic
    //   2 = some
    //   3 = all (default for release)
    //   "s" = optimize for size
    //   "z" = optimize for size aggressively

    // -----------------------------------------------------------------------
    // FEATURES
    // -----------------------------------------------------------------------
    // Features are optional functionality that can be toggled at compile time.
    // Like compile-time flags — zero cost if disabled (code is excluded entirely).
    //
    // Define features in Cargo.toml:
    //
    // [features]
    // default = ["std"]          # enabled by default
    // std = []                   # feature with no dependencies
    // async = ["tokio"]          # feature that pulls in a dependency
    // full = ["async", "std"]    # feature that enables other features
    //
    // [dependencies]
    // tokio = { version = "1", optional = true }   # only included if async feature is on
    //
    // Use features in code with cfg:
    //
    // #[cfg(feature = "async")]
    // pub mod async_support {
    //     pub async fn fetch() { ... }
    // }
    //
    // #[cfg(not(feature = "std"))]
    // pub fn fallback() { ... }
    //
    // CLI:
    // cargo build --features async
    // cargo build --features "async,full"
    // cargo build --no-default-features
    // cargo build --no-default-features --features async
    // cargo add tokio --features full  (enables tokio's "full" feature)

    // -----------------------------------------------------------------------
    // WORKSPACES
    // -----------------------------------------------------------------------
    // A workspace is a set of packages (crates) that share:
    //   - A single Cargo.lock
    //   - A single target/ directory
    //   - Common dependency versions
    //
    // Root Cargo.toml (no [package], only [workspace]):
    //
    // [workspace]
    // members = ["app", "utils", "models"]
    // resolver = "2"             # use the v2 feature resolver (recommended)
    //
    // [workspace.dependencies]  # shared dependency versions across all members
    // serde = { version = "1", features = ["derive"] }
    // tokio = { version = "1", features = ["full"] }
    //
    // Member Cargo.toml can inherit workspace deps:
    //
    // [dependencies]
    // serde = { workspace = true }   # uses version from [workspace.dependencies]
    //
    // Commands run from workspace root apply to all members:
    // cargo build           — builds all members
    // cargo test            — tests all members
    // cargo build -p utils  — builds only the `utils` package
    // cargo test -p app     — tests only `app`
    // cargo run -p app      — runs the `app` binary
    //
    // See sample_workspace/ for a working example.

    // -----------------------------------------------------------------------
    // DEPENDENCY SOURCES
    // -----------------------------------------------------------------------
    // [dependencies]
    // # From crates.io (default)
    // serde = "1.0"
    //
    // # Specific version with features
    // tokio = { version = "1", features = ["full"] }
    //
    // # Local path (great for workspace members or local libs)
    // utils = { path = "../utils" }
    //
    // # Git repo
    // my_crate = { git = "https://github.com/user/repo" }
    // my_crate = { git = "https://github.com/user/repo", branch = "main" }
    // my_crate = { git = "https://github.com/user/repo", tag = "v1.0" }
    // my_crate = { git = "https://github.com/user/repo", rev = "abc1234" }
    //
    // # Dev/build only
    // [dev-dependencies]
    // criterion = "0.5"
    //
    // [build-dependencies]
    // cc = "1.0"

    // -----------------------------------------------------------------------
    // CARGO SCRIPTS & USEFUL COMMANDS
    // -----------------------------------------------------------------------
    // cargo tree                    — print dependency tree
    // cargo tree --duplicates       — find duplicate versions
    // cargo audit                   — check for security vulnerabilities
    // cargo outdated                — list outdated dependencies
    // cargo expand                  — show macro-expanded code
    // cargo bench                   — run benchmarks (see sample_workspace/)
    // cargo build --timings         — show compile time breakdown
    // RUSTFLAGS="-C target-cpu=native" cargo build --release  — native CPU opts

    println!("See sample_workspace/ for hands-on profiles, features, and workspaces.");
    println!("Try: cd sample_workspace && cargo build && cargo test && cargo bench");

    // Runtime feature detection (cfg! macro)
    if cfg!(debug_assertions) {
        println!("Running in: debug"); // debug
    } else {
        println!("Running in: release");
    }
}
