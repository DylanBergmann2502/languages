// Rust toolchain: rustup, analyzer, Clippy, rustfmt, and more

fn main() {
    // -----------------------------------------------------------------------
    // RUSTUP — toolchain manager
    // -----------------------------------------------------------------------
    // rustup update                        — update all toolchains
    // rustup toolchain install nightly     — install nightly
    // rustup default nightly              — switch default
    // rustup override set nightly          — nightly for current directory only
    // rustup target add wasm32-unknown-unknown  — cross-compile to WASM
    // rustup target add thumbv7em-none-eabihf   — cross-compile to ARM embedded
    // rustup component add rust-src            — source for IDE jumps
    // rustup component add llvm-tools-preview  — for profiling/coverage

    println!("rustup: toolchain manager");

    // -----------------------------------------------------------------------
    // RUST ANALYZER — language server (IDE integration)
    // -----------------------------------------------------------------------
    // Install: rustup component add rust-analyzer
    // Works with: VSCode (rust-analyzer extension), Neovim, Emacs, IntelliJ
    //
    // Features:
    //   - Real-time error highlighting
    //   - Type inference display (hover)
    //   - Go to definition / find references
    //   - Code completion
    //   - Inline hints (parameter names, return types)
    //   - Refactoring (rename, extract function)
    //   - Run/debug tests from editor
    //
    // Settings (in VSCode settings.json or rust-analyzer config):
    // "rust-analyzer.checkOnSave.command": "clippy"  — use clippy on save
    // "rust-analyzer.inlayHints.enable": true

    println!("rust-analyzer: LSP for IDE integration");

    // -----------------------------------------------------------------------
    // CLIPPY — linter
    // -----------------------------------------------------------------------
    // rustup component add clippy
    // cargo clippy                         — run linter
    // cargo clippy -- -D warnings          — treat warnings as errors (CI)
    // cargo clippy --fix                   — auto-fix where possible
    //
    // Clippy lint categories:
    //   clippy::correctness  — likely bugs (deny by default)
    //   clippy::suspicious   — probably wrong
    //   clippy::style        — idiomatic Rust
    //   clippy::perf         — performance improvements
    //   clippy::pedantic     — strict but opinionated
    //   clippy::nursery      — experimental
    //
    // Allow/deny specific lints:
    // #[allow(clippy::too_many_arguments)]
    // #[deny(clippy::unwrap_used)]         — no .unwrap() allowed
    //
    // .cargo/config.toml or Cargo.toml:
    // [lints.clippy]
    // pedantic = "warn"
    // unwrap_used = "deny"

    // Example of what clippy catches:
    let v = vec![1, 2, 3];
    // clippy would flag: v.iter().filter(|x| **x > 1).collect::<Vec<_>>()
    // Suggestion: just use retain() or filter directly
    let big: Vec<&i32> = v.iter().filter(|&&x| x > 1).collect();
    println!("{:?}", big); // [2, 3]

    // -----------------------------------------------------------------------
    // RUSTFMT — code formatter
    // -----------------------------------------------------------------------
    // rustup component add rustfmt
    // cargo fmt                             — format all files
    // cargo fmt --check                     — check without modifying (CI)
    // rustfmt src/main.rs                   — format a single file
    //
    // Configure in rustfmt.toml or .rustfmt.toml:
    // edition = "2021"
    // max_width = 100          — line length (default 100)
    // tab_spaces = 4           — indentation
    // imports_granularity = "Crate"  — merge use statements by crate
    // group_imports = "StdExternalCrate"  — std, then external, then local

    println!("rustfmt: opinionated code formatter (no debates needed)");

    // -----------------------------------------------------------------------
    // CARGO EXTENSIONS (install with cargo install)
    // -----------------------------------------------------------------------
    // cargo install cargo-watch      — re-run on file changes: cargo watch -x run
    // cargo install cargo-expand     — show macro-expanded code
    // cargo install cargo-audit      — check for security vulnerabilities
    // cargo install cargo-outdated   — show outdated dependencies
    // cargo install cargo-tree       — dependency tree visualizer
    // cargo install cargo-flamegraph — generate flame graphs
    // cargo install cargo-udeps      — find unused dependencies
    // cargo install cargo-deny       — policy for deps (licenses, duplicates)
    // cargo install cargo-semver-checks — detect breaking API changes
    // cargo install tokei            — count lines of code
    // cargo install hyperfine        — command-line benchmarking
    // cargo install just             — task runner (like make)

    println!("cargo extensions: install with cargo install <name>");

    // -----------------------------------------------------------------------
    // RUST-SCRIPT
    // -----------------------------------------------------------------------
    // cargo install rust-script      — run .rs files like scripts
    // rust-script my_file.rs         — compile and run directly
    // Add deps in //! ```cargo ... ``` block at the top
    // Great for: learning, quick experiments, shell scripts in Rust

    println!("rust-script: run .rs files like Python scripts");

    // -----------------------------------------------------------------------
    // COVERAGE
    // -----------------------------------------------------------------------
    // cargo install cargo-tarpaulin  — code coverage (Linux)
    // cargo install cargo-llvm-cov   — LLVM-based coverage (cross-platform)
    //
    // cargo tarpaulin --out Html     — HTML coverage report
    // cargo llvm-cov --open          — open HTML report in browser

    println!("cargo-tarpaulin / cargo-llvm-cov: code coverage");

    // -----------------------------------------------------------------------
    // MIRI — interpreter for detecting UB in unsafe code
    // -----------------------------------------------------------------------
    // rustup +nightly component add miri
    // cargo +nightly miri test       — run tests under Miri
    //
    // Detects:
    //   - Use-after-free
    //   - Buffer overflows
    //   - Data races
    //   - Invalid pointer arithmetic
    //   - Misaligned accesses

    println!("miri: detect undefined behavior in unsafe code");

    println!("rust tooling done"); // rust tooling done
}
