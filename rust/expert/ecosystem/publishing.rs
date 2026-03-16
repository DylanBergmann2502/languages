// Publishing crates to crates.io

fn main() {
    // -----------------------------------------------------------------------
    // PREPARING A CRATE FOR PUBLISHING
    // -----------------------------------------------------------------------
    // Cargo.toml required fields:
    //
    // [package]
    // name = "my_crate"          — unique on crates.io
    // version = "0.1.0"          — semver: MAJOR.MINOR.PATCH
    // edition = "2021"
    // description = "A short description"
    // license = "MIT OR Apache-2.0"  — SPDX identifier (dual license is common in Rust)
    // repository = "https://github.com/you/my_crate"
    // readme = "README.md"
    // keywords = ["parsing", "json"]       — max 5, helps discoverability
    // categories = ["parser-implementations"]  — from allowed list on crates.io
    //
    // [dependencies]
    // serde = { version = "1", optional = true }  — optional deps for features
    //
    // [features]
    // default = []
    // serde = ["dep:serde"]       — feature enables optional dep

    println!("Cargo.toml fields for publishing");

    // -----------------------------------------------------------------------
    // VERSIONING (semver)
    // -----------------------------------------------------------------------
    // 0.x.y — pre-1.0: breaking changes in MINOR are allowed
    // 1.x.y — stable: MAJOR bumps for breaking changes, MINOR for new features
    //
    // cargo add my_crate          — adds "^1.2.3" (compatible version)
    // "^1.2.3"  = >=1.2.3, <2.0.0
    // "~1.2.3"  = >=1.2.3, <1.3.0
    // "=1.2.3"  = exactly 1.2.3
    // "*"       = any version (avoid)
    //
    // cargo semver-checks — detect API-breaking changes before publishing

    println!("semver: MAJOR.MINOR.PATCH");

    // -----------------------------------------------------------------------
    // DOCUMENTATION
    // -----------------------------------------------------------------------
    // Doc comments use /// (triple slash) and support Markdown
    // cargo doc --open     — generate and open HTML docs
    // docs.rs              — auto-generates docs for every crates.io publish
    //
    // //! at the top of lib.rs documents the crate itself
    //
    // /// Adds two numbers.
    // ///
    // /// # Examples
    // /// ```
    // /// assert_eq!(my_crate::add(2, 3), 5);
    // /// ```
    // pub fn add(a: i32, b: i32) -> i32 { a + b }
    //
    // cargo test --doc     — runs code examples in doc comments as tests!

    println!("/// doc comments become HTML + runnable doctests");

    // -----------------------------------------------------------------------
    // PUBLISHING WORKFLOW
    // -----------------------------------------------------------------------
    // 1. cargo login                      — authenticate with crates.io token
    // 2. cargo publish --dry-run          — check everything looks right
    // 3. cargo publish                    — publish (irreversible!)
    //
    // cargo yank --version 0.1.0          — prevent new projects from using this version
    //                                       (existing lockfiles still work)
    // cargo yank --version 0.1.0 --undo   — un-yank
    //
    // Note: you cannot delete or overwrite a published version
    // Note: crate names are globally unique across all of crates.io

    println!("cargo publish --dry-run first, then cargo publish");

    // -----------------------------------------------------------------------
    // WORKSPACE PUBLISHING
    // -----------------------------------------------------------------------
    // cargo publish -p my_crate           — publish specific member
    // cargo workspaces publish            — publish all changed members (cargo-workspaces)
    //
    // Members can depend on each other:
    // [dependencies]
    // my_core = { version = "0.1", path = "../core" }
    // When publishing, path deps must also be published and version must match

    println!("workspace: cargo publish -p specific_member");

    // -----------------------------------------------------------------------
    // PRIVATE REGISTRIES
    // -----------------------------------------------------------------------
    // For internal crates, use a private registry (Artifactory, Cloudsmith, Gitea)
    // Or use git dependencies:
    // my_lib = { git = "https://github.com/you/private_repo", tag = "v0.1.0" }
    //
    // .cargo/config.toml:
    // [registries]
    // my-registry = { index = "https://my-registry.example.com/index" }

    println!("private registries supported via .cargo/config.toml");
}
