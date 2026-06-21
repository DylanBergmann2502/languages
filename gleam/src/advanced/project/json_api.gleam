import gleam/dynamic/decode
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import gleam/string

// gleam_json: encode Gleam values to JSON strings, decode JSON strings to Gleam values
// json module has two sides: json.* for encoding, decode.* for decoding
// you know this pattern from Rust (serde) and Go (encoding/json)

// --- types ---

pub type Role {
  Admin
  Member
  Guest
}

pub type User {
  User(id: Int, name: String, email: String, role: Role, active: Bool)
}

pub type Post {
  Post(id: Int, title: String, body: String, author_id: Int, tags: List(String))
}

// --- encoding: Gleam → JSON ---

fn role_to_json(role: Role) -> json.Json {
  case role {
    Admin -> json.string("admin")
    Member -> json.string("member")
    Guest -> json.string("guest")
  }
}

fn user_to_json(user: User) -> json.Json {
  json.object([
    #("id", json.int(user.id)),
    #("name", json.string(user.name)),
    #("email", json.string(user.email)),
    #("role", role_to_json(user.role)),
    #("active", json.bool(user.active)),
  ])
}

fn post_to_json(post: Post) -> json.Json {
  json.object([
    #("id", json.int(post.id)),
    #("title", json.string(post.title)),
    #("body", json.string(post.body)),
    #("author_id", json.int(post.author_id)),
    #("tags", json.array(post.tags, json.string)),
  ])
}

// --- decoding: JSON → Gleam ---
// decode.* pipelines field-by-field; decoder is a value, not a function

fn role_decoder() -> decode.Decoder(Role) {
  use raw <- decode.then(decode.string)
  case raw {
    "admin" -> decode.success(Admin)
    "member" -> decode.success(Member)
    "guest" -> decode.success(Guest)
    _ -> decode.failure(Guest, "Role")
  }
}

fn user_decoder() -> decode.Decoder(User) {
  use id <- decode.field("id", decode.int)
  use name <- decode.field("name", decode.string)
  use email <- decode.field("email", decode.string)
  use role <- decode.field("role", role_decoder())
  use active <- decode.field("active", decode.bool)
  decode.success(User(id:, name:, email:, role:, active:))
}

pub fn main() {
  // --- encoding ---

  let user =
    User(
      id: 1,
      name: "Dylan",
      email: "dylan@example.com",
      role: Admin,
      active: True,
    )
  let user_json = user_to_json(user) |> json.to_string
  io.println(user_json)
  // {"id":1,"name":"Dylan","email":"dylan@example.com","role":"admin","active":true}

  let post =
    Post(
      id: 42,
      title: "Learning Gleam",
      body: "Gleam is a statically typed language on the BEAM.",
      author_id: 1,
      tags: ["gleam", "erlang", "functional"],
    )
  let post_json = post_to_json(post) |> json.to_string
  io.println(post_json)
  // {"id":42,"title":"Learning Gleam","body":"...","author_id":1,"tags":["gleam","erlang","functional"]}

  // encode a list of users
  let users = [
    User(1, "Dylan", "dylan@example.com", Admin, True),
    User(2, "Alice", "alice@example.com", Member, True),
    User(3, "Bob", "bob@example.com", Guest, False),
  ]
  let users_json = json.array(users, user_to_json) |> json.to_string
  io.println(string.slice(users_json, 0, 40) <> "...")
  // [{"id":1,"name":"Dylan","email":"dylan...

  // nullable — Option maps to null
  let maybe_name: option.Option(String) = Some("Dylan")
  io.println(json.nullable(maybe_name, json.string) |> json.to_string)
  // "Dylan"

  let no_name: option.Option(String) = None
  io.println(json.nullable(no_name, json.string) |> json.to_string)
  // null

  // primitives
  io.println(json.int(42) |> json.to_string)
  // 42
  io.println(json.float(3.14) |> json.to_string)
  // 3.14
  io.println(json.bool(True) |> json.to_string)
  // true
  io.println(json.null() |> json.to_string)
  // null
  io.println(json.string("hello") |> json.to_string)
  // "hello"

  // --- decoding ---

  let raw_user =
    "{\"id\":1,\"name\":\"Dylan\",\"email\":\"dylan@example.com\",\"role\":\"admin\",\"active\":true}"

  let decoded = json.parse(raw_user, user_decoder())
  io.println(string.inspect(decoded))
  // Ok(User(1, "Dylan", "dylan@example.com", Admin, True))

  // decode fails gracefully on bad input
  let bad_json = "{\"id\":\"not-a-number\",\"name\":\"Dylan\"}"
  let bad_result = json.parse(bad_json, user_decoder())
  io.println(string.inspect(bad_result))
  // Error(UnableToDecode([...]))

  // decode a list
  let raw_list =
    "[{\"id\":1,\"name\":\"Dylan\",\"email\":\"d@e.com\",\"role\":\"admin\",\"active\":true}]"
  let decoded_list = json.parse(raw_list, decode.list(user_decoder()))
  case decoded_list {
    Ok(us) ->
      io.println("decoded " <> string.inspect(list.length(us)) <> " users")
    Error(_) -> io.println("decode failed")
  }
  // decoded 1 users

  // decode with optional field — use decode.optional
  let raw_partial = "{\"id\":1,\"name\":\"Dylan\"}"
  let name_decoder = {
    use name <- decode.field("name", decode.optional(decode.string))
    decode.success(name)
  }
  let name_result = json.parse(raw_partial, name_decoder)
  io.println(string.inspect(name_result))
  // Ok(Some("Dylan"))

  io.println("json api done")
  // json api done
}
