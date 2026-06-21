import gleam/http.{Delete, Get, Post}
import gleam/http/request
import gleam/http/response
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/string

// HTTP server concepts in Gleam using gleam_http types
// In a real app: add wisp + mist, wire up with wisp_mist.handler
//
// wisp requires rebar3 (Erlang build tool) for some transitive deps.
// This lesson shows the routing and response patterns — identical to wisp.
//
// To run a real server:
//   gleam add wisp mist
//   gleam run -m your_module   (with process.sleep_forever() at end)

// --- gleam_http types ---
// Request(body)  — HTTP request with method, path, headers, body
// Response(body) — HTTP response with status, headers, body
// gleam/http     — Method type: Get, Post, Put, Delete, Patch, Head, Options
// gleam/http/request — request builder and accessors
// gleam/http/response — response builder

// --- our data ---

pub type User {
  User(id: Int, name: String, role: String)
}

fn user_to_json(user: User) -> String {
  json.object([
    #("id", json.int(user.id)),
    #("name", json.string(user.name)),
    #("role", json.string(user.role)),
  ])
  |> json.to_string
}

// --- routing logic ---
// in wisp: case #(req.method, wisp.path_segments(req))
// here:    case #(req.method, request.path_segments(req))
// same pattern — wisp just adds middleware sugar on top

fn route(req: request.Request(String)) -> response.Response(String) {
  let segments = request.path_segments(req)
  case req.method, segments {
    Get, [] -> json_response("{\"status\":\"ok\",\"version\":\"1.0\"}", 200)

    Get, ["users"] -> {
      let users = [
        User(1, "Dylan", "admin"),
        User(2, "Alice", "member"),
        User(3, "Bob", "guest"),
      ]
      let body =
        json.array(users, fn(u) {
          json.object([
            #("id", json.int(u.id)),
            #("name", json.string(u.name)),
            #("role", json.string(u.role)),
          ])
        })
        |> json.to_string
      json_response(body, 200)
    }

    Get, ["users", id_str] ->
      case parse_id(id_str) {
        Error(_) -> error_response("id must be an integer", 400)
        Ok(id) ->
          case find_user(id) {
            Error(Nil) -> error_response("not found", 404)
            Ok(user) -> json_response(user_to_json(user), 200)
          }
      }

    Post, ["users"] -> json_response("{\"message\":\"created\",\"id\":4}", 201)

    Delete, ["users", _id] -> response.new(204) |> response.set_body("")

    _, _ -> error_response("not found", 404)
  }
}

// --- response helpers (mirroring wisp's API) ---

fn json_response(body: String, status: Int) -> response.Response(String) {
  response.new(status)
  |> response.set_header("content-type", "application/json")
  |> response.set_body(body)
}

fn error_response(msg: String, status: Int) -> response.Response(String) {
  response.new(status)
  |> response.set_header("content-type", "application/json")
  |> response.set_body("{\"error\":\"" <> msg <> "\"}")
}

fn parse_id(s: String) -> Result(Int, Nil) {
  int.parse(s)
}

fn find_user(id: Int) -> Result(User, Nil) {
  let users = [User(1, "Dylan", "admin"), User(2, "Alice", "member")]
  list.find(users, fn(u) { u.id == id })
}

// --- show routing in action ---

fn make_request(method: http.Method, path: String) -> request.Request(String) {
  request.new()
  |> request.set_method(method)
  |> request.set_path(path)
  |> request.set_body("")
}

pub fn main() {
  // simulate requests going through the router

  let reqs = [
    make_request(Get, "/"),
    make_request(Get, "/users"),
    make_request(Get, "/users/1"),
    make_request(Get, "/users/99"),
    make_request(Get, "/users/abc"),
    make_request(Post, "/users"),
    make_request(Delete, "/users/1"),
    make_request(Get, "/unknown"),
  ]

  list.each(reqs, fn(req) {
    let method = string.uppercase(http.method_to_string(req.method))
    let path = req.path
    let resp = route(req)
    io.println(method <> " " <> path <> " → " <> string.inspect(resp.status))
  })
  // GET / → 200
  // GET /users → 200
  // GET /users/1 → 200
  // GET /users/99 → 404
  // GET /users/abc → 400
  // POST /users → 201
  // DELETE /users/1 → 204
  // GET /unknown → 404

  io.println("")

  // inspect a full response
  let resp = route(make_request(Get, "/users/1"))
  io.println("status: " <> string.inspect(resp.status))
  // status: 200

  io.println("content-type: " <> get_header(resp, "content-type"))
  // content-type: application/json

  io.println("body: " <> resp.body)
  // body: {"id":1,"name":"Dylan","role":"admin"}

  // response construction with the builder API
  let custom =
    response.new(422)
    |> response.set_header("content-type", "application/json")
    |> response.set_header("x-request-id", "abc-123")
    |> response.set_body("{\"error\":\"unprocessable entity\"}")

  io.println("custom status: " <> string.inspect(custom.status))
  // custom status: 422

  io.println("header count: " <> string.inspect(list.length(custom.headers)))
  // header count: 2

  io.println("")
  io.println("to run a real HTTP server:")
  io.println("  gleam add wisp mist  (requires rebar3 for HTTP/2 deps)")
  io.println(
    "  wire up: handle_request |> wisp_mist.handler(key) |> mist.new |> mist.port(8080) |> mist.start_http",
  )
  // to run a real HTTP server:
  //   gleam add wisp mist  (requires rebar3 for HTTP/2 deps)
  //   wire up: handle_request |> wisp_mist.handler(key) |> mist.new |> ...
}

fn get_header(resp: response.Response(String), name: String) -> String {
  case list.find(resp.headers, fn(h) { h.0 == name }) {
    Ok(#(_, value)) -> value
    Error(Nil) -> "(not set)"
  }
}
