import gleam/io
import gleam/string

// custom types are like Rust enums / Elixir tagged unions
// each variant is a constructor — can hold data or be bare
pub type Direction {
  North
  South
  East
  West
}

pub type Shape {
  Circle(radius: Float)
  Rectangle(width: Float, height: Float)
  Triangle(base: Float, height: Float)
}

// types can be generic
pub type Pair(a, b) {
  Pair(first: a, second: b)
}

// a type with a single constructor acts like a struct
pub type User {
  User(name: String, age: Int, active: Bool)
}

fn area(shape: Shape) -> Float {
  case shape {
    Circle(r) -> 3.14159 *. r *. r
    Rectangle(w, h) -> w *. h
    Triangle(b, h) -> 0.5 *. b *. h
  }
}

pub fn main() {
  // bare constructors
  let dir = North
  io.println(string.inspect(dir))
  // North

  // constructors with data — use field names or positional
  let circle = Circle(radius: 5.0)
  io.println(string.inspect(circle))
  // Circle(radius: 5.0)

  let rect = Rectangle(width: 4.0, height: 3.0)
  io.println(string.inspect(rect))
  // Rectangle(width: 4.0, height: 3.0)

  // calling a function that pattern matches on the type
  io.println(string.inspect(area(circle)))
  // 78.53975

  io.println(string.inspect(area(rect)))
  // 12.0

  // generic pair
  let p = Pair(first: "hello", second: 42)
  io.println(string.inspect(p))
  // Pair(first: "hello", second: 42)

  // single-constructor type (struct-like)
  let user = User(name: "Dylan", age: 30, active: True)
  io.println(string.inspect(user))
  // User(name: "Dylan", age: 30, active: True)

  // access fields by name
  io.println(user.name)
  // Dylan

  io.println(string.inspect(user.age))
  // 30
}
