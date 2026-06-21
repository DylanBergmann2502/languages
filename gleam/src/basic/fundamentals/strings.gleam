import gleam/io
import gleam/string

pub fn main() {
  let s = "Hello, Gleam!"

  // length in graphemes (Unicode-aware)
  io.println(string.inspect(string.length(s)))
  // 13

  // concatenation with <>
  io.println("Hello" <> ", " <> "World!")
  // Hello, World!

  // uppercase / lowercase
  io.println(string.uppercase(s))
  // HELLO, GLEAM!

  io.println(string.lowercase(s))
  // hello, gleam!

  // check contains
  io.println(string.inspect(string.contains(s, "Gleam")))
  // True

  // starts_with / ends_with
  io.println(string.inspect(string.starts_with(s, "Hello")))
  // True

  io.println(string.inspect(string.ends_with(s, "!")))
  // True

  // trim whitespace
  io.println(string.trim("  hello  "))
  // hello

  io.println(string.trim_start("  hello  "))
  // hello

  io.println(string.trim_end("  hello  "))
  //   hello

  // replace
  io.println(string.replace(s, "Gleam", "World"))
  // Hello, World!

  // split into a list
  io.println(string.inspect(string.split("a,b,c", ",")))
  // ["a", "b", "c"]

  // join a list into a string
  io.println(string.join(["a", "b", "c"], "-"))
  // a-b-c

  // repeat
  io.println(string.repeat("ha", 3))
  // hahaha

  // reverse
  io.println(string.reverse("Gleam"))
  // maelG

  // convert other types to string with string.inspect
  io.println(string.inspect(42))
  // 42

  io.println(string.inspect(True))
  // True

  io.println(string.inspect([1, 2, 3]))
  // [1, 2, 3]

  // slice — byte-based, use carefully with Unicode
  io.println(string.slice(s, 0, 5))
  // Hello
}
