#[derive(Debug, Clone, PartialEq)]
pub struct User {
    pub id: u32,
    pub name: String,
    pub(crate) email: String,
    active: bool,
}

impl User {
    pub fn new(id: u32, name: &str, email: &str) -> User {
        User {
            id,
            name: name.to_string(),
            email: email.to_string(),
            active: true,
        }
    }

    pub fn is_active(&self) -> bool {
        self.active
    }

    pub fn deactivate(&mut self) {
        self.active = false;
    }

    pub fn display_name(&self) -> String {
        format!("{}#{}", self.name, self.id)
    }
}

// ============================================================
// UNIT TESTS
// ============================================================
// #[cfg(test)]  — this module is only compiled when running tests
//                 not included in release builds
// Tests live alongside the code they test — easy to access private items
// Run with: cargo test
// Run specific: cargo test user
// Run with output: cargo test -- --nocapture

#[cfg(test)]
mod tests {
    use super::*; // brings User and everything above into scope

    // #[test] marks a function as a test case
    // Test passes if it returns without panicking
    // Test fails if it panics (assert!, assert_eq!, assert_ne!, panic!)
    #[test]
    fn test_new_user_is_active() {
        let user = User::new(1, "Alice", "alice@example.com");
        assert!(user.is_active());
    }

    #[test]
    fn test_deactivate() {
        let mut user = User::new(1, "Alice", "alice@example.com");
        user.deactivate();
        assert!(!user.is_active());
    }

    #[test]
    fn test_display_name() {
        let user = User::new(42, "Bob", "bob@example.com");
        assert_eq!(user.display_name(), "Bob#42");
    }

    #[test]
    fn test_clone_equality() {
        let user = User::new(1, "Carol", "carol@example.com");
        let cloned = user.clone();
        assert_eq!(user, cloned);
    }

    // #[should_panic] — test passes only if it panics
    // Useful for testing invalid input handling
    #[test]
    #[should_panic]
    fn test_intentional_panic() {
        panic!("this should panic");
    }

    // #[should_panic(expected = "...")] — checks the panic message too
    #[test]
    #[should_panic(expected = "out of bounds")]
    fn test_panic_message() {
        let v = vec![1, 2, 3];
        let _ = v[99]; // panics with "index out of bounds"
    }

    // Tests can also return Result<(), E> — use ? inside
    #[test]
    fn test_with_result() -> Result<(), String> {
        let user = User::new(1, "Dave", "dave@example.com");
        if user.name.is_empty() {
            return Err(String::from("name should not be empty"));
        }
        Ok(())
    }

    // Private items are accessible from within the same module's test block
    #[test]
    fn test_private_field_active_default() {
        let user = User::new(1, "Eve", "eve@example.com");
        assert!(user.active); // `active` is private — only testable here
    }
}
