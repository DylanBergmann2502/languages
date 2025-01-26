# Stream is a lazy alternative Enum
# Any enumerable that generates elements one by one
# during enumeration is called a stream.
# Streams can be infinite

# For example, Elixir's Range is a stream:
range = 1..5
IO.inspect(range) # 1..5

enumerated_list = Enum.map(range, &(&1 * 2)) # Enum forces enumeration
IO.inspect(enumerated_list) # [2, 4, 6, 8, 10]

# The Stream module allows us to perform enumeration, without triggering its enumeration.
streamed_list = Stream.map(range, &(&1 * 2))
IO.inspect(streamed_list) # #Stream<[enum: 1..5, funs: [#Function<49.118167795/1 in Stream.map/2>]]>
IO.inspect(Enum.to_list(streamed_list)) # [2, 4, 6, 8, 10]


###############################################################
# While Stream and Enum share many similar functions,
# there are some key differences:
# Functions unique to Stream: Stream.iterate/2, Stream.cycle/1, Stream.resource/3, Stream.unfold/2

# Stream.cycle - Creates an infinite stream repeating a list
Stream.cycle([1, 2, 3])
|> Stream.take(5)
|> Enum.to_list()
|> IO.inspect() # [1, 2, 3, 1, 2]

# Stream.unfold - Creates a stream from a given initial value
Stream.unfold(0, fn n -> {n, n + 1} end)
|> Stream.take(5)
|> Enum.to_list()
|> IO.inspect() # [0, 1, 2, 3, 4]

# Stream.iterate - creates infinite sequence
Stream.iterate(1, &(&1 * 2))
|> Stream.take(10)  # Limit to first 10 numbers
|> Stream.filter(&(&1 <= 10))
|> Enum.to_list()
|> IO.inspect() # [1, 2, 4, 8]

# Stream.chunk_every - Chunks elements with given size
1..10
|> Stream.chunk_every(3)
|> Enum.to_list()
|> IO.inspect(charlists: :as_lists) # [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]


################################################################
# Functions unique to Enum

# Enum.split - splits a collection
Enum.split([1, 2, 3, 4], 2) |> IO.inspect()  # {[1, 2], [3, 4]}

# Enum.random - gets random element
Enum.random(1..10) |> IO.inspect()

# Enum.sort - sorts a collection
Enum.sort([3, 1, 2]) |> IO.inspect() # [1, 2, 3]
