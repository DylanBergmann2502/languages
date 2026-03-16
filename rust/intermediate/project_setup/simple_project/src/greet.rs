// src/greet.rs — a module in its own file
// Accessed in main.rs via: mod greet; use greet::hello;

pub fn hello(name: &str) -> String {
    format!("Hello, {}!", name)
}

pub fn goodbye(name: &str) -> String {
    format!("Goodbye, {}!", name)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hello() {
        assert_eq!(hello("Alice"), "Hello, Alice!");
    }

    #[test]
    fn test_goodbye() {
        assert_eq!(goodbye("Bob"), "Goodbye, Bob!");
    }
}
