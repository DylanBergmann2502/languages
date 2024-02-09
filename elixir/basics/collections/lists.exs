# List operators never modify the existing list.
# Concatenating to or removing elements from a list
# returns a new list. We say that
# Elixir data structures are immutable.

# Literal Form
a = []
b = [1]
c = [1, 2, 3]

# Head-tail Notation
a = []
# same as [1]
b = [1 | []]
# same as [1, 2, 3]
c = [1 | [2 | [3 | []]]]

# Mixed
# same as [1, 2, 3]
c = [1 | [2, 3]]

# There can also be more than one element before the cons (|) operator.
# Multiple prepends
d = [1, 2, 3 | [4, 5]]

list = [2, 1]

IO.puts [3, 2, 1] == [3 | list]  # => true

# Appending to the end of a list (potentially slow)
e = [1, 2, 3] ++ [4] ++ [5] ++ [6]

# Prepend to the start of a list (faster, due to the nature of linked lists)
f = [6 | [5 | [4 | [3, 2, 1]]]]
# then reverse!

# Two lists can be concatenated or subtracted
# using the ++/2 and --/2 operators respectively:
g = [1, 2, 3] ++ [4, 5, 6] # [1, 2, 3, 4, 5, 6]
h = [1, true, 2, false, 3, true] -- [true, false] # [1, 2, 3, true]

list = [1, 2, 3]
IO.puts hd(list) # 1
IO.puts tl(list) # [2, 3]

# Functions
List.delete([:a, :b, :c], :d) # [:a, :b, :c]

List.delete([:a, :b, :b, :c], :b) # [:a, :b, :c]

List.delete_at([1, 2, 3], 0) # [2, 3]

List.duplicate([1, 2], 3) # [[1, 2], [1, 2], [1, 2]]

List.flatten([1, [[2], 3]]) # [1, 2, 3]
