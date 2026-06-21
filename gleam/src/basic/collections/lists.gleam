import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  // List(a) — singly linked list, all elements same type, immutable
  let nums = [1, 2, 3, 4, 5]
  io.println(string.inspect(nums))
  // [1, 2, 3, 4, 5]

  let empty: List(Int) = []
  io.println(string.inspect(empty))
  // []

  // prepend with [x, ..rest] — O(1), appending is O(n)
  let more = [0, ..nums]
  io.println(string.inspect(more))
  // [0, 1, 2, 3, 4, 5]

  // list.length
  io.println(string.inspect(list.length(nums)))
  // 5

  // list.first / list.last — return Result since list may be empty
  io.println(string.inspect(list.first(nums)))
  // Ok(1)

  io.println(string.inspect(list.last(nums)))
  // Ok(5)

  io.println(string.inspect(list.first(empty)))
  // Error(Nil)

  // list.contains
  io.println(string.inspect(list.contains(nums, 3)))
  // True

  // list.reverse
  io.println(string.inspect(list.reverse(nums)))
  // [5, 4, 3, 2, 1]

  // list.append — concatenate two lists
  io.println(string.inspect(list.append([1, 2], [3, 4])))
  // [1, 2, 3, 4]

  // list.flatten — flatten a list of lists
  io.println(string.inspect(list.flatten([[1, 2], [3, 4], [5]])))
  // [1, 2, 3, 4, 5]

  // list.map — transform every element
  let squares = list.map(nums, fn(n) { n * n })
  io.println(string.inspect(squares))
  // [1, 4, 9, 16, 25]

  // list.filter — keep elements matching a predicate
  let evens = list.filter(nums, fn(n) { n % 2 == 0 })
  io.println(string.inspect(evens))
  // [2, 4]

  // list.fold — reduce to a single value (like Elixir Enum.reduce)
  let sum = list.fold(nums, 0, fn(acc, n) { acc + n })
  io.println(string.inspect(sum))
  // 15

  // list.map + list.filter chained with |>
  let result =
    nums
    |> list.filter(fn(n) { n % 2 != 0 })
    |> list.map(fn(n) { n * 10 })
  io.println(string.inspect(result))
  // [10, 30, 50]

  // list.each — like map but for side effects, returns Nil
  list.each([1, 2, 3], fn(n) { io.println("item: " <> int.to_string(n)) })
  // item: 1
  // item: 2
  // item: 3

  // list.zip — pair up two lists
  io.println(string.inspect(list.zip([1, 2, 3], ["a", "b", "c"])))
  // [#(1, "a"), #(2, "b"), #(3, "c")]

  // list.sort
  let unsorted = [3, 1, 4, 1, 5, 9, 2, 6]
  io.println(string.inspect(list.sort(unsorted, int.compare)))
  // [1, 1, 2, 3, 4, 5, 6, 9]

  // list.unique — remove duplicates
  io.println(string.inspect(list.unique([1, 2, 2, 3, 3, 3])))
  // [1, 2, 3]

  // list.take / list.drop
  io.println(string.inspect(list.take(nums, 3)))
  // [1, 2, 3]

  io.println(string.inspect(list.drop(nums, 3)))
  // [4, 5]

  // pattern matching on lists
  case nums {
    [] -> io.println("empty")
    [head, ..tail] ->
      io.println(
        "head: " <> string.inspect(head) <> ", tail: " <> string.inspect(tail),
      )
  }
  // head: 1, tail: [2, 3, 4, 5]
}
