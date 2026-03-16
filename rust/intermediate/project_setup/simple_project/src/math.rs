// src/math.rs — another module in its own file

pub fn square(x: i32) -> i32 {
    x * x
}

pub fn factorial(n: u64) -> u64 {
    (1..=n).product()
}

pub fn circle_area(radius: f64) -> f64 {
    std::f64::consts::PI * radius * radius
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_square() {
        assert_eq!(square(4), 16);
        assert_eq!(square(0), 0);
        assert_eq!(square(-3), 9);
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(1), 1);
        assert_eq!(factorial(5), 120);
        assert_eq!(factorial(6), 720);
    }

    #[test]
    fn test_circle_area() {
        let area = circle_area(1.0);
        assert!((area - std::f64::consts::PI).abs() < 1e-10);
    }
}
