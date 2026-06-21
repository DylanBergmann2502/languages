import gleam/io
import gleam/list
import gleam/string

// Gleam has no loops — recursion is the fundamental iteration mechanism
// list.map/filter/fold cover most cases; write your own when needed

// simple recursion — not tail recursive
fn factorial(n: Int) -> Int {
  case n {
    0 -> 1
    _ -> n * factorial(n - 1)
  }
}

// tail recursive — the recursive call is the LAST thing in every branch
// the compiler optimises this into a loop (no stack overflow)
fn factorial_tail(n: Int, acc: Int) -> Int {
  case n {
    0 -> acc
    _ -> factorial_tail(n - 1, n * acc)
  }
}

// public wrapper with a clean signature
fn factorial_safe(n: Int) -> Int {
  factorial_tail(n, 1)
}

// classic recursive sum
fn sum(nums: List(Int)) -> Int {
  case nums {
    [] -> 0
    [head, ..tail] -> head + sum(tail)
  }
}

// tail-recursive sum
fn sum_tail(nums: List(Int), acc: Int) -> Int {
  case nums {
    [] -> acc
    [head, ..tail] -> sum_tail(tail, acc + head)
  }
}

// build a list recursively — range from lo to hi inclusive
fn range(lo: Int, hi: Int) -> List(Int) {
  case lo > hi {
    True -> []
    False -> [lo, ..range(lo + 1, hi)]
  }
}

// flatten a nested list recursively
fn flatten(lists: List(List(Int))) -> List(Int) {
  case lists {
    [] -> []
    [head, ..tail] -> list.append(head, flatten(tail))
  }
}

// map implemented via recursion (to show how list.map works underneath)
fn my_map(items: List(Int), f: fn(Int) -> Int) -> List(Int) {
  case items {
    [] -> []
    [head, ..tail] -> [f(head), ..my_map(tail, f)]
  }
}

pub fn main() {
  io.println(string.inspect(factorial(5)))
  // 120

  io.println(string.inspect(factorial_safe(10)))
  // 3628800

  io.println(string.inspect(sum([1, 2, 3, 4, 5])))
  // 15

  io.println(string.inspect(sum_tail([1, 2, 3, 4, 5], 0)))
  // 15

  io.println(string.inspect(range(1, 5)))
  // [1, 2, 3, 4, 5]

  io.println(string.inspect(flatten([[1, 2], [3, 4], [5]])))
  // [1, 2, 3, 4, 5]

  io.println(string.inspect(my_map([1, 2, 3, 4], fn(n) { n * n })))
  // [1, 4, 9, 16]

  // for most real code, prefer list.fold / list.map over hand-written recursion
  // hand-written recursion is useful when the shape of the data is irregular
  let result =
    range(1, 10)
    |> list.filter(fn(n) { n % 2 == 0 })
    |> list.map(fn(n) { n * n })
  io.println(string.inspect(result))
  // [4, 16, 36, 64, 100]
}
