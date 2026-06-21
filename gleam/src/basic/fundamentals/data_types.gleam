import gleam/float
import gleam/int
import gleam/io
import gleam/string

pub fn main() {
  // Int — arbitrary precision, no overflow
  let age = 30
  io.println(string.inspect(age))
  // 30

  // Int arithmetic
  io.println(string.inspect(10 + 3))
  // 13
  io.println(string.inspect(10 - 3))
  // 7
  io.println(string.inspect(10 * 3))
  // 30
  io.println(string.inspect(10 / 3))
  // 3  (integer division, truncates)
  io.println(string.inspect(10 % 3))
  // 1  (remainder)

  // Float — always written with a decimal point
  let pi = 3.14
  io.println(string.inspect(pi))
  // 3.14

  // Int and Float are separate types — no implicit casting
  // io.println(string.inspect(1 + 1.0))  -- compile error
  io.println(string.inspect(int.to_float(10) +. 1.5))
  // 11.5
  io.println(string.inspect(float.round(3.7)))
  // 4

  // Float operators use a dot suffix: +. -. *. /.
  io.println(string.inspect(1.0 +. 2.0))
  // 3.0
  io.println(string.inspect(10.0 /. 3.0))
  // 3.3333333333333335

  // Bool
  let is_cool = True
  io.println(string.inspect(is_cool))
  // True
  io.println(string.inspect(True && False))
  // False
  io.println(string.inspect(True || False))
  // True
  io.println(string.inspect(!True))
  // False

  // String — always double-quoted UTF-8
  let greeting = "Hello"
  io.println(greeting)
  // Hello

  // String concatenation with <>
  io.println(greeting <> ", World!")
  // Hello, World!

  // Nil — the only value of type Nil, Gleam's unit type (not null)
  // functions that return nothing return Nil
  let nothing = Nil
  io.println(string.inspect(nothing))
  // Nil
}
