import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

// a small CLI tool: reads argv, dispatches commands, handles errors
// run with args:  gleam run -m advanced/project/cli_tool -- help
//                 gleam run -m advanced/project/cli_tool -- add 3 5
//                 gleam run -m advanced/project/cli_tool -- greet Dylan

// get command-line arguments via Erlang's init module
// init:get_plain_arguments() returns the args after the module name
@external(erlang, "init", "get_plain_arguments")
fn get_args() -> List(String)

// --- command types ---

pub type Command {
  Help
  Greet(name: String)
  Add(a: Int, b: Int)
  Unknown(String)
}

// --- parsing ---

fn parse_command(args: List(String)) -> Command {
  case args {
    [] -> Help
    ["help", ..] -> Help
    ["greet", name, ..] -> Greet(name)
    ["add", a_str, b_str, ..] ->
      case int.parse(a_str), int.parse(b_str) {
        Ok(a), Ok(b) -> Add(a, b)
        _, _ -> Unknown("add requires two integers")
      }
    [cmd, ..] -> Unknown(cmd)
  }
}

// --- running commands ---

fn run_command(cmd: Command) -> String {
  case cmd {
    Help ->
      string.join(
        [
          "usage:",
          "  help          — show this message",
          "  greet <name>  — greet someone",
          "  add <a> <b>   — add two integers",
        ],
        "\n",
      )
    Greet(name) -> "Hello, " <> name <> "!"
    Add(a, b) ->
      int.to_string(a)
      <> " + "
      <> int.to_string(b)
      <> " = "
      <> int.to_string(a + b)
    Unknown(cmd) -> "unknown command: " <> cmd <> "\nrun with 'help' for usage"
  }
}

// --- error handling pipeline ---

pub type CliError {
  ParseError(String)
  RuntimeError(String)
}

fn validate_greet(name: String) -> Result(String, CliError) {
  case string.length(string.trim(name)) {
    0 -> Error(ParseError("name cannot be empty"))
    _ -> Ok("Hello, " <> name <> "!")
  }
}

fn validate_add(a_str: String, b_str: String) -> Result(Int, CliError) {
  use a <- result.try(
    int.parse(a_str)
    |> result.map_error(fn(_) {
      ParseError("'" <> a_str <> "' is not a number")
    }),
  )
  use b <- result.try(
    int.parse(b_str)
    |> result.map_error(fn(_) {
      ParseError("'" <> b_str <> "' is not a number")
    }),
  )
  Ok(a + b)
}

pub fn main() {
  // dispatch on real argv (pass args after --  in `gleam run`)
  let args = get_args()
  let output = parse_command(args) |> run_command
  io.println(output)

  io.println("")

  // --- demo the routing logic with simulated inputs ---
  let demos = [
    ["help"],
    ["greet", "Dylan"],
    ["add", "10", "32"],
    ["add", "not", "numbers"],
    ["unknown-cmd"],
  ]

  list.each(demos, fn(demo_args) {
    let cmd = parse_command(demo_args)
    let result = run_command(cmd)
    io.println("> " <> string.join(demo_args, " "))
    io.println(result)
    io.println("")
  })
  // > help
  // usage:
  //   help          — show this message
  //   greet <name>  — greet someone
  //   add <a> <b>   — add two integers
  //
  // > greet Dylan
  // Hello, Dylan!
  //
  // > add 10 32
  // 10 + 32 = 42
  //
  // > add not numbers
  // unknown command: not
  // ...
  //
  // > unknown-cmd
  // unknown command: unknown-cmd

  // --- validated pipeline demo ---
  io.println("--- validated ---")

  io.println(string.inspect(validate_greet("Dylan")))
  // Ok("Hello, Dylan!")

  io.println(string.inspect(validate_greet("")))
  // Error(ParseError("name cannot be empty"))

  io.println(string.inspect(validate_add("10", "32")))
  // Ok(42)

  io.println(string.inspect(validate_add("ten", "32")))
  // Error(ParseError("'ten' is not a number"))
}
