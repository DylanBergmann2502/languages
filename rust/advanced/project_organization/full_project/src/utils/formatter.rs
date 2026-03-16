pub fn format_price(price: f64) -> String {
    format!("${:.2}", price)
}

pub fn format_user_list(names: &[&str]) -> String {
    match names.len() {
        0 => String::from("(none)"),
        1 => names[0].to_string(),
        2 => format!("{} and {}", names[0], names[1]),
        _ => {
            let most = names[..names.len() - 1].join(", ");
            format!("{}, and {}", most, names[names.len() - 1])
        }
    }
}

pub fn truncate(s: &str, max_len: usize) -> String {
    if s.len() <= max_len {
        s.to_string()
    } else {
        format!("{}...", &s[..max_len])
    }
}

// ============================================================
// UNIT TESTS — testing pure functions
// ============================================================
// Pure functions (no side effects) are the easiest to test:
// given input X, always returns Y.

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_format_price() {
        assert_eq!(format_price(9.99), "$9.99");
        assert_eq!(format_price(100.0), "$100.00");
        assert_eq!(format_price(0.1 + 0.2), "$0.30"); // float formatting rounds correctly
    }

    #[test]
    fn test_format_user_list_empty() {
        assert_eq!(format_user_list(&[]), "(none)");
    }

    #[test]
    fn test_format_user_list_one() {
        assert_eq!(format_user_list(&["Alice"]), "Alice");
    }

    #[test]
    fn test_format_user_list_two() {
        assert_eq!(format_user_list(&["Alice", "Bob"]), "Alice and Bob");
    }

    #[test]
    fn test_format_user_list_many() {
        assert_eq!(
            format_user_list(&["Alice", "Bob", "Carol"]),
            "Alice, Bob, and Carol"
        );
    }

    // Grouping related tests — subtests via naming convention: test_<fn>_<scenario>
    #[test]
    fn test_truncate_short_string() {
        assert_eq!(truncate("hello", 10), "hello");
    }

    #[test]
    fn test_truncate_exact_length() {
        assert_eq!(truncate("hello", 5), "hello");
    }

    #[test]
    fn test_truncate_long_string() {
        assert_eq!(truncate("hello world", 5), "hello...");
    }
}
