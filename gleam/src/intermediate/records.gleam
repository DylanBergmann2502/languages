import gleam/io
import gleam/string

// in Gleam, a custom type with a single constructor acts as a record
// fields are accessed with dot notation and updated with the .. spread syntax

pub type User {
  User(name: String, age: Int, email: String, active: Bool)
}

pub type Point {
  Point(x: Float, y: Float)
}

pub type Config {
  Config(host: String, port: Int, debug: Bool, max_connections: Int)
}

fn default_config() -> Config {
  Config(host: "localhost", port: 8080, debug: False, max_connections: 100)
}

fn move_point(p: Point, dx: Float, dy: Float) -> Point {
  Point(x: p.x +. dx, y: p.y +. dy)
}

pub fn main() {
  // creating a record
  let user =
    User(name: "Dylan", age: 30, email: "dylan@example.com", active: True)
  io.println(string.inspect(user))
  // User("Dylan", 30, "dylan@example.com", True)

  // field access with dot notation
  io.println(user.name)
  // Dylan

  io.println(string.inspect(user.age))
  // 30

  io.println(string.inspect(user.active))
  // True

  // .. spread update — create a new record with some fields changed
  // all other fields are copied from the original
  let older_user = User(..user, age: 31)
  io.println(string.inspect(older_user))
  // User("Dylan", 31, "dylan@example.com", True)

  // original is unchanged — everything is immutable
  io.println(string.inspect(user.age))
  // 30

  // update multiple fields at once
  let deactivated = User(..user, active: False, email: "")
  io.println(string.inspect(deactivated))
  // User("Dylan", 30, "", False)

  // spread update in a function
  let p = Point(x: 1.0, y: 2.0)
  let p2 = move_point(p, 3.0, -1.0)
  io.println(string.inspect(p2))
  // Point(4.0, 1.0)

  // config pattern — start from defaults, override specific fields
  let prod_config =
    Config(..default_config(), host: "prod.example.com", port: 443)
  io.println(prod_config.host)
  // prod.example.com

  io.println(string.inspect(prod_config.port))
  // 443

  io.println(string.inspect(prod_config.debug))
  // False  (inherited from default)

  io.println(string.inspect(prod_config.max_connections))
  // 100  (inherited from default)

  // pattern matching on records — destructure fields by name
  let User(name: n, age: a, ..) = user
  io.println(n <> " is " <> string.inspect(a))
  // Dylan is 30

  // .. in patterns means "ignore the rest of the fields"
  let Point(x: x, ..) = p2
  io.println(string.inspect(x))
  // 4.0

  // case with record patterns
  case user {
    User(active: False, ..) -> io.println("inactive user")
    User(name: n, age: a, ..) if a >= 18 -> io.println(n <> " is an adult")
    User(name: n, ..) -> io.println(n <> " is underage")
  }
  // Dylan is an adult
}
