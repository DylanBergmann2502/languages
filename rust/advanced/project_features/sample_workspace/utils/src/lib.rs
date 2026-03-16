//! # utils
//!
//! Shared utility functions used across the workspace.

use rand::RngExt;

/// Returns the square of a number.
///
/// # Examples
///
/// ```
/// assert_eq!(utils::square(4), 16);
/// ```
pub fn square(x: i32) -> i32 {
    x * x
}

/// Returns the factorial of n.
///
/// # Examples
///
/// ```
/// assert_eq!(utils::factorial(5), 120);
/// ```
pub fn factorial(n: u64) -> u64 {
    (1..=n).product()
}

/// Generates a random number between `low` and `high` (inclusive).
pub fn random_between(low: u32, high: u32) -> u32 {
    rand::rng().random_range(low..=high)
}

/// Checks if a number is prime.
///
/// # Examples
///
/// ```
/// assert!(utils::is_prime(7));
/// assert!(!utils::is_prime(9));
/// ```
pub fn is_prime(n: u64) -> bool {
    if n < 2 {
        return false;
    }
    for i in 2..=(n as f64).sqrt() as u64 {
        if n.is_multiple_of(i) {
            return false;
        }
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_square() {
        assert_eq!(square(3), 9);
        assert_eq!(square(0), 0);
        assert_eq!(square(-4), 16);
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(1), 1);
        assert_eq!(factorial(6), 720);
    }

    #[test]
    fn test_is_prime() {
        assert!(!is_prime(0));
        assert!(!is_prime(1));
        assert!(is_prime(2));
        assert!(is_prime(7));
        assert!(!is_prime(9));
        assert!(is_prime(97));
    }
}
