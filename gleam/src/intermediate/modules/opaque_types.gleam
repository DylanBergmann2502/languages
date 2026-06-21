import gleam/io
import gleam/string

// opaque type — the type is visible but its internals are hidden
// outside modules cannot construct it directly or access its fields
// they can only use the functions you expose
//
// this is how you enforce invariants: e.g. an Email that is always valid,
// a NonEmptyList that is always non-empty

// --- example 1: Email that must pass validation ---

pub opaque type Email {
  Email(address: String)
}

pub fn parse_email(s: String) -> Result(Email, String) {
  case string.contains(s, "@") {
    False -> Error("invalid email: " <> s)
    True -> Ok(Email(address: s))
  }
}

pub fn email_address(e: Email) -> String {
  e.address
}

// --- example 2: NonEmptyList that can never be empty ---

pub opaque type NonEmptyList(a) {
  NonEmptyList(head: a, tail: List(a))
}

pub fn non_empty(head: a, tail: List(a)) -> NonEmptyList(a) {
  NonEmptyList(head: head, tail: tail)
}

pub fn nel_head(nel: NonEmptyList(a)) -> a {
  nel.head
}

pub fn nel_to_list(nel: NonEmptyList(a)) -> List(a) {
  [nel.head, ..nel.tail]
}

// --- example 3: Counter that can only go up ---

pub opaque type Counter {
  Counter(value: Int)
}

pub fn counter_new() -> Counter {
  Counter(value: 0)
}

pub fn counter_increment(c: Counter) -> Counter {
  Counter(value: c.value + 1)
}

pub fn counter_value(c: Counter) -> Int {
  c.value
}

pub fn main() {
  // Email — can only be created via parse_email
  // Email(address: "x") would be a compile error from outside this module
  // but we ARE in this module, so we can show both sides

  let good = parse_email("dylan@example.com")
  io.println(string.inspect(good))
  // Ok(Email("dylan@example.com"))

  let bad = parse_email("not-an-email")
  io.println(string.inspect(bad))
  // Error("invalid email: not-an-email")

  case parse_email("alice@gleam.run") {
    Ok(email) -> io.println("valid: " <> email_address(email))
    Error(e) -> io.println(e)
  }
  // valid: alice@gleam.run

  // NonEmptyList — guaranteed to have at least one element at the type level
  let nel = non_empty(1, [2, 3, 4])
  io.println(string.inspect(nel_head(nel)))
  // 1

  io.println(string.inspect(nel_to_list(nel)))
  // [1, 2, 3, 4]

  // Counter — can only go up, value cannot be set arbitrarily
  let c = counter_new()
  io.println(string.inspect(counter_value(c)))
  // 0

  let c2 = c |> counter_increment |> counter_increment |> counter_increment
  io.println(string.inspect(counter_value(c2)))
  // 3

  // the key insight:
  // opaque lets you make illegal states unrepresentable at the type level
  // callers work with the type but cannot bypass your invariants
}
