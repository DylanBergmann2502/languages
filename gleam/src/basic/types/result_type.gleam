import gleam/int
import gleam/io
import gleam/result
import gleam/string

// Result(value, error) = Ok(value) | Error(error)
// you know this from Rust — same concept, cleaner syntax

fn divide(a: Int, b: Int) -> Result(Int, String) {
  case b {
    0 -> Error("division by zero")
    _ -> Ok(a / b)
  }
}

fn parse_positive(s: String) -> Result(Int, String) {
  case int.parse(s) {
    Ok(n) if n > 0 -> Ok(n)
    Ok(_) -> Error("must be positive")
    Error(_) -> Error("not a number: " <> s)
  }
}

pub fn main() {
  // Ok wraps a success value
  let good = Ok(42)
  io.println(string.inspect(good))
  // Ok(42)

  // Error wraps a failure value
  let bad: Result(Int, String) = Error("something went wrong")
  io.println(string.inspect(bad))
  // Error("something went wrong")

  // pattern match to handle both branches
  case divide(10, 2) {
    Ok(n) -> io.println("Result: " <> string.inspect(n))
    Error(e) -> io.println("Error: " <> e)
  }
  // Result: 5

  case divide(10, 0) {
    Ok(n) -> io.println("Result: " <> string.inspect(n))
    Error(e) -> io.println("Error: " <> e)
  }
  // Error: division by zero

  // result.unwrap — provide a default on Error
  let val = result.unwrap(divide(9, 3), 0)
  io.println(string.inspect(val))
  // 3

  // result.map — transform Ok value, pass Error through
  let doubled =
    divide(10, 2)
    |> result.map(fn(n) { n * 2 })
  io.println(string.inspect(doubled))
  // Ok(10)

  // result.try — chain fallible operations (like ? in Rust)
  // if the first is Ok, passes the value to the next fn
  // if the first is Error, short-circuits
  let chained =
    parse_positive("5")
    |> result.try(fn(n) { divide(100, n) })
  io.println(string.inspect(chained))
  // Ok(20)

  let chained_err =
    parse_positive("-5")
    |> result.try(fn(n) { divide(100, n) })
  io.println(string.inspect(chained_err))
  // Error("must be positive")

  // result.map_error — transform the Error value, pass Ok through
  let remapped =
    divide(10, 0)
    |> result.map_error(fn(e) { "Oops: " <> e })
  io.println(string.inspect(remapped))
  // Error("Oops: division by zero")

  // result.is_ok / result.is_error
  io.println(string.inspect(result.is_ok(divide(10, 2))))
  // True

  io.println(string.inspect(result.is_error(divide(10, 0))))
  // True
}
