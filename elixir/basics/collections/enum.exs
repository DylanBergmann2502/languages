# In Elixir, an enumerable is any data type
# that implements the Enumerable protocol.
# Lists ([1, 2, 3]), Maps (%{foo: 1, bar: 2})
# and Ranges (1..3) are common data types used as enumerables:

a = Enum.map([1, 2, 3], fn x -> x * 2 end)
IO.inspect(a) # [2, 4, 6]

b = Enum.sum([1, 2, 3])
IO.puts(b) # 6

c = Enum.map(1..3, fn x -> x * 2 end)
IO.inspect(c) # [2, 4, 6]

d = Enum.sum(1..3)
IO.puts(d) # 6

map = %{"a" => 1, "b" => 2}
e = Enum.map(map, fn {k, v} -> {k, v * 2} end)
IO.inspect(e) # [{"a", 2}, {"b", 4}]

################################################################
## Functions
# at
Enum.at([2, 4, 6], 0) # 2
Enum.at([2, 4, 6], 0) # nil
Enum.at([2, 4, 6], 4, :none) # :none

# concat
Enum.concat([1..3, 4..6, 7..9]) # [1, 2, 3, 4, 5, 6, 7, 8, 9]
Enum.concat([[1, [2], 3], [4], [5, 6]]) # [1, [2], 3, 4, 5, 6]

# count
Enum.count([1, 2, 3]) # 3
Enum.count([1, 2, 3, 4, 5], fn x -> rem(x, 2) == 0 end) # 2

# drop (enumerable, AMOUNT)
Enum.drop([1, 2, 3], 2) # [3]
Enum.drop([1, 2, 3], 10) # []
Enum.drop([1, 2, 3], 0) # [1, 2, 3]
Enum.drop([1, 2, 3], -1) # [1, 2]

# each (returns :ok)
Enum.each(["some", "example"], fn x -> IO.puts(x) end)
# "some"
# "example"
#=> :ok

# empty
Enum.empty?([]) # true
Enum.empty?([1, 2, 3]) # false

# fetch
Enum.fetch([2, 4, 6], 0) # {:ok, 2}
Enum.fetch([2, 4, 6], -3) #{:ok, 2}
Enum.fetch([2, 4, 6], 4) # :error

# etc...
