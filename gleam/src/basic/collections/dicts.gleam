import gleam/dict.{type Dict}
import gleam/io
import gleam/option.{None, Some}
import gleam/string

pub fn main() {
  // Dict(key, value) — hash map, keys must be comparable
  // create from a list of #(key, value) pairs
  let scores: Dict(String, Int) =
    dict.from_list([#("Alice", 95), #("Bob", 87), #("Charlie", 91)])
  // dict.size to confirm it was created (inspect on a whole Dict shows internal BEAM repr)
  io.println(string.inspect(dict.size(scores)))
  // 3

  // dict.get — returns Result, since the key may not exist
  io.println(string.inspect(dict.get(scores, "Alice")))
  // Ok(95)

  io.println(string.inspect(dict.get(scores, "Dylan")))
  // Error(Nil)

  // dict.insert — returns a new dict (immutable)
  let updated = dict.insert(scores, "Dylan", 100)
  io.println(string.inspect(dict.get(updated, "Dylan")))
  // Ok(100)

  // dict.delete — returns a new dict without the key
  let removed = dict.delete(scores, "Bob")
  io.println(string.inspect(dict.get(removed, "Bob")))
  // Error(Nil)

  // dict.has_key
  io.println(string.inspect(dict.has_key(scores, "Alice")))
  // True

  io.println(string.inspect(dict.has_key(scores, "Dylan")))
  // False

  // dict.size
  io.println(string.inspect(dict.size(scores)))
  // 3

  // dict.keys / dict.values
  // note: order is not guaranteed
  io.println(string.inspect(dict.keys(scores)))
  // ["Alice", "Bob", "Charlie"]  (order may vary)

  // dict.map_values — transform every value
  let doubled = dict.map_values(scores, fn(_key, val) { val * 2 })
  io.println(string.inspect(dict.get(doubled, "Alice")))
  // Ok(190)

  // dict.filter — keep entries where predicate is True
  let high_scores = dict.filter(scores, fn(_key, val) { val >= 90 })
  io.println(string.inspect(dict.size(high_scores)))
  // 2

  // dict.fold — reduce the dict to a single value
  let total = dict.fold(scores, 0, fn(acc, _key, val) { acc + val })
  io.println(string.inspect(total))
  // 273

  // dict.merge — combine two dicts, second wins on key conflicts
  let extra = dict.from_list([#("Dylan", 100), #("Alice", 50)])
  let merged = dict.merge(scores, extra)
  io.println(string.inspect(dict.get(merged, "Alice")))
  // Ok(50)  (extra overwrote scores)

  // dict.to_list — back to a list of pairs
  let pairs = dict.to_list(dict.from_list([#("a", 1), #("b", 2)]))
  io.println(string.inspect(pairs))
  // [#("a", 1), #("b", 2)]  (order may vary)

  // pattern match on dict.get result
  case dict.get(scores, "Charlie") {
    Ok(s) -> io.println("Charlie scored " <> string.inspect(s))
    Error(Nil) -> io.println("Charlie not found")
  }
  // Charlie scored 91

  // dict.upsert — update if exists, insert if not
  let bumped =
    dict.upsert(scores, "Alice", fn(existing) {
      case existing {
        Some(s) -> s + 5
        None -> 0
      }
    })
  io.println(string.inspect(dict.get(bumped, "Alice")))
  // Ok(100)
}
