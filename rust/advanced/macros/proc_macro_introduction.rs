// Procedural macros: macros that operate on Rust's token stream programmatically
// Unlike macro_rules! (pattern matching on syntax), proc macros are Rust functions
// that receive a TokenStream and return a TokenStream.
//
// Three kinds:
//   1. Custom derive:   #[derive(MyTrait)]
//   2. Attribute macro: #[my_attribute]
//   3. Function-like:   my_macro!(...)
//
// IMPORTANT: proc macros must live in their own crate with crate-type = "proc-macro"
// They cannot be defined and used in the same file/crate.
// This lesson demonstrates their USAGE and the concepts behind them.
// Writing your own proc macro requires a separate Cargo project (see proc_macro crate).

// --- Derive macros you already use ---
// These are all proc macros provided by the standard library or popular crates:

#[derive(Debug, Clone, PartialEq)] // proc macros generating trait impls
struct Point {
    x: f64,
    y: f64,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
struct UserId(u64);

#[derive(Debug, Clone)]
#[allow(dead_code)]
enum Direction {
    North,
    South,
    East,
    West,
}

// --- What derive macros generate (conceptually) ---
// #[derive(Debug)] expands to something like:
//
// impl std::fmt::Debug for Point {
//     fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
//         f.debug_struct("Point")
//             .field("x", &self.x)
//             .field("y", &self.y)
//             .finish()
//     }
// }
//
// The proc macro receives the struct tokens and generates this impl automatically.

// --- serde: the most popular proc macro crate ---
// Serde uses proc macros to auto-generate serialization/deserialization code:
//
// #[derive(Serialize, Deserialize)]
// struct Config {
//     host: String,
//     port: u16,
//     debug: bool,
// }
//
// This generates impl Serialize for Config and impl Deserialize for Config
// at compile time — no runtime reflection needed (unlike Python/Java).

// --- How a custom derive proc macro works (conceptually) ---
//
// In a separate proc-macro crate (Cargo.toml: crate-type = ["proc-macro"]):
//
// use proc_macro::TokenStream;
// use quote::quote;
// use syn::parse_macro_input;
//
// #[proc_macro_derive(MyDisplay)]
// pub fn my_display_derive(input: TokenStream) -> TokenStream {
//     let ast = parse_macro_input!(input as syn::DeriveInput);
//     let name = &ast.ident;
//
//     let expanded = quote! {
//         impl std::fmt::Display for #name {
//             fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
//                 write!(f, stringify!(#name))
//             }
//         }
//     };
//     expanded.into()
// }
//
// Key crates:
//   proc-macro2 — token stream manipulation
//   syn         — parse Rust code into an AST
//   quote       — generate Rust code from templates

// --- Attribute macros (conceptually) ---
//
// #[route(GET, "/hello")]         // custom attribute
// fn hello_handler() -> &'static str { "Hello!" }
//
// The macro receives both the attribute args and the function,
// can inspect/transform/wrap them, and emits new code.
//
// Common uses: web framework routing, test helpers, async wrappers

// --- Function-like proc macros (conceptually) ---
//
// let sql = sql!(SELECT * FROM users WHERE id = 1);
//           ^-- validated at compile time!
//
// Unlike macro_rules!, proc macros can do arbitrary computation:
// parse SQL, validate it, generate typed structs for the result, etc.

// --- Standard library derive traits available today ---
// Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord,
// Hash, Default, From, Into (via thiserror/anyhow)

#[derive(Debug, Default, Clone, PartialEq)]
struct Config {
    host: String,
    port: u16,
    debug: bool,
    max_connections: usize,
}

fn main() {
    // Debug derive
    let p = Point { x: 3.0, y: 4.0 };
    println!("{:?}", p); // Point { x: 3.0, y: 4.0 }
    println!("{:#?}", p); // pretty-printed

    // Clone derive
    let p2 = p.clone();
    println!("{:?}", p2); // Point { x: 3.0, y: 4.0 }

    // PartialEq derive
    println!("{}", p == p2); // true
    println!("{}", p == Point { x: 0.0, y: 0.0 }); // false

    // Hash + Eq derive — allows use as HashMap key
    use std::collections::HashMap;
    let mut map: HashMap<UserId, String> = HashMap::new();
    map.insert(UserId(1), String::from("Alice"));
    map.insert(UserId(2), String::from("Bob"));
    println!("{:?}", map.get(&UserId(1))); // Some("Alice")
    println!("{:?}", map.get(&UserId(99))); // None

    // Default derive — generates a zero/empty value
    let cfg = Config::default();
    println!("{:?}", cfg); // Config { host: "", port: 0, debug: false, max_connections: 0 }

    let custom = Config {
        host: String::from("localhost"),
        port: 8080,
        debug: true,
        ..Config::default() // fill rest with defaults
    };
    println!("{:?}", custom); // Config { host: "localhost", port: 8080, debug: true, max_connections: 0 }

    // Clone + PartialEq
    let cfg2 = custom.clone();
    println!("{}", custom == cfg2); // true

    let dir = Direction::North;
    println!("{:?}", dir); // North

    // Summary: proc macros run at compile time, generate code, zero runtime cost.
    // You use them every day via #[derive(...)].
    // Writing them requires: separate proc-macro crate + syn + quote crates.
    println!("proc macros: compile-time code generation, zero runtime cost"); // proc macros: compile-time code generation, zero runtime cost
}
