// Unions: all fields share the same memory location
// Like C unions — only one field is valid at a time
// Reading the wrong field is undefined behavior — requires unsafe
//
// Use cases:
//   - FFI with C unions
//   - Low-level bit manipulation
//   - Memory-efficient tagged variants (though enums are usually better)
//
// Note: Rust enums are a safe, tagged union — prefer them over raw unions

// --- Basic union ---
union IntOrFloat {
    i: i32,
    f: f32,
}

// --- Union for bit manipulation ---
union FloatBits {
    value: f32,
    bits: u32,
}

// --- Union with larger types ---
#[allow(dead_code)]
union IpAddr {
    v4: [u8; 4],
    v6: [u8; 16],
    raw: u128,
}

// --- C-compatible union (FFI use case) ---
#[repr(C)]
union CUnion {
    as_int: i64,
    as_bytes: [u8; 8],
    as_pair: (i32, i32),
}

// --- Tagged union (manual enum simulation) ---
// In practice, use Rust enums — this is just to show how C-style tagged unions work
#[repr(u8)]
#[allow(dead_code)]
enum Tag {
    Int = 0,
    Float = 1,
    Bool = 2,
}

#[repr(C)]
union Value {
    int_val: i64,
    float_val: f64,
    bool_val: bool,
}

#[repr(C)]
struct TaggedValue {
    tag: Tag,
    data: Value,
}

impl TaggedValue {
    fn new_int(n: i64) -> Self {
        TaggedValue {
            tag: Tag::Int,
            data: Value { int_val: n },
        }
    }
    fn new_float(f: f64) -> Self {
        TaggedValue {
            tag: Tag::Float,
            data: Value { float_val: f },
        }
    }
    fn new_bool(b: bool) -> Self {
        TaggedValue {
            tag: Tag::Bool,
            data: Value { bool_val: b },
        }
    }
    fn display(&self) {
        // SAFETY: we only read the field matching the tag
        unsafe {
            match self.tag {
                Tag::Int => println!("Int({})", self.data.int_val),
                Tag::Float => println!("Float({})", self.data.float_val),
                Tag::Bool => println!("Bool({})", self.data.bool_val),
            }
        }
    }
}

fn main() {
    // --- Basic union: same memory, different interpretations ---
    let u = IntOrFloat { i: 42 };
    unsafe {
        println!("{}", u.i); // 42
        // Reading u.f interprets those same bits as f32
        println!("{}", u.f); // 5.9e-44  (not meaningful)
    }

    let u2 = IntOrFloat { f: 3.14 };
    unsafe {
        println!("{:.2}", u2.f); // 3.14
        // Reading u2.i interprets those bits as i32
        println!("{}", u2.i); // 1078523331  (bit pattern of 3.14f32)
    }

    // --- FloatBits: inspect IEEE 754 representation ---
    let fb = FloatBits { value: 1.0f32 };
    unsafe {
        println!("{:#010x}", fb.bits); // 0x3f800000  (IEEE 754 for 1.0)
    }

    let fb2 = FloatBits { value: -0.0f32 };
    unsafe {
        println!("{:#010x}", fb2.bits); // 0x80000000  (negative zero)
    }

    let fb3 = FloatBits { bits: 0x7f800000 }; // set bits to +infinity
    unsafe {
        println!("{}", fb3.value); // inf
    }

    // --- Size of a union = size of its largest field ---
    println!("{}", std::mem::size_of::<IntOrFloat>()); // 4  (max of i32=4, f32=4)
    println!("{}", std::mem::size_of::<IpAddr>()); // 16 (max of v4=4, v6=16, u128=16)
    println!("{}", std::mem::size_of::<CUnion>()); // 8  (max of i64=8)

    // --- CUnion: same 8 bytes, different views ---
    let cu = CUnion {
        as_int: 0x0102030405060708i64,
    };
    unsafe {
        println!("{}", cu.as_int); // 72623859790382856
        println!("{:?}", cu.as_bytes); // [8, 7, 6, 5, 4, 3, 2, 1]  (little-endian)
        println!("{:?}", cu.as_pair); // (84281096, 16909060)
    }

    // --- Tagged union (safe dispatch via tag) ---
    let vals = vec![
        TaggedValue::new_int(42),
        TaggedValue::new_float(3.14),
        TaggedValue::new_bool(true),
    ];

    for v in &vals {
        v.display();
    }
    // Int(42)
    // Float(3.14)
    // Bool(true)

    // --- Why prefer enums ---
    // Rust enums ARE tagged unions, but safe:
    #[derive(Debug)]
    enum SafeValue {
        Int(i64),
        Float(f64),
        Bool(bool),
    }

    let safe_vals = vec![
        SafeValue::Int(42),
        SafeValue::Float(3.14),
        SafeValue::Bool(true),
    ];

    for v in &safe_vals {
        match v {
            SafeValue::Int(n) => println!("Int({})", n), // Int(42)
            SafeValue::Float(f) => println!("Float({})", f), // Float(3.14)
            SafeValue::Bool(b) => println!("Bool({})", b), // Bool(true)
        }
    }

    println!("union types done"); // union types done
}
