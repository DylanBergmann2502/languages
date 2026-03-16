// Embedded programming basics in Rust
//
// Real embedded programs run on microcontrollers (ARM Cortex-M, RISC-V, AVR, etc.)
// and require:
//   - A target triple: e.g. thumbv7em-none-eabihf for ARM Cortex-M4
//   - A linker script: defines memory regions (FLASH, RAM)
//   - A panic handler: what to do when panic! is called
//   - A startup routine: sets up the stack, initializes memory
//
// Popular crates:
//   cortex-m / cortex-m-rt  — ARM Cortex-M support
//   embedded-hal             — hardware abstraction layer traits
//   rp2040-hal / stm32-hal   — chip-specific HALs
//   embassy                  — async embedded framework
//
// This file demonstrates embedded concepts that run in a std environment.
// Real embedded code would use #![no_std] and #![no_main].

// --- Memory-mapped I/O simulation ---
// In embedded systems, hardware registers are at fixed memory addresses.
// You write/read those addresses to control hardware (LEDs, UARTs, timers, etc.)

use std::sync::atomic::{AtomicU32, Ordering};

// Simulated hardware register (in real embedded: just a raw pointer to an address)
struct Register {
    value: AtomicU32,
    name: &'static str,
}

impl Register {
    const fn new(name: &'static str) -> Self {
        Register {
            value: AtomicU32::new(0),
            name,
        }
    }

    fn write(&self, val: u32) {
        println!("  WRITE {}  <- {:#010x}", self.name, val);
        self.value.store(val, Ordering::Relaxed);
    }

    fn read(&self) -> u32 {
        self.value.load(Ordering::Relaxed)
    }

    fn set_bit(&self, bit: u8) {
        let v = self.read() | (1 << bit);
        self.write(v);
    }

    fn clear_bit(&self, bit: u8) {
        let v = self.read() & !(1 << bit);
        self.write(v);
    }

    fn is_set(&self, bit: u8) -> bool {
        (self.read() & (1 << bit)) != 0
    }
}

// Simulated GPIO peripheral
static GPIO_DIR: Register = Register::new("GPIO_DIR"); // 0 = input, 1 = output
static GPIO_OUT: Register = Register::new("GPIO_OUT"); // output values
static GPIO_IN: Register = Register::new("GPIO_IN"); // input values (read-only in hw)

fn gpio_set_output(pin: u8) {
    GPIO_DIR.set_bit(pin);
}

fn gpio_write_high(pin: u8) {
    GPIO_OUT.set_bit(pin);
}

fn gpio_write_low(pin: u8) {
    GPIO_OUT.clear_bit(pin);
}

fn gpio_read(pin: u8) -> bool {
    GPIO_IN.is_set(pin)
}

// --- State machine pattern (common in embedded) ---
// Embedded firmware is often one big state machine

#[derive(Debug, PartialEq, Clone, Copy)]
enum LedState {
    Off,
    On,
    Blinking { count: u32 },
    Error,
}

struct Led {
    pin: u8,
    state: LedState,
}

impl Led {
    fn new(pin: u8) -> Self {
        gpio_set_output(pin);
        Led {
            pin,
            state: LedState::Off,
        }
    }

    fn turn_on(&mut self) {
        gpio_write_high(self.pin);
        self.state = LedState::On;
    }

    #[allow(dead_code)]
    fn turn_off(&mut self) {
        gpio_write_low(self.pin);
        self.state = LedState::Off;
    }

    fn blink(&mut self, times: u32) {
        self.state = LedState::Blinking { count: times };
        for _ in 0..times {
            gpio_write_high(self.pin);
            gpio_write_low(self.pin);
        }
        self.state = LedState::Off;
    }

    fn set_error(&mut self) {
        self.state = LedState::Error;
        gpio_write_high(self.pin); // error = solid on
    }
}

// --- Ring buffer (common embedded data structure, no heap needed) ---
struct RingBuffer<const N: usize> {
    buf: [u8; N],
    read: usize,
    write: usize,
    len: usize,
}

