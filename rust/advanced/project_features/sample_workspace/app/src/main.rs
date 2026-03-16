//! # app
//!
//! Demo binary that uses the `utils` workspace member.

use utils::{factorial, is_prime, random_between, square};

fn main() {
    // Using utils functions
    println!("{}", square(7)); // 49
    println!("{}", factorial(8)); // 40320

    // Primes up to 30
    let primes: Vec<u64> = (2..=30).filter(|&n| is_prime(n)).collect();
    println!("{:?}", primes); // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

    // Random number from utils (uses shared rand workspace dep)
    let roll = random_between(1, 6);
    println!("Dice roll: {} (1-6)", roll);

    // Profile detection
    println!(
        "Profile: {}",
        if cfg!(debug_assertions) {
            "dev"
        } else {
            "release"
        }
    );
}

#[cfg(test)]
mod tests {
    use utils::{factorial, is_prime, square};

    #[test]
    fn test_square_via_utils() {
        assert_eq!(square(5), 25);
    }

    #[test]
    fn test_factorial_via_utils() {
        assert_eq!(factorial(4), 24);
    }

    #[test]
    fn test_primes_via_utils() {
        assert!(is_prime(13));
        assert!(!is_prime(15));
    }
}
