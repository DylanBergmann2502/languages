// lib.rs — the library root
// Exposes the public API of this crate.
// main.rs calls into this; integration tests (tests/) also use this.

pub mod models;
pub mod utils;

// Re-export commonly used types at the crate root for convenience
pub use models::{Product, User};
pub use utils::{format_price, validate_email};
