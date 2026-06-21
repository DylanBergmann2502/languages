import gleam/io
import gleam/result
import gleam/string

// custom error types — use a custom_type for structured errors
// this is the idiomatic Gleam approach instead of plain String errors

pub type ParseError {
  EmptyInput
  InvalidCharacter(at: Int, char: String)
  TooLong(max: Int, got: Int)
}

pub type DatabaseError {
  NotFound(id: Int)
  ConnectionFailed(reason: String)
  QueryFailed(query: String, reason: String)
}

// a higher-level error type that wraps domain-specific errors
pub type AppError {
  ParseErr(ParseError)
  DbErr(DatabaseError)
  Unexpected(String)
}

fn parse_username(s: String) -> Result(String, ParseError) {
  case string.length(s) {
    0 -> Error(EmptyInput)
    n if n > 20 -> Error(TooLong(max: 20, got: n))
    _ -> Ok(s)
  }
}

fn fetch_user(id: Int) -> Result(String, DatabaseError) {
  case id {
    1 -> Ok("Dylan")
    2 -> Ok("Alice")
    _ -> Error(NotFound(id))
  }
}

// wrapping domain errors into the unified AppError
fn get_profile(id: Int) -> Result(String, AppError) {
  fetch_user(id)
  |> result.map_error(DbErr)
}

fn register(username: String) -> Result(String, AppError) {
  parse_username(username)
  |> result.map_error(ParseErr)
  |> result.map(fn(name) { "registered: " <> name })
}

// pattern match on structured errors to give specific messages
fn describe_error(err: AppError) -> String {
  case err {
    ParseErr(EmptyInput) -> "username cannot be empty"
    ParseErr(TooLong(max, got)) ->
      "username too long: max "
      <> string.inspect(max)
      <> ", got "
      <> string.inspect(got)
    ParseErr(InvalidCharacter(at, char)) ->
      "invalid character '" <> char <> "' at position " <> string.inspect(at)
    DbErr(NotFound(id)) -> "user " <> string.inspect(id) <> " not found"
    DbErr(ConnectionFailed(reason)) -> "connection failed: " <> reason
    DbErr(QueryFailed(query, reason)) ->
      "query failed [" <> query <> "]: " <> reason
    Unexpected(msg) -> "unexpected error: " <> msg
  }
}

pub fn main() {
  // structured errors give you pattern matching on error shape
  io.println(string.inspect(parse_username("Dylan")))
  // Ok("Dylan")

  io.println(string.inspect(parse_username("")))
  // Error(EmptyInput)

  io.println(string.inspect(parse_username("this_username_is_way_too_long_ok")))
  // Error(TooLong(20, 32))

  // database errors
  io.println(string.inspect(fetch_user(1)))
  // Ok("Dylan")

  io.println(string.inspect(fetch_user(99)))
  // Error(NotFound(99))

  // unified AppError — errors from different sources in one type
  io.println(string.inspect(get_profile(1)))
  // Ok("Dylan")

  io.println(string.inspect(get_profile(99)))
  // Error(DbErr(NotFound(99)))

  io.println(string.inspect(register("Alice")))
  // Ok("registered: Alice")

  io.println(string.inspect(register("")))
  // Error(ParseErr(EmptyInput))

  // human-readable messages via pattern matching
  case register("") {
    Ok(msg) -> io.println(msg)
    Error(e) -> io.println(describe_error(e))
  }
  // username cannot be empty

  case get_profile(42) {
    Ok(name) -> io.println("found: " <> name)
    Error(e) -> io.println(describe_error(e))
  }
  // user 42 not found

  // the key advantage over String errors:
  // the compiler forces you to handle every error variant
  // you cannot forget a case — unlike string matching where a typo compiles fine
}
