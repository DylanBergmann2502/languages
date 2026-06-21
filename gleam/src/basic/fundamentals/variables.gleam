import gleam/io
import gleam/string

pub fn main() {
  // let binds a value to a name — always immutable
  let name = "Gleam"
  io.println(name)
  // Gleam

  // you cannot reassign — this would be a compile error:
  // name = "Other"

  // shadowing is allowed — a new binding with the same name
  let name = "Dylan"
  io.println(name)
  // Dylan

  // shadowing with a different type is also fine
  let name = 42
  io.println(string.inspect(name))
  // 42

  // let with type annotation (optional — Gleam infers types)
  let score: Int = 100
  io.println(string.inspect(score))
  // 100

  // _ discards a value (like Elixir/Rust)
  let _ = "unused"

  // constants are defined at module level with const (not inside fn)
  io.println(string.inspect(max_score))
  // 1000
}

const max_score: Int = 1000
