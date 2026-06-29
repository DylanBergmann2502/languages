# Enum functions beyond the basics in enum.exs.

################################################################
# Enum.flat_map/2
# Like map, but the function returns a list and they get flattened one level.

words = ["hello world", "foo bar", "elixir"]
IO.inspect(Enum.flat_map(words, &String.split/1))
# ["hello", "world", "foo", "bar", "elixir"]

# Map then flatten one level - not the same as Enum.map (which nests)
IO.inspect(Enum.map(words, &String.split/1))
# [["hello", "world"], ["foo", "bar"], ["elixir"]]

# Common use: expand each item into zero-or-more results
users = [
  %{name: "Alice", roles: [:admin, :user]},
  %{name: "Bob",   roles: [:user]}
]
role_pairs = Enum.flat_map(users, fn %{name: n, roles: roles} ->
  Enum.map(roles, fn r -> {n, r} end)
end)
IO.inspect(role_pairs)
# [{"Alice", :admin}, {"Alice", :user}, {"Bob", :user}]

################################################################
# Enum.scan/2 and Enum.scan/3
# Like reduce but emits every intermediate accumulator value.

IO.inspect(Enum.scan([1, 2, 3, 4, 5], 0, fn x, acc -> acc + x end))
# [1, 3, 6, 10, 15]  (running totals)

# Compare with reduce which only returns the final value:
IO.inspect(Enum.reduce([1, 2, 3, 4, 5], 0, fn x, acc -> acc + x end))
# 15

# Running maximum
IO.inspect(Enum.scan([3, 1, 4, 1, 5, 9, 2, 6], fn x, max -> max(x, max) end))
# [3, 3, 4, 4, 5, 9, 9, 9]

# Without initial accumulator - uses first element as initial
IO.inspect(Enum.scan([1, 2, 3], fn x, acc -> x + acc end))
# [1, 3, 6]

################################################################
# Enum.zip_with/3 (Elixir 1.12+)
# Like zip but applies a function to pairs instead of creating tuples.

xs = [1, 2, 3]
ys = [10, 20, 30]

IO.inspect(Enum.zip_with(xs, ys, fn x, y -> x + y end))
# [11, 22, 33]

# Compare with zip which just pairs them:
IO.inspect(Enum.zip(xs, ys))
# [{1, 10}, {2, 20}, {3, 30}]

# Zip multiple lists with zip_with - pass a list of enumerables
IO.inspect(Enum.zip_with([[1, 2], [10, 20], [100, 200]], fn [a, b, c] -> a + b + c end))
# [111, 222]

################################################################
# Enum.product/1 (Elixir 1.12+)
# Multiply all elements together.

IO.inspect(Enum.product([1, 2, 3, 4, 5])) # 120
IO.inspect(Enum.product([]))               # 1 (identity for multiplication)
IO.inspect(Enum.product(1..5))             # 120

# Useful for combinations / permutations count
dims = [3, 4, 5]
IO.inspect(Enum.product(dims)) # 60 (volume of a 3x4x5 box)

################################################################
# for comprehension with reduce: option (Elixir 1.12+)
# Instead of collecting into a list, fold with an accumulator.

# Sum of squares using reduce: in for
sum_of_squares = for x <- 1..5, reduce: 0 do
  acc -> acc + x * x
end
IO.inspect(sum_of_squares) # 55

# Build a frequency map
sentence = "the cat sat on the mat"
freq = for char <- String.graphemes(sentence), char != " ", reduce: %{} do
  acc -> Map.update(acc, char, 1, &(&1 + 1))
end
IO.inspect(freq)
# %{"a" => 3, "c" => 1, "e" => 2, "h" => 2, "m" => 1, "n" => 1, "o" => 1, "s" => 1, "t" => 4}

################################################################
# Enum.map_intersperse/3 (Elixir 1.16+)
# Map and intersperse in one pass.

IO.inspect(Enum.map_intersperse([1, 2, 3], ", ", &to_string/1))
# ["1", ", ", "2", ", ", "3"]

# Compare:
IO.inspect(Enum.intersperse([1, 2, 3], 0))
# [1, 0, 2, 0, 3]

################################################################
# Enum.frequencies_by/2
# Like frequencies but groups by the result of a function.

words2 = ["apple", "banana", "cherry", "avocado", "blueberry"]
IO.inspect(Enum.frequencies_by(words2, fn w -> String.first(w) end))
# %{"a" => 2, "b" => 2, "c" => 1}

################################################################
# Enum.slide/3 (Elixir 1.13+)
# Move an element or range to a new position.

IO.inspect(Enum.slide([1, 2, 3, 4, 5], 0, 4))
# [2, 3, 4, 5, 1]  - moved index 0 to position 4

IO.inspect(Enum.slide([:a, :b, :c, :d, :e], 1..3, 0))
# [:b, :c, :d, :a, :e]  - moved index range 1..3 before index 0

################################################################
# Enum.chunk_while/4
# Like chunk_every but you control when to break a chunk.

# Chunk consecutive ascending runs
result = Enum.chunk_while(
  [1, 2, 3, 1, 2, 4, 5, 1],
  [],
  fn
    x, [] -> {:cont, [x]}
    x, [prev | _] = acc when x > prev -> {:cont, [x | acc]}
    x, acc -> {:cont, Enum.reverse(acc), [x]}
  end,
  fn [] -> {:cont, []} ; acc -> {:cont, Enum.reverse(acc), []} end
)
IO.inspect(result) # [[1, 2, 3], [1, 2, 4, 5], [1]]

################################################################
# Enum.min/2 and Enum.max/2 with empty list handling

# These raise on empty list by default:
# Enum.min([])  # => raises Enum.EmptyError

# But the 2-arity form accepts a function returning the fallback:
IO.inspect(Enum.min([], fn -> :none end))   # :none
IO.inspect(Enum.max([], fn -> :infinity end)) # :infinity

################################################################
# Enum.flat_map_reduce/3
# Flat maps and reduces simultaneously.

{result2, acc} = Enum.flat_map_reduce(1..5, 0, fn x, acc ->
  {[x, x * 10], acc + x}
end)
IO.inspect(result2) # [1, 10, 2, 20, 3, 30, 4, 40, 5, 50]
IO.inspect(acc)     # 15
