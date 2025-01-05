# Reading a file with File.read/1 is going to
# load the whole file into memory all at once.
# This might be a problem when working with really big files.
# To handle them efficiently, you might use
# File.open/2 and IO.read/2 to read the file line by line,
# or you can stream the file with File.stream/3.
# The stream implements both the Enumerable and Collectable protocols,
# which means it can be used both for reading and writing.

# Let's create a large file first
{:ok, file} = File.open("large_file.txt", [:write])
Enum.each(1..1000, fn n ->
  IO.puts(file, "This is line #{n}")
end)
File.close(file)

# Now let's demonstrate different ways to process this file

# Note: with file operations, use Stream module when possible for memory efficiency,
# as Enum module will loads everything into memory, which loses the performance.

# Method 1: Reading and processing line by line with Stream
File.stream!("large_file.txt")
|> Stream.map(&String.upcase/1)
|> Stream.filter(&String.contains?(&1, "LINE 5"))
|> Enum.each(&IO.puts/1)
# Will only print lines containing "LINE 5" in uppercase
# THIS IS LINE 5
# THIS IS LINE 50
# THIS IS LINE 51
# ...etc

# Method 2: Processing and writing to a new file
File.stream!("large_file.txt")
|> Stream.map(&String.replace(&1, "line", "number"))
|> Stream.into(File.stream!("output.txt"))
|> Stream.run()

# Method 3: Counting lines without loading entire file
line_count = File.stream!("large_file.txt") |> Enum.count()
IO.puts("Total lines: #{line_count}") # Total lines: 1000

# Method 4: Getting first 5 lines
File.stream!("large_file.txt")
|> Stream.take(5)
|> Enum.to_list()
|> IO.inspect()
# ["This is line 1\n", "This is line 2\n", "This is line 3\n", "This is line 4\n", "This is line 5\n"]

# Method 5: Processing chunks of lines
File.stream!("large_file.txt")
|> Stream.chunk_every(3)
|> Stream.take(2)  # Take first 2 chunks
|> Enum.to_list()
|> IO.inspect()
# Will show first 2 groups of 3 lines each
