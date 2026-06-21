import gleam/int
import gleam/io
import gleam/result
import gleam/string

// result.try, result.map, result.map_error, result.unwrap, result.lazy_unwrap
// this lesson focuses on chaining — building pipelines that short-circuit on Error

fn parse_int(s: String) -> Result(Int, String) {
  int.parse(s)
  |> result.map_error(fn(_) { "not a number: " <> s })
}

fn ensure_positive(n: Int) -> Result(Int, String) {
  case n > 0 {
    True -> Ok(n)
    False -> Error("expected positive, got " <> int.to_string(n))
  }
}

fn ensure_even(n: Int) -> Result(Int, String) {
  case n % 2 == 0 {
    True -> Ok(n)
    False -> Error("expected even, got " <> int.to_string(n))
  }
}

// chaining with result.try — short-circuits on first Error
fn validate(s: String) -> Result(Int, String) {
  use n <- result.try(parse_int(s))
  use pos <- result.try(ensure_positive(n))
  use even <- result.try(ensure_even(pos))
  Ok(even * 10)
}

pub fn main() {
  // result.map — transform Ok value, pass Error through unchanged
  let doubled = result.map(Ok(5), fn(n) { n * 2 })
  io.println(string.inspect(doubled))
  // Ok(10)

  let still_err = result.map(Error("bad"), fn(n: Int) { n * 2 })
  io.println(string.inspect(still_err))
  // Error("bad")

  // result.map_error — transform Error value, pass Ok through unchanged
  let remapped = result.map_error(Error("raw"), fn(e) { "wrapped: " <> e })
  io.println(string.inspect(remapped))
  // Error("wrapped: raw")

  let still_ok = result.map_error(Ok(42), fn(e: String) { "wrapped: " <> e })
  io.println(string.inspect(still_ok))
  // Ok(42)

  // result.try — like map but the fn also returns a Result; short-circuits on Error
  let chained =
    Ok(5)
    |> result.try(ensure_positive)
    |> result.try(ensure_even)
  io.println(string.inspect(chained))
  // Error("expected even, got 5")

  let chained2 =
    Ok(4)
    |> result.try(ensure_positive)
    |> result.try(ensure_even)
  io.println(string.inspect(chained2))
  // Ok(4)

  // result.unwrap — extract Ok value or fall back to a default
  io.println(string.inspect(result.unwrap(Ok(99), 0)))
  // 99

  io.println(string.inspect(result.unwrap(Error("oops"), 0)))
  // 0

  // result.lazy_unwrap — default is a fn, only evaluated on Error (good for expensive defaults)
  io.println(string.inspect(result.lazy_unwrap(Error("oops"), fn() { 42 })))
  // 42

  // result.unwrap_error — extract the Error value (panics if Ok)
  io.println(result.unwrap_error(Error("the error"), "default"))
  // the error

  // result.flatten — Result(Result(a, e), e) -> Result(a, e)
  let nested: Result(Result(Int, String), String) = Ok(Ok(5))
  io.println(string.inspect(result.flatten(nested)))
  // Ok(5)

  let nested_err: Result(Result(Int, String), String) = Ok(Error("inner"))
  io.println(string.inspect(result.flatten(nested_err)))
  // Error("inner")

  // result.all — List(Result(a, e)) -> Result(List(a), e)
  // Ok only if ALL results are Ok; returns first Error otherwise
  let all_ok = result.all([Ok(1), Ok(2), Ok(3)])
  io.println(string.inspect(all_ok))
  // Ok([1, 2, 3])

  let has_err = result.all([Ok(1), Error("bad"), Ok(3)])
  io.println(string.inspect(has_err))
  // Error("bad")

  // full pipeline with use
  io.println(string.inspect(validate("4")))
  // Ok(40)

  io.println(string.inspect(validate("5")))
  // Error("expected even, got 5")

  io.println(string.inspect(validate("-2")))
  // Error("expected positive, got -2")

  io.println(string.inspect(validate("abc")))
  // Error("not a number: abc")
}
