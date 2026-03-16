#[derive(Debug, PartialEq)]
pub enum ValidationError {
    Empty,
    TooShort(usize),
    InvalidFormat(String),
}

impl std::fmt::Display for ValidationError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            ValidationError::Empty => write!(f, "value cannot be empty"),
            ValidationError::TooShort(n) => write!(f, "must be at least {} characters", n),
            ValidationError::InvalidFormat(msg) => write!(f, "invalid format: {}", msg),
        }
    }
}

pub fn validate_email(email: &str) -> Result<(), ValidationError> {
    if email.is_empty() {
        return Err(ValidationError::Empty);
    }
    if email.len() < 5 {
        return Err(ValidationError::TooShort(5));
    }
    if !email.contains('@') {
        return Err(ValidationError::InvalidFormat(
            "missing @ symbol".to_string(),
        ));
    }
    if !email.contains('.') {
        return Err(ValidationError::InvalidFormat("missing domain".to_string()));
    }
    Ok(())
}

pub fn validate_username(name: &str) -> Result<(), ValidationError> {
    if name.is_empty() {
        return Err(ValidationError::Empty);
    }
    if name.len() < 3 {
        return Err(ValidationError::TooShort(3));
    }
    if !name.chars().all(|c| c.is_alphanumeric() || c == '_') {
        return Err(ValidationError::InvalidFormat(
            "only letters, numbers, and underscores allowed".to_string(),
        ));
    }
    Ok(())
}

// ============================================================
// UNIT TESTS — testing error paths and Result types
// ============================================================
// A good test suite covers: happy path, error cases, edge cases

#[cfg(test)]
mod tests {
    use super::*;

    // --- validate_email ---

    #[test]
    fn test_valid_email() {
        assert!(validate_email("alice@example.com").is_ok());
        assert!(validate_email("a@b.co").is_ok());
    }

    #[test]
    fn test_email_empty() {
        assert_eq!(validate_email(""), Err(ValidationError::Empty));
    }

    #[test]
    fn test_email_too_short() {
        assert_eq!(validate_email("a@b"), Err(ValidationError::TooShort(5)));
    }

    #[test]
    fn test_email_missing_at() {
        assert_eq!(
            validate_email("notanemail.com"),
            Err(ValidationError::InvalidFormat(
                "missing @ symbol".to_string()
            ))
        );
    }

    #[test]
    fn test_email_missing_domain() {
        assert_eq!(
            validate_email("user@nodomain"),
            Err(ValidationError::InvalidFormat("missing domain".to_string()))
        );
    }

    // --- validate_username ---

    #[test]
    fn test_valid_username() {
        assert!(validate_username("alice").is_ok());
        assert!(validate_username("user_123").is_ok());
    }

    #[test]
    fn test_username_empty() {
        assert_eq!(validate_username(""), Err(ValidationError::Empty));
    }

    #[test]
    fn test_username_too_short() {
        assert_eq!(validate_username("ab"), Err(ValidationError::TooShort(3)));
    }

    #[test]
    fn test_username_invalid_chars() {
        let result = validate_username("bad name!");
        assert!(matches!(result, Err(ValidationError::InvalidFormat(_))));
    }

    // --- testing Display on errors ---

    #[test]
    fn test_error_display() {
        assert_eq!(ValidationError::Empty.to_string(), "value cannot be empty");
        assert_eq!(
            ValidationError::TooShort(3).to_string(),
            "must be at least 3 characters"
        );
    }
}
