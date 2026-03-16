// no_std: Rust without the standard library
//
// By default, Rust programs link against std which provides:
//   - heap allocation (Vec, String, Box, etc.)
//   - threads, I/O, networking, file system
//   - panic infrastructure
//   - OS abstractions
//
// #![no_std] removes std, leaving only:
//   - core: language primitives, iterators, Option, Result, math, fmt
//   - alloc: heap types (Vec, String, Box) — requires a custom allocator
//
// When to use no_std:
//   - Embedded systems (microcontrollers, bare metal)
//   - OS kernels
//   - WebAssembly (sometimes)
//   - Bootloaders, firmware
//
// This file demonstrates no_std concepts in a std environment.
// True no_std programs can't run with rust-script (no OS to run them).

// --- What's in core (always available, no OS needed) ---
// core::option::Option<T>
// core::result::Result<T, E>
// core::fmt (format strings, Display, Debug)
// core::ops (Add, Sub, Mul, Index, ...)
// core::cmp (PartialEq, Ord, ...)
// core::iter (Iterator, IntoIterator, ...)
// core::mem (size_of, align_of, swap, ...)
// core::ptr (raw pointer ops)
// core::slice, core::str (primitive operations)
// core::marker (PhantomData, Send, Sync, Sized)
// core::num (numeric methods, wrapping/checked/saturating ops)

// --- What requires alloc (heap, optional) ---
// alloc::vec::Vec<T>
// alloc::string::String
// alloc::boxed::Box<T>
// alloc::rc::Rc<T>
// alloc::collections::BTreeMap, BTreeSet

// --- Numeric operations safe for no_std ---
fn demo_core_numerics() {
    // Checked arithmetic — returns None on overflow (no panic)
    let a: u8 = 200;
    println!("{:?}", a.checked_add(100)); // None (overflow)
    println!("{:?}", a.checked_add(10)); // Some(210)

    // Saturating — clamps to min/max on overflow
    println!("{}", a.saturating_add(100)); // 255 (u8::MAX)
    println!("{}", a.saturating_sub(255)); // 0

    // Wrapping — wraps around (C integer overflow behavior)
    println!("{}", a.wrapping_add(100)); // 44  (200 + 100 = 300, 300 % 256 = 44)

    // Overflowing — returns (result, did_overflow)
    println!("{:?}", a.overflowing_add(100)); // (44, true)

    // Power, log, etc. available in core
    let x: f32 = 2.0;
    println!("{}", x.powi(10)); // 1024
    println!("{:.4}", x.sqrt()); // 1.4142
}

// --- Fixed-size types critical for embedded ---
fn demo_fixed_types() {
    // Exact-size integer types (not platform-dependent)
    let a: u8 = 255;
    let b: u16 = 65535;
    let c: u32 = 4294967295;
    let d: u64 = u64::MAX;
    let e: i8 = -128;

    println!("{} {} {} {} {}", a, b, c, d, e); // 255 65535 4294967295 18446744073709551615 -128

    // usize/isize — platform-dependent (pointer size)
    println!("{}", std::mem::size_of::<usize>()); // 8 (on 64-bit)

    // Bit manipulation — common in embedded/systems
    let flags: u8 = 0b0000_0000;
    let flags = flags | (1 << 3); // set bit 3
    println!("{:08b}", flags); // 00001000

    let flags = flags | (1 << 7); // set bit 7
    println!("{:08b}", flags); // 10001000

    let is_set = (flags & (1 << 3)) != 0;
    println!("{}", is_set); // true

    let flags = flags & !(1 << 3); // clear bit 3
    println!("{:08b}", flags); // 10000000
}

// --- core::fmt without std ---
// In no_std, you can still use write! and format_args! with core::fmt
// but String doesn't exist — write to fixed buffers instead

use core::fmt::Write;

struct FixedBuffer {
    buf: [u8; 64],
    pos: usize,
}

impl FixedBuffer {
    fn new() -> Self {
        FixedBuffer {
            buf: [0; 64],
            pos: 0,
        }
    }
    fn as_str(&self) -> &str {
        core::str::from_utf8(&self.buf[..self.pos]).unwrap()
    }
}

impl Write for FixedBuffer {
    fn write_str(&mut self, s: &str) -> core::fmt::Result {
        let bytes = s.as_bytes();
        let end = self.pos + bytes.len();
        if end > self.buf.len() {
            return Err(core::fmt::Error);
        }
        self.buf[self.pos..end].copy_from_slice(bytes);
        self.pos = end;
        Ok(())
    }
}

fn demo_no_heap_formatting() {
    let mut buf = FixedBuffer::new();
    write!(buf, "x={}, y={}", 10, 20).unwrap();
    println!("{}", buf.as_str()); // x=10, y=20

    let mut buf2 = FixedBuffer::new();
    write!(buf2, "pi={:.4}", core::f64::consts::PI).unwrap();
    println!("{}", buf2.as_str()); // pi=3.1416
}

// --- PhantomData: marker for type system without runtime cost ---
use core::marker::PhantomData;

struct Reg<T> {
    addr: usize,
    _marker: PhantomData<T>, // zero-size, just carries type info
}

impl<T> Reg<T> {
    const fn new(addr: usize) -> Self {
        Reg {
            addr,
            _marker: PhantomData,
        }
    }
}

struct ReadOnly;
struct ReadWrite;

type RoReg = Reg<ReadOnly>;
type RwReg = Reg<ReadWrite>;

fn demo_phantom_data() {
    let status_reg: RoReg = Reg::new(0x4000_0000);
    let control_reg: RwReg = Reg::new(0x4000_0004);

    println!("{:#x}", status_reg.addr); // 0x40000000
    println!("{:#x}", control_reg.addr); // 0x40000004
    println!("{}", std::mem::size_of::<RoReg>()); // 8 (just a usize, PhantomData is zero-size)
}

fn main() {
    demo_core_numerics();
    demo_fixed_types();
    demo_no_heap_formatting();
    demo_phantom_data();

    // Summary: no_std programs use core:: instead of std::
    // For embedded targets, you also define:
    //   - A panic handler:  #[panic_handler] fn panic(_: &PanicInfo) -> !
    //   - An allocator:     #[global_allocator] if using alloc
    //   - A linker script:  memory layout for the target hardware
    println!("no_std concepts demonstrated"); // no_std concepts demonstrated
}