impl<const N: usize> RingBuffer<N> {
    const fn new() -> Self {
        RingBuffer {
            buf: [0; N],
            read: 0,
            write: 0,
            len: 0,
        }
    }

    fn push(&mut self, byte: u8) -> bool {
        if self.len == N {
            return false;
        } // full
        self.buf[self.write] = byte;
        self.write = (self.write + 1) % N;
        self.len += 1;
        true
    }

    fn pop(&mut self) -> Option<u8> {
        if self.len == 0 {
            return None;
        } // empty
        let byte = self.buf[self.read];
        self.read = (self.read + 1) % N;
        self.len -= 1;
        Some(byte)
    }

    fn is_empty(&self) -> bool {
        self.len == 0
    }
    fn is_full(&self) -> bool {
        self.len == N
    }
    fn len(&self) -> usize {
        self.len
    }
}

// --- Bitfield manipulation (register configuration) ---
// Embedded registers often pack multiple fields into one u32
// e.g. UART config: [31:16]=baud_div, [8]=parity_en, [7:6]=stop_bits, [1:0]=data_bits

struct UartConfig(u32);

impl UartConfig {
    fn new() -> Self {
        UartConfig(0)
    }

    fn set_baud_div(&mut self, div: u16) {
        self.0 = (self.0 & 0x0000_FFFF) | ((div as u32) << 16);
    }

    fn set_parity(&mut self, enable: bool) {
        if enable {
            self.0 |= 1 << 8;
        } else {
            self.0 &= !(1 << 8);
        }
    }

    fn set_data_bits(&mut self, bits: u8) {
        self.0 = (self.0 & !0b11) | ((bits & 0b11) as u32);
    }

    fn raw(&self) -> u32 {
        self.0
    }
}

fn main() {
    // GPIO simulation
    println!("--- GPIO ---");
    gpio_set_output(13); // pin 13 = output (LED pin on Arduino)
    gpio_write_high(13);
    println!("pin 13 output: {:#010x}", GPIO_OUT.read()); // 0x00002000 (bit 13 set)
    gpio_write_low(13);
    println!("pin 13 output: {:#010x}", GPIO_OUT.read()); // 0x00000000

    // Simulated input (pretend pin 5 is pressed)
    GPIO_IN.set_bit(5);
    println!("pin 5 pressed: {}", gpio_read(5)); // true
    println!("pin 6 pressed: {}", gpio_read(6)); // false

    // LED state machine
    println!("\n--- LED State Machine ---");
    let mut led = Led::new(13);
    println!("{:?}", led.state); // Off

    led.turn_on();
    println!("{:?}", led.state); // On

    led.blink(3);
    println!("{:?}", led.state); // Off

    led.set_error();
    println!("{:?}", led.state); // Error

    // Ring buffer
    println!("\n--- Ring Buffer ---");
    let mut rb: RingBuffer<8> = RingBuffer::new();
    println!("{}", rb.is_empty()); // true

    for b in b"hello" {
        rb.push(*b);
    }
    println!("{}", rb.len()); // 5
    println!("{}", rb.is_full()); // false

    while !rb.is_empty() {
        if let Some(b) = rb.pop() {
            print!("{}", b as char);
        }
    }
    println!(); // hello

    // Full buffer
    let mut rb2: RingBuffer<4> = RingBuffer::new();
    println!("{}", rb2.push(1)); // true
    println!("{}", rb2.push(2)); // true
    println!("{}", rb2.push(3)); // true
    println!("{}", rb2.push(4)); // true
    println!("{}", rb2.push(5)); // false (full)

    // UART bitfield config
    println!("\n--- UART Config ---");
    let mut uart = UartConfig::new();
    uart.set_baud_div(521); // 48MHz / 521 ≈ 9600 baud
    uart.set_parity(false);
    uart.set_data_bits(3); // 0b11 = 8 data bits
    println!("{:#010x}", uart.raw()); // 0x02090003

    println!("embedded basics done"); // embedded basics done
}
