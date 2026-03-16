use std::cell::RefCell;
use std::rc::Rc;

// RefCell<T>: interior mutability — mutate data even through an immutable reference
// Enforces borrow rules at RUNTIME (not compile time) — panics if rules are violated
// Single-threaded only (use Mutex<T> for threads)
//
// Borrow rules at runtime:
//   - Multiple immutable borrows: OK
//   - One mutable borrow at a time: OK
//   - Mixing mutable + immutable: PANIC

fn main() {
    // Basic RefCell usage
    let data = RefCell::new(vec![1, 2, 3]);

    // borrow() — immutable reference (like &T)
    println!("{:?}", data.borrow()); // [1, 2, 3]

    // borrow_mut() — mutable reference (like &mut T)
    data.borrow_mut().push(4);
    println!("{:?}", data.borrow()); // [1, 2, 3, 4]

    // Multiple immutable borrows are fine
    let b1 = data.borrow();
    let b2 = data.borrow();
    println!("{:?} {:?}", b1, b2); // [1, 2, 3, 4] [1, 2, 3, 4]
    drop(b1);
    drop(b2);

    // Mutable borrow after releases are fine
    data.borrow_mut().push(5);
    println!("{:?}", data.borrow()); // [1, 2, 3, 4, 5]

    // Demonstrating runtime panic (commented out — would crash):
    // let _b = data.borrow();
    // let _bm = data.borrow_mut(); // PANIC: already borrowed immutably

    // try_borrow / try_borrow_mut — non-panicking versions
    let try1 = data.try_borrow();
    let try2 = data.try_borrow_mut(); // fails: already immutably borrowed
    println!("{}", try1.is_ok()); // true
    println!("{}", try2.is_err()); // true
    drop(try1);

    // RefCell in a struct — allows mutation through &self (not &mut self)
    struct MockLogger {
        log: RefCell<Vec<String>>,
    }

    impl MockLogger {
        fn new() -> Self {
            MockLogger {
                log: RefCell::new(vec![]),
            }
        }

        fn log(&self, msg: &str) {
            // &self, not &mut self!
            self.log.borrow_mut().push(msg.to_string());
        }

        fn messages(&self) -> Vec<String> {
            self.log.borrow().clone()
        }
    }

    let logger = MockLogger::new();
    logger.log("started");
    logger.log("processing");
    logger.log("done");
    println!("{:?}", logger.messages()); // ["started", "processing", "done"]

    // Rc<RefCell<T>>: shared ownership + mutability
    // This is the common pattern when you need both
    let shared = Rc::new(RefCell::new(0));

    let clone1 = Rc::clone(&shared);
    let clone2 = Rc::clone(&shared);

    *clone1.borrow_mut() += 10;
    *clone2.borrow_mut() += 20;
    println!("{}", shared.borrow()); // 30

    // Shared mutable list — multiple owners can all mutate it
    let list = Rc::new(RefCell::new(vec!["a", "b", "c"]));

    let reader = Rc::clone(&list);
    let writer = Rc::clone(&list);

    writer.borrow_mut().push("d");
    println!("{:?}", reader.borrow()); // ["a", "b", "c", "d"]
    println!("{}", Rc::strong_count(&list)); // 3

    // Cell<T>: simpler interior mutability for Copy types (no borrow overhead)
    use std::cell::Cell;

    let cell = Cell::new(42);
    println!("{}", cell.get()); // 42
    cell.set(100);
    println!("{}", cell.get()); // 100

    // Cell doesn't require borrow() — just get/set for Copy types
    struct Counter {
        count: Cell<u32>,
    }

    impl Counter {
        fn new() -> Self {
            Counter {
                count: Cell::new(0),
            }
        }
        fn increment(&self) {
            self.count.set(self.count.get() + 1);
        }
        fn value(&self) -> u32 {
            self.count.get()
        }
    }

    let c = Counter::new();
    c.increment();
    c.increment();
    c.increment();
    println!("{}", c.value()); // 3
}
