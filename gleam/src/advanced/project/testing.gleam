import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

// gleeunit — Gleam's test framework, built on eunit (Erlang)
// tests live in test/ — not src/ (dev dependencies can't be imported from src/)
// run with: gleam test
//
// each public function whose name ends in _test is run automatically
// no test registration needed — gleam discovers them by name suffix

// --- the code under test (this would live in src/) ---

pub fn add(a: Int, b: Int) -> Int {
  a + b
}

pub fn divide(a: Int, b: Int) -> Result(Int, String) {
  case b {
    0 -> Error("division by zero")
    _ -> Ok(a / b)
  }
}

pub fn find_first(list: List(a), pred: fn(a) -> Bool) -> option.Option(a) {
  case list {
    [] -> None
    [head, ..rest] ->
      case pred(head) {
        True -> Some(head)
        False -> find_first(rest, pred)
      }
  }
}

pub fn word_count(text: String) -> Int {
  text
  |> string.trim
  |> string.split(" ")
  |> list.filter(fn(w) { w != "" })
  |> list.length
}

// --- manual assertions (without gleeunit) ---
// these show the same logic as should.equal/should.be_ok
// real tests in test/ use should.equal, should.be_ok, should.be_error etc.

fn assert_eq(label: String, got: a, expected: a) -> Nil {
  case got == expected {
    True -> io.println(label <> ": ok")
    False ->
      panic as {
        label
        <> ": expected "
        <> string.inspect(expected)
        <> ", got "
        <> string.inspect(got)
      }
  }
}

fn assert_ok(label: String, result: Result(a, e)) -> a {
  case result {
    Ok(v) -> {
      io.println(label <> ": ok")
      v
    }
    Error(e) ->
      panic as {
        label <> ": expected Ok, got Error(" <> string.inspect(e) <> ")"
      }
  }
}

fn assert_error(label: String, result: Result(a, e)) -> e {
  case result {
    Error(e) -> {
      io.println(label <> ": ok")
      e
    }
    Ok(v) ->
      panic as {
        label <> ": expected Error, got Ok(" <> string.inspect(v) <> ")"
      }
  }
}

pub fn main() {
  io.println("=== testing concepts ===")
  io.println("")

  // basic equality
  assert_eq("add(2,3)", add(2, 3), 5)
  // add(2,3): ok
  assert_eq("add(0,0)", add(0, 0), 0)
  // add(0,0): ok
  assert_eq("add(-1,1)", add(-1, 1), 0)
  // add(-1,1): ok

  io.println("")

  // Result assertions
  let v = assert_ok("divide(10,2)", divide(10, 2))
  assert_eq("divide result", v, 5)
  // divide(10,2): ok
  // divide result: ok

  let e = assert_error("divide by zero", divide(10, 0))
  assert_eq("error message", e, "division by zero")
  // divide by zero: ok
  // error message: ok

  io.println("")

  // Option assertions
  let found = find_first([1, 2, 3, 4], fn(n) { n > 2 })
  assert_eq("find_first found", found, Some(3))
  // find_first found: ok

  let not_found = find_first([1, 2, 3], fn(n) { n > 10 })
  assert_eq("find_first none", not_found, None)
  // find_first none: ok

  io.println("")

  // word count
  assert_eq("two words", word_count("hello world"), 2)
  // two words: ok
  assert_eq("extra spaces", word_count("  hello   world  "), 2)
  // extra spaces: ok
  assert_eq("empty string", word_count(""), 0)
  // empty string: ok

  io.println("")

  // pipeline with use
  let outcome = {
    use a <- result.try(divide(10, 2))
    use b <- result.try(divide(a, 1))
    Ok(a + b)
  }
  assert_eq("pipeline", outcome, Ok(10))
  // pipeline: ok

  io.println("")
  io.println("all assertions passed")
  // all assertions passed

  io.println("")
  io.println("=== what real test files look like ===")
  io.println("")
  io.println("// test/gleam_lessons_test.gleam")
  io.println("import gleeunit")
  io.println("import gleeunit/should")
  io.println("import advanced/project/testing as t")
  io.println("")
  io.println("pub fn main() { gleeunit.main() }")
  io.println("")
  io.println("pub fn add_test() {")
  io.println("  t.add(2, 3) |> should.equal(5)")
  io.println("}")
  io.println("")
  io.println("pub fn divide_by_zero_test() {")
  io.println(
    "  t.divide(10, 0) |> should.be_error |> should.equal(\"division by zero\")",
  )
  io.println("}")
  io.println("")
  io.println("run with: gleam test")
  io.println("  ...(dots for each passing test)")
  io.println("  N tests, 0 failures in 0.012s")
  // run with: gleam test
}

pub fn sum(nums: List(Int)) -> Int {
  list.fold(nums, 0, fn(acc, n) { acc + n })
}

pub fn product(nums: List(Int)) -> Int {
  list.fold(nums, 1, fn(acc, n) { acc * n })
}
