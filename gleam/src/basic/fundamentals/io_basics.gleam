import gleam/int
import gleam/io
import gleam/string

pub fn main() {
  // io.println — prints a String with a newline, returns Nil
  io.println("Hello!")
  // Hello!

  // io.print — prints without a trailing newline
  io.print("Hello ")
  io.print("World")
  io.println("")
  // Hello World

  // string.inspect converts any value to its string representation
  // this is the replacement for io.debug (removed in gleam_stdlib 1.0)
  io.println(string.inspect(42))
  // 42

  io.println(string.inspect([1, 2, 3]))
  // [1, 2, 3]

  io.println(string.inspect(#("tuple", True, 3.14)))
  // #("tuple", True, 3.14)

  // string interpolation — Gleam has no built-in interpolation syntax
  // use <> for simple concatenation
  let name = "Dylan"
  io.println("Hello, " <> name <> "!")
  // Hello, Dylan!

  // for numbers, convert with int.to_string
  let score = 42
  io.println("Score: " <> int.to_string(score))
  // Score: 42

  // string.concat joins a list of strings
  io.println(string.concat(["a", "b", "c"]))
  // abc

  // string.inspect in a pipeline — works because it returns a String
  [1, 2, 3]
  |> string.inspect
  |> io.println
  // [1, 2, 3]
}
