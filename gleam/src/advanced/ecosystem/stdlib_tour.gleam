import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

pub fn main() {
  // ── gleam/int ─────────────────────────────────────────────────────────────

  io.println("=== int ===")
  io.println(string.inspect(int.absolute_value(-7)))
  // 7
  io.println(string.inspect(int.max(3, 9)))
  // 9
  io.println(string.inspect(int.min(3, 9)))
  // 3
  io.println(string.inspect(int.clamp(15, min: 0, max: 10)))
  // 10
  io.println(string.inspect(int.is_even(4)))
  // True
  io.println(string.inspect(int.is_odd(4)))
  // False
  io.println(string.inspect(int.power(2, 10.0)))
  // Ok(1024.0)  — second arg is Float, returns Result(Float, Nil)
  io.println(string.inspect(int.square_root(16)))
  // Ok(4.0)
  io.println(string.inspect(int.parse("42")))
  // Ok(42)
  io.println(string.inspect(int.parse("nope")))
  // Error(Nil)
  io.println(int.to_string(255))
  // 255
  io.println(int.to_base16(255))
  // FF
  io.println(int.to_base2(255))
  // 11111111
  io.println(string.inspect(int.compare(3, 5)))
  // Lt
  io.println(string.inspect(int.compare(5, 5)))
  // Eq

  // ── gleam/float ───────────────────────────────────────────────────────────

  io.println("\n=== float ===")
  io.println(string.inspect(float.absolute_value(-3.14)))
  // 3.14
  io.println(string.inspect(float.ceiling(2.1)))
  // 3.0
  io.println(string.inspect(float.floor(2.9)))
  // 2.0
  io.println(string.inspect(float.round(2.5)))
  // 3
  io.println(string.inspect(float.truncate(3.9)))
  // 3
  io.println(string.inspect(float.max(1.5, 2.5)))
  // 2.5
  io.println(string.inspect(float.min(1.5, 2.5)))
  // 1.5
  io.println(string.inspect(float.parse("3.14")))
  // Ok(3.14)
  io.println(string.inspect(float.parse("nope")))
  // Error(Nil)
  io.println(float.to_string(3.14))
  // 3.14
  io.println(string.inspect(float.power(2.0, 8.0)))
  // Ok(256.0)
  io.println(string.inspect(float.square_root(9.0)))
  // Ok(3.0)
  io.println(
    string.inspect(float.loosely_equals(0.1 +. 0.2, 0.3, tolerating: 0.0001)),
  )
  // True

  // ── gleam/string ──────────────────────────────────────────────────────────

  io.println("\n=== string ===")
  io.println(string.uppercase("hello"))
  // HELLO
  io.println(string.lowercase("WORLD"))
  // world
  io.println(string.inspect(string.length("gleam")))
  // 5
  io.println(string.reverse("gleam"))
  // maelg
  io.println(string.repeat("ab", 3))
  // ababab
  io.println(string.trim("  hello  "))
  // hello
  io.println(string.trim_start("  hello  "))
  // hello
  io.println(string.trim_end("  hello  "))
  //   hello
  io.println(string.replace("hello world", "world", "gleam"))
  // hello gleam
  io.println(string.inspect(string.split("a,b,c", ",")))
  // ["a", "b", "c"]
  io.println(string.join(["a", "b", "c"], "-"))
  // a-b-c
  io.println(string.inspect(string.contains("hello", "ell")))
  // True
  io.println(string.inspect(string.starts_with("hello", "he")))
  // True
  io.println(string.inspect(string.ends_with("hello", "lo")))
  // True
  io.println(string.inspect(string.slice("hello", at_index: 1, length: 3)))
  // "ell"
  io.println(string.capitalise("hello world"))
  // Hello world
  io.println(string.inspect(string.to_graphemes("hi")))
  // ["h", "i"]
  io.println(string.inspect(string.pop_grapheme("hello")))
  // Ok(#("h", "ello"))
  io.println(string.pad_start("42", to: 5, with: "0"))
  // 00042
  io.println(string.pad_end("42", to: 5, with: "."))
  // 42...

  // ── gleam/list ────────────────────────────────────────────────────────────

  io.println("\n=== list ===")
  let nums = [1, 2, 3, 4, 5]

  io.println(string.inspect(list.length(nums)))
  // 5
  io.println(string.inspect(list.first(nums)))
  // Ok(1)
  io.println(string.inspect(list.last(nums)))
  // Ok(5)
  io.println(string.inspect(list.rest([1, 2, 3])))
  // Ok([2, 3])
  io.println(string.inspect(list.take(nums, 3)))
  // [1, 2, 3]
  io.println(string.inspect(list.drop(nums, 3)))
  // [4, 5]
  io.println(string.inspect(list.reverse(nums)))
  // [5, 4, 3, 2, 1]
  io.println(string.inspect(list.contains(nums, 3)))
  // True
  io.println(string.inspect(list.map(nums, fn(n) { n * n })))
  // [1, 4, 9, 16, 25]
  io.println(string.inspect(list.filter(nums, fn(n) { n > 2 })))
  // [3, 4, 5]
  io.println(string.inspect(list.fold(nums, 0, fn(acc, n) { acc + n })))
  // 15
  io.println(
    string.inspect(list.fold_right(nums, [], fn(acc, n) { [n, ..acc] })),
  )
  // [1, 2, 3, 4, 5]
  io.println(string.inspect(list.find(nums, fn(n) { n > 3 })))
  // Ok(4)
  io.println(
    string.inspect(
      list.find_map(nums, fn(n) {
        case n > 3 {
          True -> Ok(n * 10)
          False -> Error(Nil)
        }
      }),
    ),
  )
  // Ok(40)
  io.println(string.inspect(list.all(nums, fn(n) { n > 0 })))
  // True
  io.println(string.inspect(list.any(nums, fn(n) { n > 4 })))
  // True
  io.println(string.inspect(list.flatten([[1, 2], [3, 4], [5]])))
  // [1, 2, 3, 4, 5]
  io.println(string.inspect(list.flat_map(nums, fn(n) { [n, n * 2] })))
  // [1, 2, 2, 4, 3, 6, 4, 8, 5, 10]
  io.println(string.inspect(list.zip([1, 2, 3], ["a", "b", "c"])))
  // [#(1, "a"), #(2, "b"), #(3, "c")]
  io.println(string.inspect(list.unzip([#(1, "a"), #(2, "b")])))
  // #([1, 2], ["a", "b"])
  io.println(string.inspect(list.sort([3, 1, 4, 1, 5], int.compare)))
  // [1, 1, 3, 4, 5]
  io.println(string.inspect(list.unique([1, 2, 2, 3, 3, 3])))
  // [1, 2, 3]
  io.println(
    string.inspect(list.index_map(["a", "b", "c"], fn(x, i) { #(i, x) })),
  )
  // [#(0, "a"), #(1, "b"), #(2, "c")]
  io.println(string.inspect(list.count(nums, fn(n) { n > 2 })))
  // 3
  io.println(string.inspect(list.intersperse([1, 2, 3], 0)))
  // [1, 0, 2, 0, 3]
  io.println(string.inspect(list.window([1, 2, 3, 4], 2)))
  // [[1, 2], [2, 3], [3, 4]]
  io.println(string.inspect(list.sized_chunk([1, 2, 3, 4, 5], 2)))
  // [[1, 2], [3, 4], [5]]
  // list.group — group elements by a key function, returns Dict(key, List(a))
  let grouped =
    list.group([1, 2, 3, 4], fn(n) {
      case int.is_even(n) {
        True -> "even"
        False -> "odd"
      }
    })
  io.println(string.inspect(dict.size(grouped)))
  // 2  (two keys: "even" and "odd")
  io.println(string.inspect(dict.get(grouped, "even")))
  // Ok([4, 2])  (prepend order — last seen first)
  io.println(string.inspect(dict.get(grouped, "odd")))
  // Ok([3, 1])

  // ── gleam/dict ────────────────────────────────────────────────────────────

  io.println("\n=== dict ===")
  let scores = dict.from_list([#("alice", 95), #("bob", 87), #("carol", 92)])

  io.println(string.inspect(dict.size(scores)))
  // 3
  io.println(string.inspect(dict.get(scores, "alice")))
  // Ok(95)
  io.println(string.inspect(dict.get(scores, "dave")))
  // Error(Nil)
  io.println(string.inspect(dict.has_key(scores, "bob")))
  // True
  let updated = dict.insert(scores, "dave", 78)
  io.println(string.inspect(dict.size(updated)))
  // 4
  let deleted = dict.delete(scores, "bob")
  io.println(string.inspect(dict.size(deleted)))
  // 2
  io.println(string.inspect(list.sort(dict.keys(scores), string.compare)))
  // ["alice", "bob", "carol"]
  // dict.values returns in unspecified order; sort for consistent display
  // note: inspect on List(Int) may show as charlist if values are valid codepoints
  // use list.map(int.to_string) to display safely
  let score_values =
    dict.to_list(scores)
    |> list.map(fn(pair) { pair.1 })
    |> list.sort(int.compare)
  io.println(string.inspect(list.map(score_values, int.to_string)))
  // ["87", "95", "92"]  (sorted, shown as strings to avoid charlist repr)
  let boosted = dict.map_values(scores, fn(_k, v) { v + 5 })
  io.println(string.inspect(dict.get(boosted, "alice")))
  // Ok(100)
  let passing = dict.filter(scores, fn(_k, v) { v >= 90 })
  io.println(string.inspect(dict.size(passing)))
  // 2
  let total = dict.fold(scores, 0, fn(acc, _k, v) { acc + v })
  io.println(string.inspect(total))
  // 274
  let extras = dict.from_list([#("dave", 78), #("eve", 88)])
  let merged = dict.merge(scores, extras)
  io.println(string.inspect(dict.size(merged)))
  // 5
  let upserted =
    dict.upsert(scores, "alice", fn(existing) {
      case existing {
        Some(v) -> v + 10
        None -> 0
      }
    })
  io.println(string.inspect(dict.get(upserted, "alice")))
  // Ok(105)

  // ── gleam/result ──────────────────────────────────────────────────────────

  io.println("\n=== result ===")
  let r: Result(Int, String) = Ok(42)

  io.println(string.inspect(result.is_ok(r)))
  // True
  io.println(string.inspect(result.is_error(r)))
  // False
  io.println(string.inspect(result.map(r, fn(n) { n * 2 })))
  // Ok(84)
  io.println(
    string.inspect(result.map_error(Error("bad"), fn(e) { "error: " <> e })),
  )
  // Error("error: bad")
  io.println(string.inspect(result.unwrap(r, 0)))
  // 42
  io.println(string.inspect(result.unwrap(Error("oops"), 0)))
  // 0
  io.println(
    string.inspect(
      result.try(Ok(5), fn(n) {
        case n > 0 {
          True -> Ok(n * 10)
          False -> Error("non-positive")
        }
      }),
    ),
  )
  // Ok(50)
  io.println(string.inspect(result.all([Ok(1), Ok(2), Ok(3)])))
  // Ok([1, 2, 3])
  io.println(string.inspect(result.all([Ok(1), Error("bad"), Ok(3)])))
  // Error("bad")
  io.println(
    string.inspect(result.partition([Ok(1), Error("a"), Ok(2), Error("b")])),
  )
  // #([2, 1], ["b", "a"])  (reversed — built by prepending)
  io.println(string.inspect(result.replace(Ok(42), "replaced")))
  // Ok("replaced")
  io.println(
    string.inspect(result.replace_error(Error(Nil), "something went wrong")),
  )
  // Error("something went wrong")

  io.println("\nstdlib tour done")
  // stdlib tour done
}
