import gleam/int
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

// Gleam has no ? operator like Rust, but `use` + result.try achieves the same thing
// this lesson shows the full pattern and how it compares to nested case expressions

// --- setup: a small domain with multiple fallible steps ---

pub type AppError {
  NotFound(String)
  ParseFailed(String)
  ValidationFailed(String)
}

fn find_raw(key: String) -> Result(String, AppError) {
  case key {
    "age" -> Ok("25")
    "score" -> Ok("87")
    "name" -> Ok("Dylan")
    _ -> Error(NotFound(key))
  }
}

fn parse_number(s: String) -> Result(Int, AppError) {
  int.parse(s)
  |> result.map_error(fn(_) { ParseFailed("not a number: " <> s) })
}

fn validate_range(n: Int, lo: Int, hi: Int) -> Result(Int, AppError) {
  case n >= lo && n <= hi {
    True -> Ok(n)
    False ->
      Error(ValidationFailed(
        string.inspect(n)
        <> " not in range ["
        <> string.inspect(lo)
        <> ", "
        <> string.inspect(hi)
        <> "]",
      ))
  }
}

// without use — deeply nested, hard to read
fn get_age_v1(key: String) -> Result(Int, AppError) {
  case find_raw(key) {
    Error(e) -> Error(e)
    Ok(raw) ->
      case parse_number(raw) {
        Error(e) -> Error(e)
        Ok(n) ->
          case validate_range(n, 0, 150) {
            Error(e) -> Error(e)
            Ok(age) -> Ok(age)
          }
      }
  }
}

// with use — flat, reads like imperative code, same semantics
fn get_age_v2(key: String) -> Result(Int, AppError) {
  use raw <- result.try(find_raw(key))
  use n <- result.try(parse_number(raw))
  use age <- result.try(validate_range(n, 0, 150))
  Ok(age)
}

// option version — use with option.then
fn find_optional(key: String) -> Option(String) {
  case key {
    "city" -> Some("Ho Chi Minh City")
    "country" -> Some("Vietnam")
    _ -> None
  }
}

fn get_location() -> Option(String) {
  use city <- option.then(find_optional("city"))
  use country <- option.then(find_optional("country"))
  Some(city <> ", " <> country)
}

fn get_location_missing() -> Option(String) {
  use city <- option.then(find_optional("city"))
  use region <- option.then(find_optional("region"))
  // "region" returns None — short-circuits here
  Some(city <> ", " <> region)
}

pub fn main() {
  // both versions produce identical results
  io.println(string.inspect(get_age_v1("age")))
  // Ok(25)

  io.println(string.inspect(get_age_v2("age")))
  // Ok(25)

  // short-circuit on first Error — NotFound
  io.println(string.inspect(get_age_v2("missing")))
  // Error(NotFound("missing"))

  // short-circuit on ParseFailed if we had a non-number (score is "87" so it works)
  io.println(string.inspect(get_age_v2("score")))
  // Ok(87)

  // converting between Result and Option
  // option.from_result — Ok(x) -> Some(x), Error(_) -> None
  io.println(string.inspect(option.from_result(Ok(42))))
  // Some(42)

  io.println(string.inspect(option.from_result(Error("ignored"))))
  // None

  // option.to_result — Some(x) -> Ok(x), None -> Error(supplied_error)
  io.println(string.inspect(option.to_result(Some(42), "was none")))
  // Ok(42)

  io.println(string.inspect(option.to_result(None, "was none")))
  // Error("was none")

  // option chaining with use + option.then
  io.println(string.inspect(get_location()))
  // Some("Ho Chi Minh City, Vietnam")

  io.println(string.inspect(get_location_missing()))
  // None

  // the mental model:
  // use x <- result.try(expr)  ≈  let x = expr?  in Rust
  // use x <- option.then(expr) ≈  x = expr  where None propagates (like Option chaining)
  // the rest of the block becomes the callback — execution stops on Error/None
}
