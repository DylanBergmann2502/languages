// Box<T>: heap allocation with a known, fixed-size pointer
// Use Box when:
// - You have a type whose size can't be known at compile time (recursive types)
// - You want to transfer ownership of large data without copying
// - You want a trait object (Box<dyn Trait>)

fn main() {
    // Basic Box — allocates value on the heap
    let b = Box::new(5);
    println!("{}", b); // 5
    println!("{}", *b + 1); // 6  (deref coercion)

    // Box is automatically dereferenced — use it like the inner type
    let boxed_str = Box::new(String::from("hello"));
    println!("{}", boxed_str.len()); // 5  (no explicit deref needed)
    println!("{}", boxed_str.to_uppercase()); // HELLO

    // Moving large data without copying
    let big_array = Box::new([0i32; 1000]); // 4000 bytes on heap, 8-byte pointer on stack
    println!("{}", big_array[0]); // 0
    println!("{}", big_array.len()); // 1000

    let moved = big_array; // only the pointer is copied, not the data
    println!("{}", moved[0]); // 0

    // Recursive types — can't have infinite size on stack without Box
    // A linked list node: each node holds a value and optionally the next node
    #[derive(Debug)]
    enum List {
        Cons(i32, Box<List>), // Box breaks the infinite size cycle
        Nil,
    }

    let list = List::Cons(
        1,
        Box::new(List::Cons(2, Box::new(List::Cons(3, Box::new(List::Nil))))),
    );
    println!("{:?}", list);
    // Cons(1, Cons(2, Cons(3, Nil)))

    // Traversing the list
    let mut current = &list;
    loop {
        match current {
            List::Cons(val, next) => {
                print!("{} -> ", val);
                current = next;
            }
            List::Nil => {
                println!("Nil");
                break;
            }
        }
    }
    // 1 -> 2 -> 3 -> Nil

    // Box<dyn Trait> — trait objects for dynamic dispatch
    trait Animal {
        fn sound(&self) -> &str;
        fn name(&self) -> &str;
    }

    struct Dog;
    struct Cat;

    impl Animal for Dog {
        fn sound(&self) -> &str {
            "woof"
        }
        fn name(&self) -> &str {
            "Dog"
        }
    }

    impl Animal for Cat {
        fn sound(&self) -> &str {
            "meow"
        }
        fn name(&self) -> &str {
            "Cat"
        }
    }

    // Vec of mixed types behind Box<dyn Trait>
    let animals: Vec<Box<dyn Animal>> = vec![Box::new(Dog), Box::new(Cat), Box::new(Dog)];

    for animal in &animals {
        println!("{} says {}", animal.name(), animal.sound());
    }
    // Dog says woof
    // Cat says meow
    // Dog says woof

    // Size comparison
    println!("{} bytes", std::mem::size_of::<i32>()); // 4 bytes
    println!("{} bytes", std::mem::size_of::<Box<i32>>()); // 8 bytes  (pointer)
    println!("{} bytes", std::mem::size_of::<Box<[i32; 1000]>>()); // 8 bytes  (still just a pointer)
}
