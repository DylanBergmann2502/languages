import gleam/io
import gleam/string

pub fn main() {
  // tuples hold a fixed number of values of different types
  // syntax: #(a, b, c, ...)
  let point = #(1, 2)
  io.println(string.inspect(point))
  // #(1, 2)

  let person = #("Dylan", 30, True)
  io.println(string.inspect(person))
  // #("Dylan", 30, True)

  // access by index with .0 .1 .2
  io.println(person.0)
  // Dylan

  io.println(string.inspect(person.1))
  // 30

  io.println(string.inspect(person.2))
  // True

  // destructuring with let
  let #(name, age, active) = person
  io.println(name <> " is " <> string.inspect(age))
  // Dylan is 30

  io.println(string.inspect(active))
  // True

  // destructuring in a function parameter
  let describe = fn(p: #(String, Int)) -> String {
    let #(n, a) = p
    n <> " aged " <> string.inspect(a)
  }
  io.println(describe(#("Alice", 25)))
  // Alice aged 25

  // tuples are great for returning multiple values from a function
  let min_max = fn(a: Int, b: Int) -> #(Int, Int) {
    case a < b {
      True -> #(a, b)
      False -> #(b, a)
    }
  }
  let #(lo, hi) = min_max(9, 3)
  io.println("min: " <> string.inspect(lo) <> ", max: " <> string.inspect(hi))
  // min: 3, max: 9

  // pattern matching on tuples in case
  let coord = #(0, 5)
  case coord {
    #(0, 0) -> io.println("origin")
    #(0, y) -> io.println("y-axis at " <> string.inspect(y))
    #(x, 0) -> io.println("x-axis at " <> string.inspect(x))
    #(x, y) -> io.println(string.inspect(x) <> ", " <> string.inspect(y))
  }
  // y-axis at 5

  // _ to ignore fields you don't need
  let #(first, _, _) = #("keep", "drop", "drop")
  io.println(first)
  // keep
}
