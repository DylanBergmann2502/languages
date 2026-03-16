// Visibility modifiers in Rust
//
// (default)    — private: only accessible within the current module
// pub          — public: accessible from anywhere
// pub(crate)   — accessible anywhere within this crate, not outside
// pub(super)   — accessible in the parent module only
// pub(self)    — same as private (explicit, rarely used)
// pub(in path) — accessible within a specific ancestor module path

mod outer {
    pub(super) fn super_only() -> &'static str {
        "accessible to parent only"
    }

    pub(crate) fn crate_wide() -> &'static str {
        "accessible anywhere in this crate"
    }

    pub fn public_fn() -> &'static str {
        "accessible everywhere"
    }

    fn private_fn() -> &'static str {
        "accessible only within outer"
    }

    // Can call private_fn from within the same module
    pub fn call_private() -> &'static str {
        private_fn()
    }

    pub mod inner {
        // pub(super) here means accessible to `outer`, not beyond
        #[allow(dead_code)]
        pub(super) fn inner_super() -> &'static str {
            "inner: accessible to outer only"
        }

        pub(crate) fn inner_crate() -> &'static str {
            "inner: accessible anywhere in crate"
        }

        pub fn inner_public() -> &'static str {
            "inner: accessible everywhere"
        }

        // Can call outer's pub(crate) from inner (same crate)
        pub fn call_outer_crate() -> &'static str {
            super::crate_wide()
        }

        pub mod deep {
            // pub(in crate::outer) — accessible within outer and its children
            #[allow(dead_code)]
            pub(in crate::outer) fn deep_outer_only() -> &'static str {
                "deep: accessible within outer subtree"
            }

            pub fn deep_public() -> &'static str {
                "deep: accessible everywhere"
            }
        }
    }
}

// --- Visibility on struct fields ---
mod data {
    #[derive(Debug)]
    pub struct User {
        pub name: String,         // public field
        pub(crate) email: String, // crate-visible field
        password: String,         // private field
    }

    impl User {
        // Constructor is the only way to set private fields from outside
        pub fn new(name: &str, email: &str, password: &str) -> User {
            User {
                name: name.to_string(),
                email: email.to_string(),
                password: password.to_string(),
            }
        }

        pub fn verify_password(&self, attempt: &str) -> bool {
            self.password == attempt
        }

        // Private method — internal use only
        fn hash_password(pw: &str) -> String {
            format!("hashed:{}", pw) // simplified
        }

        pub fn change_password(&mut self, new_pw: &str) {
            self.password = Self::hash_password(new_pw);
        }
    }

    // Enum variants follow the enum's visibility
    #[derive(Debug)]
    #[allow(dead_code)]
    pub enum Role {
        Admin,
        Editor,
        Viewer,
    }

    // Struct with all-private fields — only constructable via methods
    pub struct Config {
        host: String,
        port: u16,
    }

    impl Config {
        pub fn new(host: &str, port: u16) -> Config {
            Config {
                host: host.to_string(),
                port,
            }
        }

        pub fn address(&self) -> String {
            format!("{}:{}", self.host, self.port)
        }
    }
}

fn main() {
    // --- Module visibility ---
    println!("{}", outer::public_fn()); // accessible everywhere
    println!("{}", outer::call_private()); // accessible only within outer
    println!("{}", outer::crate_wide()); // accessible anywhere in this crate
    println!("{}", outer::super_only()); // accessible to parent only (main is parent of outer)

    println!("{}", outer::inner::inner_public()); // accessible everywhere
    println!("{}", outer::inner::inner_crate()); // accessible anywhere in crate
    println!("{}", outer::inner::call_outer_crate()); // inner: accessible anywhere in crate

    // outer::inner::inner_super() — NOT accessible here (only accessible to outer)
    // outer::inner::deep::deep_outer_only() — NOT accessible here (only within outer subtree)
    println!("{}", outer::inner::deep::deep_public()); // accessible everywhere

    // --- Struct field visibility ---
    let mut user = data::User::new("Alice", "alice@example.com", "secret123");

    println!("{}", user.name); // Alice  (pub field)
    println!("{}", user.email); // alice@example.com  (pub(crate) — same crate)
    // println!("{}", user.password);              // error: private field

    println!("{}", user.verify_password("secret123")); // true
    println!("{}", user.verify_password("wrong")); // false

    user.change_password("newpass");
    println!("{}", user.verify_password("newpass")); // true
    println!("{:?}", user); // User { name: "Alice", email: "...", password: "hashed:newpass" }

    // Enum variants are public when enum is public
    let role = data::Role::Admin;
    println!("{:?}", role); // Admin

    // Config: fields are private, only accessible via methods
    let cfg = data::Config::new("localhost", 8080);
    println!("{}", cfg.address()); // localhost:8080
    // println!("{}", cfg.host);                   // error: private field

    // --- Summary ---
    // pub          → everywhere
    // pub(crate)   → same crate only
    // pub(super)   → parent module only
    // pub(in path) → specific ancestor module
    // (default)    → current module only
    println!("visibility controls enforced at compile time"); // visibility controls enforced at compile time
}
