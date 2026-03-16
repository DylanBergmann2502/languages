use std::cell::RefCell;
use std::rc::{Rc, Weak};

// Weak<T>: a non-owning reference — does NOT increment the strong count
// Used to break reference cycles that would cause memory leaks with Rc<T>
//
// Strong count > 0  => data stays alive
// Weak count        => doesn't keep data alive
// To use a Weak<T>: call .upgrade() -> Option<Rc<T>>

fn main() {
    // Basic Weak usage
    let strong = Rc::new(String::from("hello"));
    let weak = Rc::downgrade(&strong); // create a Weak from an Rc

    println!("{}", Rc::strong_count(&strong)); // 1
    println!("{}", Rc::weak_count(&strong)); // 1

    // upgrade() returns Some(Rc<T>) if data is still alive
    if let Some(val) = weak.upgrade() {
        println!("{}", val); // hello
    }

    // After strong is dropped, upgrade() returns None
    drop(strong);
    match weak.upgrade() {
        Some(val) => println!("{}", val),
        None => println!("data was dropped"), // data was dropped
    }

    // --- Reference cycle without Weak (memory leak) ---
    // If Node owns children (Rc) and children own parent (Rc), count never hits 0
    // Solved by making the parent link a Weak reference

    #[derive(Debug)]
    struct Node {
        value: i32,
        parent: RefCell<Weak<Node>>, // Weak: parent doesn't keep children alive
        children: RefCell<Vec<Rc<Node>>>, // Rc: children kept alive by parent
    }

    impl Node {
        fn new(value: i32) -> Rc<Node> {
            Rc::new(Node {
                value,
                parent: RefCell::new(Weak::new()),
                children: RefCell::new(vec![]),
            })
        }
    }

    let parent = Node::new(1);
    let child = Node::new(2);

    // Connect child to parent
    *child.parent.borrow_mut() = Rc::downgrade(&parent);

    // Connect parent to child
    parent.children.borrow_mut().push(Rc::clone(&child));

    println!("{}", parent.value); // 1
    println!("{}", child.value); // 2

    // Child can look up its parent without keeping it alive
    if let Some(p) = child.parent.borrow().upgrade() {
        println!("child's parent: {}", p.value); // child's parent: 1
    }

    // Count: parent has 1 strong (parent var), child has 2 strong (child var + parent.children)
    println!("{}", Rc::strong_count(&parent)); // 1
    println!("{}", Rc::strong_count(&child)); // 2

    // Drop parent — child's Weak<parent> becomes None, no cycle
    drop(parent);
    match child.parent.borrow().upgrade() {
        Some(p) => println!("parent: {}", p.value),
        None => println!("parent was dropped"), // parent was dropped
    }

    // --- Tree structure example ---
    let root = Node::new(10);
    let left = Node::new(5);
    let right = Node::new(15);

    *left.parent.borrow_mut() = Rc::downgrade(&root);
    *right.parent.borrow_mut() = Rc::downgrade(&root);

    root.children.borrow_mut().push(Rc::clone(&left));
    root.children.borrow_mut().push(Rc::clone(&right));

    println!("root: {}", root.value); // root: 10
    for child in root.children.borrow().iter() {
        println!("  child: {}", child.value);
    }
    // child: 5
    // child: 15

    if let Some(p) = left.parent.borrow().upgrade() {
        println!("left's parent: {}", p.value); // left's parent: 10
    }

    // Strong counts
    println!("{}", Rc::strong_count(&root)); // 1
    println!("{}", Rc::strong_count(&left)); // 2  (left + root.children)
    println!("{}", Rc::strong_count(&right)); // 2  (right + root.children)
    println!("{}", Rc::weak_count(&root)); // 2  (left.parent + right.parent)

    // When root is dropped: root's strong count -> 0 -> Node freed
    // left and right then lose their parent Weak ref -> None
    // left/right themselves drop when left/right vars go out of scope
}
