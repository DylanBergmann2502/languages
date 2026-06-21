import gleam/dict.{type Dict}
import gleam/io
import gleam/option.{type Option, None, Some}
import gleam/string

// type aliases give a name to an existing type — no new type is created
// purely for readability, the compiler treats them as the same underlying type

type Name =
  String

type Age =
  Int

type Score =
  Float

// aliases for complex types make signatures readable
type UserRecord =
  #(Name, Age)

type Scores =
  Dict(String, Score)

type MaybeString =
  Option(String)

// a function using aliases — cleaner signature
fn describe_user(user: UserRecord) -> String {
  let #(name, age) = user
  name <> " is " <> string.inspect(age) <> " years old"
}

fn top_scorer(scores: Scores) -> MaybeString {
  // find the key with the highest score
  dict.fold(scores, None, fn(best, name, score) {
    case best {
      Some(#(_, best_score)) if best_score >=. score -> best
      _ -> Some(#(name, score))
    }
  })
  |> option.map(fn(pair) { pair.0 })
}

pub fn main() {
  // alias is transparent — same type, just a new name
  let name: Name = "Dylan"
  let age: Age = 30
  io.println(name)
  // Dylan

  io.println(string.inspect(age))
  // 30

  // using aliased tuple type
  let user: UserRecord = #("Alice", 25)
  io.println(describe_user(user))
  // Alice is 25 years old

  // using aliased Dict type
  let scores: Scores =
    dict.from_list([#("Alice", 95.0), #("Bob", 87.5), #("Charlie", 91.0)])

  io.println(string.inspect(top_scorer(scores)))
  // Some("Alice")

  // Score alias works exactly like Float
  let s: Score = 100.0
  io.println(string.inspect(s))
  // 100.0
}
