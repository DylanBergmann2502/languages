#[derive(Debug, Clone, PartialEq)]
pub struct Product {
    pub id: u32,
    pub name: String,
    pub price: f64,
    stock: u32,
}

impl Product {
    pub fn new(id: u32, name: &str, price: f64, stock: u32) -> Product {
        Product {
            id,
            name: name.to_string(),
            price,
            stock,
        }
    }

    pub fn in_stock(&self) -> bool {
        self.stock > 0
    }

    pub fn stock_count(&self) -> u32 {
        self.stock
    }

    pub fn purchase(&mut self, qty: u32) -> Result<f64, String> {
        if qty > self.stock {
            return Err(format!("only {} in stock", self.stock));
        }
        self.stock -= qty;
        Ok(self.price * qty as f64)
    }

    pub fn restock(&mut self, qty: u32) {
        self.stock += qty;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_in_stock() {
        let p = Product::new(1, "Widget", 9.99, 10);
        assert!(p.in_stock());
    }

    #[test]
    fn test_out_of_stock() {
        let p = Product::new(1, "Widget", 9.99, 0);
        assert!(!p.in_stock());
    }

    #[test]
    fn test_purchase_success() {
        let mut p = Product::new(1, "Widget", 10.0, 5);
        let total = p.purchase(3).unwrap();
        assert_eq!(total, 30.0);
        assert_eq!(p.stock_count(), 2);
    }

    #[test]
    fn test_purchase_insufficient_stock() {
        let mut p = Product::new(1, "Widget", 10.0, 2);
        let result = p.purchase(5);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "only 2 in stock");
    }

    #[test]
    fn test_restock() {
        let mut p = Product::new(1, "Widget", 10.0, 0);
        p.restock(20);
        assert_eq!(p.stock_count(), 20);
        assert!(p.in_stock());
    }

    // assert_ne! — assert not equal
    #[test]
    fn test_price_not_zero() {
        let p = Product::new(1, "Widget", 9.99, 1);
        assert_ne!(p.price, 0.0);
    }
}
