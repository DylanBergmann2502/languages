import gleam/io
import gleam/string

// --- pub vs private ---
//
// pub fn  — visible to any module that imports this one
// fn      — private, only usable within this file
// pub type / type — same rule for types
// const / pub const — same rule for constants

pub fn public_hello() -> String {
  "hello from a public function"
}

fn private_helper(s: String) -> String {
  string.uppercase(s)
}

pub fn shout(s: String) -> String {
  // private_helper is usable here — same module
  private_helper(s) <> "!"
}

pub type Color {
  Red
  Green
  Blue
}

// private type — only usable inside this file
type Internal {
  InternalValue(Int)
}

pub const max_retries: Int = 3

const default_timeout: Int = 5000

// --- module namespacing ---
//
// Gleam derives module names from file paths under src/
// this file is src/intermediate/modules/modules.gleam
// its module name is: intermediate/modules/modules
// imported as: import intermediate/modules/modules
//
// stdlib modules follow the same pattern:
// gleam/io, gleam/string, gleam/list, etc.

pub fn main() {
  io.println(public_hello())
  // hello from a public function

  io.println(shout("gleam"))
  // GLEAM!

  io.println(string.inspect(Red))
  // Red

  // private_helper is not accessible from outside — but works here
  io.println(private_helper("test"))
  // TEST

  // private type works inside the module
  let _ = InternalValue(42)

  io.println(string.inspect(max_retries))
  // 3

  io.println(string.inspect(default_timeout))
  // 5000

  // module names map to file paths:
  // src/gleam/io.gleam        → import gleam/io
  // src/intermediate/modules/modules.gleam → import intermediate/modules/modules
  io.println("module namespacing shown above in comments")
}
