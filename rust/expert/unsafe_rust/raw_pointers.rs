// Raw pointers: *const T and *mut T
// The building blocks of unsafe memory manipulation
//
// Properties:
//   - Can be null (unlike references)
//   - No lifetime — no borrow checker enforcement
//   - Can alias (multiple *mut T to same location)
//   - No automatic cleanup
//   - Arithmetic via .add(), .sub(), .offset()

use std::ptr;

fn main() {
    // --- Creating raw pointers ---
    let x = 42i32;
    let p_const: *const i32 = &x; // from reference (always valid)
    let p_null: *const i32 = ptr::null(); // null pointer
    let p_addr = 0x1234usize as *const i32; // from arbitrary address (dangerous!)

    println!("{}", p_const.is_null()); // false
    println!("{}", p_null.is_null()); // true
    println!("{}", p_addr.is_null()); // false

    // Dereferencing requires unsafe
    unsafe {
        println!("{}", *p_const); // 42
        // *p_null would be undefined behavior — segfault
    }

    // --- Mutable raw pointers ---
    let mut val = 10i32;
    let p_mut: *mut i32 = &mut val;

    unsafe {
        println!("{}", *p_mut); // 10
        *p_mut = 55;
        println!("{}", *p_mut); // 55
    }
    println!("{}", val); // 55

    // --- Pointer arithmetic ---
    let arr = [1i32, 2, 3, 4, 5];
    let base = arr.as_ptr();

    unsafe {
        for i in 0..arr.len() {
            print!("{} ", *base.add(i));
        }
        println!(); // 1 2 3 4 5
    }

    // offset() — signed arithmetic
    unsafe {
        let mid = base.add(2); // points to arr[2] = 3
        println!("{}", *mid); // 3
        println!("{}", *mid.offset(-1)); // 2  (go back one)
        println!("{}", *mid.offset(1)); // 4  (go forward one)
    }

    // Pointer difference
    let end = unsafe { base.add(arr.len()) };
    let diff = unsafe { end.offset_from(base) };
    println!("{}", diff); // 5

    // --- ptr::read and ptr::write ---
    // Lower level than dereferencing — useful for uninitialized memory
    let mut dest = 0i32;
    let src = 99i32;
    unsafe {
        ptr::write(&mut dest, src);
        println!("{}", ptr::read(&dest)); // 99
    }

    // --- ptr::copy (like memcpy) ---
    let src_arr = [10i32, 20, 30, 40, 50];
    let mut dst_arr = [0i32; 5];
    unsafe {
        ptr::copy(src_arr.as_ptr(), dst_arr.as_mut_ptr(), 5);
    }
    println!("{:?}", dst_arr); // [10, 20, 30, 40, 50]

    // ptr::copy_nonoverlapping — like memcpy (faster, undefined if overlapping)
    let mut dst2 = [0i32; 3];
    unsafe {
        ptr::copy_nonoverlapping(src_arr.as_ptr(), dst2.as_mut_ptr(), 3);
    }
    println!("{:?}", dst2); // [10, 20, 30]

    // --- ptr::swap ---
    let mut a = 111i32;
    let mut b = 222i32;
    unsafe {
        ptr::swap(&mut a, &mut b);
    }
    println!("{} {}", a, b); // 222 111

    // --- Box::into_raw / from_raw ---
    // Manually manage heap memory — escape the borrow checker
    let boxed = Box::new(42i32);
    let raw = Box::into_raw(boxed); // heap-allocated, no longer managed

    unsafe {
        println!("{}", *raw); // 42
        *raw = 100;
        println!("{}", *raw); // 100
        let _ = Box::from_raw(raw); // MUST reconstitute to free memory
    }
    // If you never call Box::from_raw, you have a memory leak

    // --- NonNull<T>: raw pointer that is guaranteed non-null ---
    use std::ptr::NonNull;

    let mut n = 77i32;
    let nn = NonNull::new(&mut n as *mut i32).unwrap();
    unsafe {
        println!("{}", *nn.as_ptr()); // 77
        *nn.as_ptr() = 88;
    }
    println!("{}", n); // 88

    let maybe: Option<NonNull<i32>> = NonNull::new(ptr::null_mut());
    println!("{}", maybe.is_none()); // true — null becomes None

    println!("raw pointers done"); // raw pointers done
}
