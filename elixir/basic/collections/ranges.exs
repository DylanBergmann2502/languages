# Ranges represent a sequence of one or many consecutive integers. They:
# Are created using the .. operator and can be both ascending or descending.
# Their default step is 1, but can be modified using the ..// operator
# Are inclusive of the first and last values.
# Implement the Enumerable protocol.
# Are represented internally as a struct, but can be pattern matched using ...

# Basic Range Creation
range = 1..5
IO.inspect(range)  # 1..5

# If you need a decreasing range,
# note that implicit decreasing ranges are deprecated,
# so you should explicitly specify the step
# Descending Range (with explicit step)
desc_range = 10..1//-1
IO.inspect(desc_range)  # 10..1//-1

# Range with custom step
stepped_range = 1..10//2
IO.inspect(Enum.to_list(stepped_range))  # [1, 3, 5, 7, 9]

# Working with character ranges
chars = ?a..?e
IO.inspect(Enum.to_list(chars))  # [97, 98, 99, 100, 101]
IO.inspect(Enum.map(chars, &<<&1>>))  # ["a", "b", "c", "d", "e"]

# Common Range Operations
# Ranges implement the Enumerable protocol
# with memory efficient versions of all Enumerable callbacks.
# Such function calls are efficient memory-wise no matter the size of the range.

# 1. Checking membership
number = 5
IO.inspect(number in 1..10)  # true
IO.inspect(Enum.member?(1..10, 11)) # false
IO.inspect(4 in 1..10//2)  # false (due to step of 2)

# 2. Range enumeration
range = 1..5
sum = Enum.sum(range)
IO.inspect(sum)  # 15

# 3. Range transformation
squares = Enum.map(1..4, fn x -> x * x end)
IO.inspect(squares)  # [1, 4, 9, 16]

# 4. Range filtering
even_numbers = Enum.filter(1..10, fn x -> rem(x, 2) == 0 end)
IO.inspect(even_numbers)  # [2, 4, 6, 8, 10]

# 5. Working with empty ranges
empty_range1 = 10..1//1  # Increasing range that can't increase
empty_range2 = 1..10//-1  # Decreasing range that can't decrease
IO.inspect(Enum.to_list(empty_range1))  # []
IO.inspect(Enum.to_list(empty_range2))  # []

# 6. Full-slice range
full_slice = ..  # Same as 0..-1//1
full_slice |> Enum.to_list() |> IO.inspect  # []
IO.inspect(full_slice)  # 0..-1//1

################################################################
# Slicing with Ranges
# 1. Basic String Slicing
text = "Hello, Elixir!"
IO.inspect(String.slice(text, 0..4))    # "Hello"
IO.inspect(String.slice(text, 7..12))   # "Elixir"

# 2. List Slicing
list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
IO.inspect(Enum.slice(list, 2..5))      # [2, 3, 4, 5]
IO.inspect(Enum.slice(list, 0..3))      # [0, 1, 2, 3]

# 3. Negative Indices Slicing
# Remember: negative indices count from the end
# Enum.slice/2 and String.slice don't support negative steps
text = "Programming"
IO.inspect(String.slice(text, 0..-2//1))   # "Programmin"
IO.inspect(String.slice(text, 2..-3//1))   # "ogrammi"

list = [:a, :b, :c, :d, :e]
IO.inspect(Enum.slice(list, 1..-2//1))     # [:b, :c, :d]

# 4. Slicing with Steps
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
IO.inspect(Enum.slice(numbers, 0..8//2)) # [0, 2, 4, 6, 8]
IO.inspect(Enum.slice(numbers, 1..9//2)) # [1, 3, 5, 7, 9]

# 5. Full Slice Range (..)
text = "Elixir"
IO.inspect(String.slice(text, ..))      # "Elixir"

list = [:a, :b, :c]
IO.inspect(Enum.slice(list, ..))        # [:a, :b, :c]

# 6. Combining with Other Collection Operations
chars = "ABCDEFGH"
# First slice, then transform
chars
|> String.slice(2..5)                 # "CDEF"
|> String.downcase()                  # "cdef"
|> IO.inspect()

# 7. Working with Tuples (via Enum.slice/2)
tuple = Tuple.to_list({:a, :b, :c, :d, :e})
sliced = tuple |> Enum.slice(1..3) |> List.to_tuple()
IO.inspect(sliced)                      # {:b, :c, :d}

################################################################
# Internally, ranges are represented as structs:

# 1. Basic Range Structure
range = 1..9//2
IO.inspect(range)                    # 1..9//2

# 2. Pattern Matching with Ranges
first..last//step = range
IO.inspect(first)                    # 1
IO.inspect(last)                     # 9
IO.inspect(step)                     # 2

# 3. Accessing Fields Directly
IO.inspect(range.first)              # 1
IO.inspect(range.last)               # 9
IO.inspect(range.step)               # 2

# 4. Creating Ranges with Range.new
# Range.new/2 (creates range with default step of 1)
range1 = Range.new(1, 5)
IO.inspect(range1)                   # 1..5

# Range.new/3 (creates range with custom step)
range2 = Range.new(1, 9, 2)
IO.inspect(range2)                   # 1..9//2
