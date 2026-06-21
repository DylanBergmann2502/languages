import gleam/io
import gleam/string

// basic function — fn name(param: Type) -> ReturnType
fn add(a: Int, b: Int) -> Int {
  a + b
  // last expression is the return value, no return keyword
}

// labelled arguments — caller names the argument
fn greet(name name: String, greeting greeting: String) -> String {
  greeting <> ", " <> name <> "!"
}

// labelled args with different internal/external names
fn divide(dividend a: Int, divisor b: Int) -> Int {
  a / b
}

// function with no meaningful return — returns Nil implicitly
fn say(msg: String) -> Nil {
  io.println(msg)
}

pub fn main() {
  // calling a basic function
  io.println(string.inspect(add(3, 4)))
  // 7

  // labelled args — order doesn't matter when using labels
  io.println(greet(name: "Dylan", greeting: "Hey"))
  // Hey, Dylan!

  io.println(greet(greeting: "Hello", name: "World"))
  // Hello, World!

  // using the external label name
  io.println(string.inspect(divide(dividend: 10, divisor: 3)))
  // 3

  say("side effect only")
  // side effect only

  // anonymous functions — fn(params) { body }
  let double = fn(x: Int) -> Int { x * 2 }
  io.println(string.inspect(double(5)))
  // 10

  // anonymous functions can be passed around
  let apply = fn(f: fn(Int) -> Int, x: Int) -> Int { f(x) }
  io.println(string.inspect(apply(double, 7)))
  // 14

  // capturing a function reference with _ shorthand
  let add_ten = add(10, _)
  io.println(string.inspect(add_ten(5)))
  // 15
}
