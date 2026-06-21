import gleam/io
import gleam/string

pub fn main() {
  io.println("Hello, World!")
  // Hello, World!

  // io.println prints a string and adds a newline — returns Nil
  io.println("Hello from Gleam!")
  // Hello from Gleam!

  // string.inspect converts any value to its string representation
  // use it with io.println to print non-string values
  io.println(string.inspect("debug me"))
  // "debug me"

  io.println(string.inspect(42))
  // 42

  io.println(string.inspect(True))
  // True
}
