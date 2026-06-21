import gleam/io
import gleam/list
import gleam/string

// functions are first-class values in Gleam
// you can pass them as arguments, return them, store them in variables

fn apply(f: fn(Int) -> Int, x: Int) -> Int {
  f(x)
}

fn apply2(f: fn(Int, Int) -> Int, a: Int, b: Int) -> Int {
  f(a, b)
}

// a function that returns a function
fn multiplier(factor: Int) -> fn(Int) -> Int {
  fn(x) { x * factor }
}

// a function that takes a list transformer and applies it
fn transform(items: List(Int), f: fn(List(Int)) -> List(Int)) -> List(Int) {
  f(items)
}

pub fn main() {
  // passing a named function as an argument
  let double = fn(n: Int) -> Int { n * 2 }
  io.println(string.inspect(apply(double, 5)))
  // 10

  // passing an anonymous function inline
  io.println(string.inspect(apply(fn(n) { n + 100 }, 5)))
  // 105

  // function capture with _ — partially apply an argument
  let add = fn(a: Int, b: Int) -> Int { a + b }
  let add5 = add(5, _)
  io.println(string.inspect(add5(3)))
  // 8

  io.println(string.inspect(add5(10)))
  // 15

  // function that returns a function
  let triple = multiplier(3)
  io.println(string.inspect(triple(4)))
  // 12

  let by_ten = multiplier(10)
  io.println(string.inspect(by_ten(7)))
  // 70

  // storing functions in a list and applying them
  let ops = [fn(n: Int) { n + 1 }, fn(n) { n * 2 }, fn(n) { n - 3 }]
  let results = list.map(ops, fn(f) { f(10) })
  io.println(string.inspect(results))
  // [11, 20, 7]

  // composing functions manually
  let double_then_add5 = fn(n: Int) { double(n) |> add5 }
  io.println(string.inspect(double_then_add5(4)))
  // 13  (4*2=8, 8+5=13)

  // passing a stdlib function directly
  io.println(string.inspect(apply2(fn(a, b) { a * b }, 6, 7)))
  // 42

  // using transform — passing list.reverse as a value
  let reversed = transform([1, 2, 3, 4], list.reverse)
  io.println(string.inspect(reversed))
  // [4, 3, 2, 1]

  // fn types in type annotations: fn(ArgType) -> ReturnType
  // fn(Int, Int) -> Int  means a function taking two Ints and returning an Int
  let ops2: List(fn(Int) -> Int) = [double, add5, triple]
  let pipeline_result = list.fold(ops2, 2, fn(acc, f) { f(acc) })
  io.println(string.inspect(pipeline_result))
  // triple(add5(double(2))) = triple(add5(4)) = triple(9) = 27
}
