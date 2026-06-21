import gleam/bool
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

// `use` is Gleam's most unique feature — no equivalent in Elixir, Rust, or Go
//
// it desugars callback-heavy code into flat, readable code
// specifically: `use x <- f(arg)` means "call f(arg, fn(x) { rest_of_block })"
//
// this is most useful with bool.guard, result.try, option.map, and custom callbacks

// --- example 1: bool.guard ---

fn check_age(age: Int) -> String {
  // without use:
  // bool.guard(age < 0, "invalid age", fn() {
  //   bool.guard(age < 18, "too young", fn() {
  //     "welcome"
  //   })
  // })

  // with use — reads like early-return guard clauses
  use <- bool.guard(age < 0, "invalid age")
  use <- bool.guard(age < 18, "too young")
  "welcome"
}

// --- example 2: result.try (the ? operator equivalent) ---

fn parse_and_double(s: String) -> Result(Int, String) {
  // without use — nested callbacks:
  // result.try(parse_int(s), fn(n) {
  //   result.try(check_positive(n), fn(pos) {
  //     Ok(pos * 2)
  //   })
  // })

  use n <- result.try(parse_int(s))
  use pos <- result.try(check_positive(n))
  Ok(pos * 2)
}

fn parse_int(s: String) -> Result(Int, String) {
  case s {
    "1" -> Ok(1)
    "2" -> Ok(2)
    "5" -> Ok(5)
    _ -> Error("not a number: " <> s)
  }
}

fn check_positive(n: Int) -> Result(Int, String) {
  case n > 0 {
    True -> Ok(n)
    False -> Error("must be positive")
  }
}

// --- example 3: option chaining ---

fn get_user_city(user_id: Int) -> Option(String) {
  use user <- option.then(get_user(user_id))
  use address <- option.then(get_address(user))
  Some(address)
}

fn get_user(id: Int) -> Option(String) {
  case id {
    1 -> Some("Dylan")
    _ -> None
  }
}

fn get_address(user: String) -> Option(String) {
  case user {
    "Dylan" -> Some("Ho Chi Minh City")
    _ -> None
  }
}

// --- example 4: use with list.each ---

fn log_each(items: List(String)) -> Nil {
  use item <- list.each(items)
  io.println("• " <> item)
}

pub fn main() {
  // bool.guard with use
  io.println(check_age(-1))
  // invalid age

  io.println(check_age(15))
  // too young

  io.println(check_age(25))
  // welcome

  // result chaining with use — short-circuits on first Error
  io.println(string.inspect(parse_and_double("5")))
  // Ok(10)

  io.println(string.inspect(parse_and_double("abc")))
  // Error("not a number: abc")

  // option chaining with use
  io.println(string.inspect(get_user_city(1)))
  // Some("Ho Chi Minh City")

  io.println(string.inspect(get_user_city(99)))
  // None

  // use with list.each
  log_each(["gleam", "erlang", "beam"])
  // • gleam
  // • erlang
  // • beam

  // use can be used with any function that takes a callback as its LAST argument
  // the pattern is always: use binding <- some_fn(args)
  // the rest of the block becomes the callback body
  let val =
    result.try(Ok(10), fn(n) { result.try(Ok(n * 2), fn(m) { Ok(m + 1) }) })
  io.println(string.inspect(val))
  // Ok(21)

  // same thing with use — much flatter
  let val2 = {
    use n <- result.try(Ok(10))
    use m <- result.try(Ok(n * 2))
    Ok(m + 1)
  }
  io.println(string.inspect(val2))
  // Ok(21)
}
