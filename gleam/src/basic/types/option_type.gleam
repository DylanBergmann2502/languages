import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string

// Option(a) = Some(a) | None
// replaces null entirely — if a value might be absent, the type says so

fn find_user(id: Int) -> Option(String) {
  case id {
    1 -> Some("Dylan")
    2 -> Some("Alice")
    _ -> None
  }
}

fn greet(user: Option(String)) -> String {
  case user {
    Some(name) -> "Hello, " <> name <> "!"
    None -> "User not found"
  }
}

pub fn main() {
  // Some wraps a value
  let name = Some("Dylan")
  io.println(string.inspect(name))
  // Some("Dylan")

  // None represents absence
  let nothing: Option(String) = None
  io.println(string.inspect(nothing))
  // None

  // pattern match to unwrap — use find_user which can return None at runtime
  case find_user(1) {
    Some(n) -> io.println("Got: " <> n)
    None -> io.println("Nothing")
  }
  // Got: Dylan

  // using Option in functions
  io.println(greet(find_user(1)))
  // Hello, Dylan!

  io.println(greet(find_user(99)))
  // User not found

  // option.unwrap — provide a default if None
  let val = option.unwrap(find_user(2), "anonymous")
  io.println(val)
  // Alice

  let val2 = option.unwrap(find_user(99), "anonymous")
  io.println(val2)
  // anonymous

  // option.map — transform the value inside Some, pass None through
  let upper =
    find_user(1)
    |> option.map(string.uppercase)
  io.println(string.inspect(upper))
  // Some("DYLAN")

  let upper_none =
    find_user(99)
    |> option.map(string.uppercase)
  io.println(string.inspect(upper_none))
  // None

  // option.is_some / option.is_none
  io.println(string.inspect(option.is_some(find_user(1))))
  // True

  io.println(string.inspect(option.is_none(find_user(99))))
  // True
}
