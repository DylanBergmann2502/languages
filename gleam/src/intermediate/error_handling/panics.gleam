import gleam/io
import gleam/result
import gleam/string

// panic and assert — for situations that should never happen in correct code
// unlike Rust's unwrap(), Gleam makes panics explicit and rare

// --- assert ---
// `let assert` pattern-matches and panics if the pattern fails
// use only when you are CERTAIN the value matches (internal invariants)

fn get_config(key: String) -> Result(String, Nil) {
  case key {
    "host" -> Ok("localhost")
    "port" -> Ok("5432")
    _ -> Error(Nil)
  }
}

// --- panic ---
// explicit crash with a message
// use as a placeholder (like todo!) or for truly impossible branches

fn day_name(n: Int) -> String {
  case n {
    1 -> "Monday"
    2 -> "Tuesday"
    3 -> "Wednesday"
    4 -> "Thursday"
    5 -> "Friday"
    6 -> "Saturday"
    7 -> "Sunday"
    _ -> panic as "day number must be 1-7"
  }
}

// --- todo ---
// `todo` panics with "not yet implemented" — use during development
// it has a type that matches anything so the code still compiles
// example (not called so this lesson runs fully):
//
// fn not_yet(_x: Int) -> String {
//   todo as "implement this later"
// }

pub fn main() {
  // let assert — panics if the pattern doesn't match
  let assert Ok(host) = get_config("host")
  io.println(host)
  // localhost

  // chaining with let assert when you know the shape
  let assert Ok(port) = get_config("port")
  io.println(port)
  // 5432

  // the safer alternative to let assert is always result.unwrap or case
  // let assert is for internal invariants only, not user-facing data
  let safe = result.unwrap(get_config("host"), "default")
  io.println(safe)
  // localhost

  // panic in a reachable branch (commented — would crash the process)
  // let _ = day_name(99)

  // panic in an unreachable branch is fine — it's defensive programming
  io.println(day_name(3))
  // Wednesday

  io.println(day_name(7))
  // Sunday

  // panic as "message" — the as gives a descriptive crash message
  // without `as`, it just says "panic" with no context
  // panic as "something impossible happened"

  // todo — marks unfinished code, compiles but crashes at runtime if reached
  // fn not_yet(_x: Int) -> String { todo as "implement this later" }
  // not_yet(42)  -- would panic: implement this later

  // when to use each:
  // - let assert: you own the data and know it matches (e.g. config at startup)
  // - panic as: a branch that logic guarantees is unreachable
  // - todo as: placeholder during development
  // - result/option: ALWAYS for user input, external data, or anything that can fail

  io.println(string.inspect(True))
  // True  (just to show we got here without panicking)
}
