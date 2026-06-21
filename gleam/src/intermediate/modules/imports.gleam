// qualified import — access via module.function
import gleam/io
import gleam/list

// unqualified import — bring specific names directly into scope
import gleam/option.{type Option, None, Some}

// aliased import — rename the module locally
// you cannot import the same module twice, so alias replaces the plain import
import gleam/string as str

// import a type only (no functions needed from this module in main)
import gleam/dict.{type Dict}
import gleam/result

pub fn main() {
  // qualified via alias — str is now the name for gleam/string
  io.println(str.uppercase("hello"))
  // HELLO

  io.println(str.reverse("gleam"))
  // maelg

  io.println(str.inspect(str.length("hello")))
  // 5

  // unqualified — imported names used directly without module prefix
  let x: Option(Int) = Some(42)
  io.println(str.inspect(x))
  // Some(42)

  let y: Option(Int) = None
  io.println(str.inspect(y))
  // None

  // renaming an imported function with `as`
  // useful to avoid clashing with a local name
  let result_try = result.try
  let chained =
    Ok(5)
    |> result_try(fn(n) {
      case n > 0 {
        True -> Ok(n * 2)
        False -> Error("negative")
      }
    })
  io.println(str.inspect(chained))
  // Ok(10)

  // importing a type only — annotate without pulling in every function
  let scores: Dict(String, Int) = dict.from_list([#("Alice", 95), #("Bob", 87)])
  io.println(str.inspect(dict.get(scores, "Alice")))
  // Ok(95)

  // Ok and Error are globally available — no import needed
  let r: Result(Int, String) = Ok(10)
  io.println(str.inspect(r))
  // Ok(10)

  // list functions used qualified
  let doubled = list.map([1, 2, 3], fn(n) { n * 2 })
  io.println(str.inspect(doubled))
  // [2, 4, 6]

  // common unqualified import patterns you'll see in real Gleam code:
  // import gleam/option.{type Option, Some, None}
  // import gleam/list.{map, filter, fold}
  // import gleam/io.{println}  -- then just println("hi")
  io.println("imports done")
  // imports done
}
