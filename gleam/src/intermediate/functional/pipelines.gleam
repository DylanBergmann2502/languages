import gleam/io
import gleam/list
import gleam/string

// |> passes the result of the left side as the FIRST argument to the right side
// you know this from Elixir — it works identically

fn double(n: Int) -> Int {
  n * 2
}

fn add(a: Int, b: Int) -> Int {
  a + b
}

pub fn main() {
  // without pipe — hard to read, inside-out
  io.println(
    string.inspect(
      list.map(list.filter([1, 2, 3, 4, 5], fn(n) { n > 2 }), fn(n) { n * 2 }),
    ),
  )
  // [6, 8, 10]

  // with pipe — reads left to right, top to bottom
  let result =
    [1, 2, 3, 4, 5]
    |> list.filter(fn(n) { n > 2 })
    |> list.map(fn(n) { n * 2 })
  io.println(string.inspect(result))
  // [6, 8, 10]

  // pipe into a single-arg function
  let r =
    "  hello gleam  "
    |> string.trim
    |> string.uppercase
  io.println(r)
  // HELLO GLEAM

  // pipe into a named function
  let r2 = 5 |> double
  io.println(string.inspect(r2))
  // 10

  // when the function takes multiple args, pipe fills the FIRST arg
  // use a partial capture (_) or anonymous fn for other positions
  let r3 = 10 |> add(5)
  io.println(string.inspect(r3))
  // 15

  // or use an anonymous fn wrapper
  let r4 = 10 |> fn(x) { add(x, 5) }
  io.println(string.inspect(r4))
  // 15

  // real-world style: process a list of names
  let names = ["alice", "bob", "charlie", "dan"]
  let result2 =
    names
    |> list.filter(fn(n) { string.length(n) > 3 })
    |> list.map(string.capitalise)
    |> string.join(", ")
  io.println(result2)
  // Alice, Charlie

  // pipe into io.println directly — useful for quick debug
  "piped straight to println"
  |> io.println
  // piped straight to println
}
