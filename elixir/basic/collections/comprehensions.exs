# Comprehensions are syntactic sugar
# for iterating through enumerables in Elixir.

# There are three parts to a comprehension:
# 1.generators:
# Values enumerated from structures that implement the Enumerable protocol.
# Pattern matching expressions to destructure enumerated values.
# 2. Filters:
# Boolean conditions, used to select which
# enumerated values to use when creating the new values.
# 3. Collectables:
# A structure which implements the Collectable protocol,
# used to collect the new values.
result = for s <- ["a", "b", "hello", "c"], # 1. generator
  String.length(s) == 1,                    # 2. filter
  into: "",                                 # 3. collectable
  do: String.upcase(s)

IO.inspect(result) # => "ABC"

################################################################
# Pattern matching in generators with a list of tuples
users = [{"John", 25}, {"Alice", 30}, {"Bob", 20}]
for {name, age} when age > 22 <- users do
  "#{name} is #{age}"
end
IO.inspect(result) # ["John is 25", "Alice is 30"]

# Multiple generators - creates a cartesian product
suits = ["♣", "♦", "♥", "♠"]
values = ["A", "K", "Q", "J"]
deck = for suit <- suits, value <- values do
  {suit, value}
end
IO.inspect(deck)
# [{"♣", "A"}, {"♣", "K"}, {"♣", "Q"}, {"♣", "J"},
#  {"♦", "A"}, {"♦", "K"}, {"♦", "Q"}, {"♦", "J"},
#  {"♥", "A"}, {"♥", "K"}, {"♥", "Q"}, {"♥", "J"},
#  {"♠", "A"}, {"♠", "K"}, {"♠", "Q"}, {"♠", "J"}]

# Pattern matching with maps and multiple generators
users = [
  %{name: "John", items: ["book", "pen"]},
  %{name: "Alice", items: ["laptop", "phone"]}
]

for %{name: name, items: items} <- users, item <- items do
  "#{name} has a #{item}"
end
IO.inspect(result)
# ["John has a book", "John has a pen",
#  "Alice has a laptop", "Alice has a phone"]

##########################################################
# Guards and filters
users = [{"John", 25}, {"Alice", 30}, {"Bob", 20}]

# Guards are part of pattern matching and are more restrictive -
# they can only use a subset of operators and functions (guard-safe functions).
# For example, you can't call custom functions in guards.
# Using a guard clause in the pattern match
for {name, age} when age > 22 <- users do
  "#{name} is #{age}"
end

# Filters can use any function or operation, making them more flexible.
# Using a filter instead
for {name, age} <- users,
    String.length(name) > 3,  # Custom function call works in filter
    age > 22 do
  "#{name} is #{age}"
end

########################################################
# :into and :uniq
# Basic :into example - collecting into different structures
numbers = [1, 2, 3, 4]
# Into a map
result = for n <- numbers, into: %{} do
  {n, n * n}
end
IO.inspect(result) # %{1 => 1, 2 => 4, 3 => 9, 4 => 16}

# Into a string
result = for n <- numbers, into: "" do
  "#{n}"
end
IO.inspect(result) # "1234"

# :uniq option - removes duplicates from the result
numbers = [1, 1, 2, 2, 3, 3]
result = for n <- numbers, uniq: true do
  n
end
IO.inspect(result) # [1, 2, 3]

# Combining :uniq with multiple generators
coords = for x <- [1, 1, 2], y <- [2, 2, 3], uniq: true do
  {x, y}
end
IO.inspect(coords) # [{1, 2}, {1, 3}, {2, 2}, {2, 3}]
