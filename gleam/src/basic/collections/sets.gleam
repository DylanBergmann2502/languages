import gleam/io
import gleam/set.{type Set}
import gleam/string

pub fn main() {
  // Set(a) — unordered collection of unique values
  // create from a list — duplicates are dropped
  let a: Set(Int) = set.from_list([1, 2, 3, 2, 1])
  // duplicates dropped — size is 3 not 5
  io.println(string.inspect(set.size(a)))
  // 3

  // set.to_list to see the contents (inspect on a whole Set shows internal BEAM repr)
  io.println(string.inspect(set.to_list(a)))
  // [1, 2, 3]  (order may vary)

  // set.new — empty set
  let empty: Set(Int) = set.new()
  io.println(string.inspect(set.size(empty)))
  // 0

  // set.insert — returns a new set
  let b = set.insert(a, 4)
  io.println(string.inspect(set.size(b)))
  // 4

  io.println(string.inspect(set.contains(b, 4)))
  // True

  // set.delete — returns a new set without the value
  let c = set.delete(a, 2)
  io.println(string.inspect(set.contains(c, 2)))
  // False

  io.println(string.inspect(set.to_list(c)))
  // [1, 3]  (order may vary)

  // set.contains
  io.println(string.inspect(set.contains(a, 3)))
  // True

  io.println(string.inspect(set.contains(a, 99)))
  // False

  // set.size
  io.println(string.inspect(set.size(a)))
  // 3

  // set operations
  let x = set.from_list([1, 2, 3, 4])
  let y = set.from_list([3, 4, 5, 6])

  // union — all elements from both
  let u = set.union(x, y)
  io.println(string.inspect(set.size(u)))
  // 6

  // intersection — only elements in both
  let i = set.intersection(x, y)
  io.println(string.inspect(set.to_list(i)))
  // [3, 4]  (order may vary)

  // difference — elements in x but not y
  let d = set.difference(x, y)
  io.println(string.inspect(set.to_list(d)))
  // [1, 2]  (order may vary)

  // set.to_list — convert back (order not guaranteed)
  let nums = set.from_list([3, 1, 2])
  io.println(string.inspect(set.to_list(nums)))
  // [1, 2, 3]  (order may vary)

  // set.map — transform every element (returns a new Set)
  let doubled = set.map(a, fn(n) { n * 2 })
  io.println(string.inspect(set.to_list(doubled)))
  // [2, 4, 6]  (order may vary)

  // set.filter — keep elements matching predicate
  let evens = set.filter(a, fn(n) { n % 2 == 0 })
  io.println(string.inspect(set.to_list(evens)))
  // [2]

  // set.fold — reduce to a single value
  let sum = set.fold(a, 0, fn(acc, n) { acc + n })
  io.println(string.inspect(sum))
  // 6
}
