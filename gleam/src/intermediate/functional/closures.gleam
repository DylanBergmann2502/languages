import gleam/io
import gleam/list
import gleam/string

// a closure is an anonymous function that captures variables from its surrounding scope

fn make_adder(n: Int) -> fn(Int) -> Int {
  // the returned fn captures `n` from the outer scope
  fn(x) { x + n }
}

fn make_greeting(prefix: String) -> fn(String) -> String {
  fn(name) { prefix <> ", " <> name <> "!" }
}

// counter using a list to simulate state (Gleam is immutable — no mutable closures)
fn make_multiplier_pipeline(factor: Int) -> fn(List(Int)) -> List(Int) {
  fn(items) { list.map(items, fn(x) { x * factor }) }
}

pub fn main() {
  // basic closure — captures `n` from outer scope
  let add10 = make_adder(10)
  let add100 = make_adder(100)

  io.println(string.inspect(add10(5)))
  // 15

  io.println(string.inspect(add100(5)))
  // 105

  // each call to make_adder creates an independent closure
  io.println(string.inspect(add10(add100(1))))
  // 111  (1+100=101, 101+10=111)

  // closure capturing a string
  let say_hello = make_greeting("Hello")
  let say_hey = make_greeting("Hey")

  io.println(say_hello("Dylan"))
  // Hello, Dylan!

  io.println(say_hey("Alice"))
  // Hey, Alice!

  // inline closure capturing a local variable
  let threshold = 5
  let above_threshold = fn(n: Int) -> Bool { n > threshold }

  let filtered = list.filter([1, 3, 5, 7, 9], above_threshold)
  io.println(string.inspect(filtered))
  // [7, 9]

  // closure in a pipeline — captures `factor`
  let double_all = make_multiplier_pipeline(2)
  let triple_all = make_multiplier_pipeline(3)

  [1, 2, 3, 4, 5]
  |> double_all
  |> triple_all
  |> string.inspect
  |> io.println
  // [6, 12, 18, 24, 30]

  // closures capturing loop variables — each fn captures its own `i`
  let fns = list.map([1, 2, 3], fn(i) { fn(x: Int) -> Int { x + i } })
  let applied = list.map(fns, fn(f) { f(10) })
  io.println(string.inspect(applied))
  // [11, 12, 13]

  // unlike some languages, Gleam closures always capture by value (immutable)
  // there is no risk of a closure accidentally mutating captured state
  let base = 42
  let get_base = fn() { base }
  // base cannot be reassigned — the closure always sees 42
  io.println(string.inspect(get_base()))
  // 42
}
