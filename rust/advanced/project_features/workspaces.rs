// workspaces.rs — Managing multi-package projects
// Explains workspace concepts. Hands-on companion: sample_workspace/
// Run: rust-script workspaces.rs

fn main() {
    // -----------------------------------------------------------------------
    // WHAT IS A WORKSPACE?
    // -----------------------------------------------------------------------
    // A workspace groups multiple related crates (packages) under one root.
    // All members share: one Cargo.lock, one target/, and consistent dep versions.
    //
    // When to use a workspace:
    //   - A binary app + supporting libraries (app, utils, models)
    //   - A framework split across crates (core, derive, macros)
    //   - A monorepo with multiple services that share code
    //
    // Without workspace: each crate has its own target/, Cargo.lock, and
    //                    may compile different versions of shared deps.
    // With workspace:    one target/ (faster builds), one lock (consistent deps).

    // -----------------------------------------------------------------------
    // STRUCTURE
    // -----------------------------------------------------------------------
    // sample_workspace/
    // ├── Cargo.toml          ← workspace root (no [package])
    // ├── Cargo.lock          ← single lock for ALL members
    // ├── target/             ← single build output for ALL members
    // ├── app/                ← binary crate
    // │   ├── Cargo.toml
    // │   └── src/main.rs
    // └── utils/              ← library crate used by app
    //     ├── Cargo.toml
    //     └── src/lib.rs

    // -----------------------------------------------------------------------
    // ROOT Cargo.toml
    // -----------------------------------------------------------------------
    // [workspace]
    // members = ["app", "utils"]
    // resolver = "2"
    //
    // # Shared dependency versions — members reference these with workspace = true
    // [workspace.dependencies]
    // serde = { version = "1", features = ["derive"] }
    // rand = "0.10"
    //
    // No [package] section in the root — it's purely a workspace manifest.

    // -----------------------------------------------------------------------
    // MEMBER Cargo.toml (e.g. utils/Cargo.toml)
    // -----------------------------------------------------------------------
    // [package]
    // name = "utils"
    // version = "0.1.0"
    // edition = "2024"
    //
    // [dependencies]
    // serde = { workspace = true }   # inherits version from workspace root
    //
    // Members can also depend on each other:
    // [dependencies]
    // utils = { path = "../utils" }  # app depending on utils

    // -----------------------------------------------------------------------
    // COMMANDS
    // -----------------------------------------------------------------------
    // From workspace root:
    //
    // cargo build              — build all members
    // cargo test               — test all members
    // cargo build -p utils     — build only utils
    // cargo test -p app        — test only app
    // cargo run -p app         — run the app binary
    // cargo add rand -p utils  — add rand to utils only
    // cargo tree               — full dependency tree for all members
    //
    // cargo new member_name --manifest-path Cargo.toml
    // (or: cargo new member_name then add to workspace members list)

    // -----------------------------------------------------------------------
    // VIRTUAL vs NON-VIRTUAL WORKSPACE
    // -----------------------------------------------------------------------
    // Virtual:     root Cargo.toml has NO [package] — purely a coordinator
    //              All code lives in member crates. (sample_workspace/ uses this)
    //
    // Non-virtual: root Cargo.toml has BOTH [package] AND [workspace]
    //              The root is itself a crate AND manages members.
    //              Less common — used when root crate is the "main" package.

    // -----------------------------------------------------------------------
    // INTER-CRATE DEPENDENCIES
    // -----------------------------------------------------------------------
    // Members reference each other via path dependencies:
    //
    // # app/Cargo.toml
    // [dependencies]
    // utils = { path = "../utils" }
    //
    // Then in app/src/main.rs:
    // use utils::some_function;
    //
    // Cargo knows they're in the same workspace — no version needed.

    println!("See sample_workspace/ for a working two-crate workspace.");
    println!("Try:");
    println!("  cd sample_workspace");
    println!("  cargo build          # builds both app and utils");
    println!("  cargo test           # tests both");
    println!("  cargo run -p app     # runs the app binary");
    println!("  cargo bench -p app   # runs benchmarks");
}
