import gleam/erlang/atom
import gleam/erlang/process
import gleam/io
import gleam/string

// @external — call any Erlang function directly from Gleam
// syntax: @external(erlang, "erlang_module", "function_name")
//         pub fn gleam_name(args...) -> ReturnType
//
// you give the Erlang types Gleam-friendly names; the compiler trusts you
// this is how gleam_stdlib and gleam_erlang themselves are built

// --- calling standard Erlang BIFs ---

// erlang:abs/1
@external(erlang, "erlang", "abs")
pub fn abs_int(n: Int) -> Int

// erlang:length/1
@external(erlang, "erlang", "length")
pub fn erlang_length(list: List(a)) -> Int

// erlang:integer_to_binary/1 — Erlang's version of int.to_string
@external(erlang, "erlang", "integer_to_binary")
pub fn int_to_string(n: Int) -> String

// erlang:binary_to_integer/1
@external(erlang, "erlang", "binary_to_integer")
pub fn string_to_int(s: String) -> Int

// erlang:system_time/1 for getting a timestamp
pub type TimeUnit {
  Second
  Millisecond
  Microsecond
  Nanosecond
}

@external(erlang, "erlang", "system_time")
pub fn system_time(unit: TimeUnit) -> Int

// erlang:node/0 — the current node name (returns an atom)
@external(erlang, "erlang", "node")
pub fn node() -> atom.Atom

// --- calling stdlib Erlang modules ---

// lists:max/1 — Erlang's lists module (not the same as gleam/list)
@external(erlang, "lists", "max")
pub fn lists_max(list: List(Int)) -> Int

// lists:min/1
@external(erlang, "lists", "min")
pub fn lists_min(list: List(Int)) -> Int

// math:sqrt/1 — Erlang's math module
@external(erlang, "math", "sqrt")
pub fn sqrt(n: Float) -> Float

// math:pi/0
@external(erlang, "math", "pi")
pub fn pi() -> Float

// math:log/1 — natural log
@external(erlang, "math", "log")
pub fn ln(n: Float) -> Float

// --- wrapping FFI in safe Gleam functions ---
// raw FFI panics on bad input — wrap it to return Result instead

pub fn safe_sqrt(n: Float) -> Result(Float, String) {
  case n <. 0.0 {
    True -> Error("cannot take sqrt of negative number")
    False -> Ok(sqrt(n))
  }
}

// --- @external for private helpers ---
// private @external: internal FFI not exposed to callers

@external(erlang, "erlang", "memory")
fn erlang_memory(key: atom.Atom) -> Int

pub fn total_memory_bytes() -> Int {
  erlang_memory(atom.create("total"))
}

pub fn main() {
  // BIF calls
  io.println(string.inspect(abs_int(-42)))
  // 42

  io.println(string.inspect(abs_int(7)))
  // 7

  io.println(string.inspect(erlang_length([1, 2, 3, 4, 5])))
  // 5

  io.println(int_to_string(12_345))
  // 12345

  io.println(string.inspect(string_to_int("9999")))
  // 9999

  // timestamp
  let ts = system_time(Millisecond)
  io.println("timestamp (ms): " <> string.inspect(ts))
  // timestamp (ms): 1750000000000  (actual time varies)

  // node name (returns an Atom — use string.inspect to display it)
  io.println("node: " <> string.inspect(node()))
  // node: atom.create("nonode@nohost")  (when not part of a distributed cluster)

  // Erlang stdlib
  io.println(string.inspect(lists_max([3, 1, 4, 1, 5, 9, 2, 6])))
  // 9

  io.println(string.inspect(lists_min([3, 1, 4, 1, 5, 9, 2, 6])))
  // 1

  io.println(string.inspect(sqrt(16.0)))
  // 4.0

  io.println(string.inspect(pi()))
  // 3.141592653589793

  io.println(string.inspect(ln(2.718281828)))
  // ~1.0

  // safe wrapper
  io.println(string.inspect(safe_sqrt(25.0)))
  // Ok(5.0)

  io.println(string.inspect(safe_sqrt(-1.0)))
  // Error("cannot take sqrt of negative number")

  // memory info via private FFI
  let mem = total_memory_bytes()
  io.println("vm memory > 0: " <> string.inspect(mem > 0))
  // vm memory > 0: True

  // process.self() is itself an @external under the hood
  let pid = process.self()
  io.println("self: " <> string.inspect(pid))
  // self: //erl(<0.82.0>)

  io.println("erlang ffi done")
  // erlang ffi done
}
