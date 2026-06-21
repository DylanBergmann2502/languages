import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

fn parse_int(s: String) -> Result(Int, Nil) {
  int.parse(s)
}

pub fn main() {
  // ---
  // Gleam has NO if/else — case is the only conditional
  // ---

  // case as an expression — it always returns a value
  let score = 75
  let grade = case score {
    n if n >= 90 -> "A"
    n if n >= 80 -> "B"
    n if n >= 70 -> "C"
    _ -> "F"
  }
  io.println(grade)
  // C

  // case on Bool — this is the Gleam equivalent of if/else
  let passed = score > 50
  let msg = case passed {
    True -> "pass"
    False -> "fail"
  }
  io.println(msg)
  // pass

  // case for side effects — both branches return Nil
  case score > 50 {
    True -> io.println("passed")
    False -> io.println("failed")
  }
  // passed

  // multi-pattern with | (OR)
  let day = "Saturday"
  let day_type = case day {
    "Saturday" | "Sunday" -> "weekend"
    _ -> "weekday"
  }
  io.println(day_type)
  // weekend

  // guards — add `if condition` after a pattern
  let n = 42
  let description = case n {
    0 -> "zero"
    n if n < 0 -> "negative"
    n if n % 2 == 0 -> "positive even"
    _ -> "positive odd"
  }
  io.println(description)
  // positive even

  // ---
  // bool module
  // ---

  io.println(bool.to_string(True))
  // True

  io.println(bool.to_string(False))
  // False

  io.println(string.inspect(bool.negate(True)))
  // False

  // bool.guard — early-return pattern
  // if condition is False, returns the fallback immediately; otherwise runs the fn
  // think of it like a guard clause / early return in other languages
  let safe_sqrt = fn(x: Float) -> String {
    use <- bool.guard(x <. 0.0, "error: negative input")
    "sqrt of " <> string.inspect(x)
  }
  io.println(safe_sqrt(4.0))
  // sqrt of 4.0

  io.println(safe_sqrt(-1.0))
  // error: negative input

  // bool.lazy_guard — same but the fallback is a fn (evaluated lazily)
  let check = fn(x: Int) -> String {
    use <- bool.lazy_guard(x > 100, fn() { "too large: " <> int.to_string(x) })
    "ok: " <> int.to_string(x)
  }
  io.println(check(50))
  // ok: 50

  io.println(check(200))
  // too large: 200

  // ---
  // no loops — use list functions or recursion
  // ---

  // list.each replaces a for loop for side effects
  list.each([1, 2, 3], fn(x) { io.println(int.to_string(x)) })
  // 1
  // 2
  // 3

  // list.map replaces a for loop for transformations
  let doubled = list.map([1, 2, 3], fn(x) { x * 2 })
  io.println(string.inspect(doubled))
  // [2, 4, 6]

  // list.fold replaces accumulator loops
  let sum = list.fold([1, 2, 3, 4, 5], 0, fn(acc, x) { acc + x })
  io.println(string.inspect(sum))
  // 15

  // ---
  // assert and panic
  // ---

  // let assert — pattern match that panics if the pattern doesn't match
  // use when you are certain the value will match (not for user input)
  let assert Ok(val) = parse_int("42")
  io.println(string.inspect(val))
  // 42

  // panic — crashes the process with a message
  // commented out so the lesson completes, but the syntax is:
  // panic as "this should never happen"

  // key difference from Rust:
  // - assert in Gleam is a pattern match, not a boolean check
  // - there is no unwrap() that silently panics — panics are always explicit
  io.println("done")
  // done
}
