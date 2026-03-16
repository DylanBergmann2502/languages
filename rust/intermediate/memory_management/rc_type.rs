use std::rc::Rc;

// Rc<T>: Reference Counted smart pointer
// Allows multiple owners of the same heap data (single-threaded only)
// Data is dropped when the last Rc pointing to it goes out of scope
// Rc<T> is immutable — use RefCell for interior mutability

fn main() {
    // Basic Rc — multiple ownership
    let a = Rc::new(String::from("hello"));
    println!("{}", Rc::strong_count(&a)); // 1

    let b = Rc::clone(&a); // clone the pointer, not the data
    println!("{}", Rc::strong_count(&a)); // 2

    {
        let c = Rc::clone(&a);
        println!("{}", Rc::strong_count(&a)); // 3
        println!("{}", c); // hello
    } // c dropped here

    println!("{}", Rc::strong_count(&a)); // 2
    println!("{}", a); // hello
    println!("{}", b); // hello

    // Both a and b point to the same data
    println!(
        "{}",
        std::ptr::eq(a.as_ref() as *const _, b.as_ref() as *const _)
    ); // true

    drop(b);
    println!("{}", Rc::strong_count(&a)); // 1

    // Rc with a struct
    #[derive(Debug)]
    struct Node {
        value: i32,
    }

    let node = Rc::new(Node { value: 42 });
    let ref1 = Rc::clone(&node);
    let ref2 = Rc::clone(&node);

    println!("{}", node.value); // 42
    println!("{}", ref1.value); // 42
    println!("{}", ref2.value); // 42
    println!("{}", Rc::strong_count(&node)); // 3

    // Shared ownership in a graph/tree structure
    // Multiple nodes can point to the same child
    #[derive(Debug)]
    enum List {
        Cons(i32, Rc<List>),
        Nil,
    }

    use List::{Cons, Nil};

    let shared_tail = Rc::new(Cons(3, Rc::new(Cons(4, Rc::new(Nil)))));

    // Two lists sharing the same tail
    let list_a = Cons(1, Rc::clone(&shared_tail));
    let list_b = Cons(2, Rc::clone(&shared_tail));

    println!("{}", Rc::strong_count(&shared_tail)); // 3 (shared_tail + list_a + list_b)

    // Traverse list_a: 1 -> 3 -> 4 -> Nil
    let mut current = &list_a;
    loop {
        match current {
            Cons(val, next) => {
                print!("{} -> ", val);
                current = next;
            }
            Nil => {
                println!("Nil");
                break;
            }
        }
    }
    // 1 -> 3 -> 4 -> Nil

    // Traverse list_b: 2 -> 3 -> 4 -> Nil
    let mut current = &list_b;
    loop {
        match current {
            Cons(val, next) => {
                print!("{} -> ", val);
                current = next;
            }
            Nil => {
                println!("Nil");
                break;
            }
        }
    }
    // 2 -> 3 -> 4 -> Nil

    // Rc::try_unwrap — get inner value if only one owner
    let sole = Rc::new(99);
    match Rc::try_unwrap(sole) {
        Ok(val) => println!("{}", val), // 99
        Err(_) => println!("multiple owners"),
    }

    let shared = Rc::new(99);
    let _also = Rc::clone(&shared);
    match Rc::try_unwrap(shared) {
        Ok(val) => println!("{}", val),
        Err(rc) => println!("multiple owners, count: {}", Rc::strong_count(&rc)), // multiple owners, count: 1
    }

    // NOTE: Rc<T> is NOT thread-safe — use Arc<T> for multi-threaded code
    // Rc<T> has no atomic operations, making it faster than Arc<T> for single-thread use
}
