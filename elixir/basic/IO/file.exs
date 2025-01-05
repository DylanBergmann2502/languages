# File.open/2 returns a PID of a process that handles the file.

# Commonly used modes are:
# :read - open for reading, file must exist
# :write -  open for writing, file will be created if doesn't exist,
#           existing content will be overwritten
# :append - open for writing, file will be created if doesn't exist,
#           existing content will be preserved

{:ok, file} = File.open("test.txt", [:write])

IO.write(file, "world")

# When you're finished working with the file, close it with File.close/1.
File.close(file)

# File.write/2 is higher-level and specifically for file operations,
# handling the opening/closing for you
File.write("test.txt", "content", [:append])

{:ok, content} = File.read("test.txt")
IO.puts(content)

# We can use File.read/1 or File.read!/1
File.read("test.txt") # {:ok, "world"}
File.read!("test.txt") # "world"
File.read("path/to/file/unknown") # {:error, :enoent}
# File.read!("path/to/file/unknown") # ** (File.Error) could not read file "path/to/file/unknown": no such file or directory

# Some File functions
IO.puts File.exists?("test.txt") # true

{:ok, files} = File.ls "."
IO.inspect files # ["files.exs", "io.exs", "test.txt"]

{:ok, current_dir} = File.cwd()
IO.puts current_dir # c:/Users/locdu/Downloads/Languages/elixir/basics/IO

##################################################################
# IO.puts/2 vs IO.write/2 vs IO.binwrite/2
{:ok, file} = File.open("test.txt", [:write])

IO.write(file, "Hello")
IO.write(file, "World")
# File content: "HelloWorld" (no spaces or newlines)

IO.puts(file, "Hello")
IO.puts(file, "World")
# File content: "HelloWorld\nHello\nWorld\n" (puts adds newlines)

IO.binwrite(file, <<72, 105>>)  # ASCII values for "Hi"
IO.binwrite(file, <<33>>)       # ASCII value for "!"
# File content: "HelloWorld\nHello\nWorld\nHi!"

File.close(file)

# Let's read and inspect the content
IO.puts(File.read!("test.txt"))
# Output will be:
# HelloWorldHello
# World
# Hi!

# ################################################################
# # Files and processes
# # Every time a file is written to with File.write/2,
# # a file descriptor is opened and a new Elixir process is spawned.
# # For this reason, writing to a file in a loop using File.write/2 should be avoided.

# # Approach 1: File.write/2 - Opens and closes file for each write
# Enum.each(1..1000, fn n ->
#   File.write("test.txt", "#{n}\n", [:append])
# end)
# # This creates 1000 file descriptors and 1000 processes!

# # Approach 2: File.open/2 with IO.write - More efficient
# {:ok, file} = File.open("test.txt", [:append])
# Enum.each(1..1000, fn n ->
#   IO.write(file, "#{n}\n")
# end)
# File.close(file)
# # Only one file descriptor and process!
