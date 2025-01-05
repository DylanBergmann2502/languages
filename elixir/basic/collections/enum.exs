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

# filter - keeps elements that match the condition
nums = [1, 2, 3, 4, 5, 6]
evens = Enum.filter(nums, fn x -> rem(x, 2) == 0 end)
IO.inspect(evens) # [2, 4, 6]

# reject - opposite of filter
numbers = [1, 2, 3, 4, 5, 6]
odds = Enum.reject(numbers, fn x -> rem(x, 2) == 0 end)
IO.inspect(odds) # [1, 3, 5]

# find - returns the first element matching the condition
result = Enum.find([2, 4, 6, 8], fn x -> rem(x, 3) == 0 end)
IO.inspect(result) # 6

# min/max and min_by/max_by
nums = [4, 2, 8, 6]
min_val = Enum.min(nums)
max_val = Enum.max(nums)
IO.inspect({min_val, max_val}) # {2, 8}

words = ["cat", "elephant", "dog"]
shortest = Enum.min_by(words, &String.length/1)
longest = Enum.max_by(words, &String.length/1)
IO.inspect({shortest, longest}) # {"cat", "elephant"}

# map_reduce - combines map and reduce operations
{doubled, sum} = Enum.map_reduce([1, 2, 3], 0, fn x, acc -> {x * 2, acc + x} end)
IO.inspect(doubled) # [2, 4, 6]
IO.inspect(sum) # 6

# chunk_by - chunks elements by the given function
result = Enum.chunk_by([1, 2, 2, 3, 4, 4, 6, 7, 7], fn x -> rem(x, 2) == 0 end)
IO.inspect(result) # [[1], [2, 2], [3], [4, 4, 6], [7, 7]]

# chunk_every - splits into chunks of specified size
chunks = Enum.chunk_every([1, 2, 3, 4, 5], 2)
IO.inspect(chunks) # [[1, 2], [3, 4], [5]]

# reduce - reduces collection to a single value
sum = Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)
IO.inspect(sum) # 6

# any? and all? - check conditions
has_even = Enum.any?([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
all_even = Enum.all?([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
IO.inspect({has_even, all_even}) # {true, false}

# zip - combines elements from multiple enumerables
zipped = Enum.zip([1, 2, 3], [:a, :b, :c])
IO.inspect(zipped) # [{1, :a}, {2, :b}, {3, :c}]

# unzip - splits list of tuples into tuple of lists
{nums, atoms} = Enum.unzip([{1, :a}, {2, :b}, {3, :c}])
IO.inspect(nums) # [1, 2, 3]
IO.inspect(atoms) # [:a, :b, :c]

# take_random - takes n random elements
random = Enum.take_random(1..100, 3)
IO.inspect(random) # [23, 55, 89] (random numbers will vary)

# with_index - adds index to each element
indexed = Enum.with_index(["a", "b", "c"])
IO.inspect(indexed) # [{"a", 0}, {"b", 1}, {"c", 2}]

# group_by - groups elements by given function
grouped = Enum.group_by([1, 2, 3, 4, 5, 6], fn x -> rem(x, 3) end)
IO.inspect(grouped) # %{0 => [3, 6], 1 => [1, 4], 2 => [2, 5]}

# frequencies - counts occurrences of each element
freq = Enum.frequencies(["a", "b", "a", "c", "b", "a"])
IO.inspect(freq) # %{"a" => 3, "b" => 2, "c" => 1}

# slice - takes a slice of the enumerable
sliced = Enum.slice([1, 2, 3, 4, 5], 1..3)
IO.inspect(sliced) # [2, 3, 4]

# sort/sort_by - sorts elements
sorted = Enum.sort([3, 1, 4, 1, 5], :desc)
IO.inspect(sorted) # [5, 4, 3, 1, 1]

sorted_by = Enum.sort_by(["banana", "apple", "cherry"], &String.length/1)
IO.inspect(sorted_by) # ["apple", "banana", "cherry"]

# uniq and uniq_by - remove duplicates
uniq_nums = Enum.uniq([1, 2, 2, 3, 3, 3, 4])
IO.inspect(uniq_nums) # [1, 2, 3, 4]

users = [
  %{name: "John", age: 30},
  %{name: "Jane", age: 30},
  %{name: "Bob", age: 25}
]
unique_by_age = Enum.uniq_by(users, fn user -> user.age end)
IO.inspect(unique_by_age) # [%{name: "John", age: 30}, %{name: "Bob", age: 25}]

# join - converts enumerable to string with separator
joined = Enum.join(["a", "b", "c"], ", ")
IO.inspect(joined) # "a, b, c"
