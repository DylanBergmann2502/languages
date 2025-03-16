# StringIO allows you to treat strings like IO objects
# It's useful for testing, capturing output, or working with string data as streams
require 'stringio'

########################################################################
# Creating a StringIO object
# You can create an empty StringIO or initialize it with content

# Empty StringIO
empty_io = StringIO.new
puts empty_io.string.inspect  # ""

# StringIO with initial content
hello_io = StringIO.new("Hello, StringIO!")
puts hello_io.string.inspect  # "Hello, StringIO!"

# You can also specify the mode (similar to File.open modes)
# "r" - read-only
# "w" - write-only (truncates existing content)
# "r+" - read-write, starts at beginning
# "w+" - read-write, truncates existing content
# "a+" - read-write, starts at end
readonly_io = StringIO.new("Read only", "r")
puts readonly_io.closed_write?  # true (cannot write)
puts readonly_io.closed_read?   # false (can read)

########################################################################
# Reading from StringIO
# StringIO supports the same reading methods as IO objects

hello_io.rewind  # Move position to the beginning (position 0)
puts hello_io.pos  # 0

# Read entire content
content = hello_io.read
puts content  # "Hello, StringIO!"
puts hello_io.pos  # 17 (moved to the end)

# Reading specific number of bytes
hello_io.rewind
puts hello_io.read(5)  # "Hello"

# Reading line by line
hello_io = StringIO.new("Line 1\nLine 2\nLine 3")
hello_io.each_line do |line|
  puts "Line: #{line.inspect}"
end
# Line: "Line 1\n"
# Line: "Line 2\n"
# Line: "Line 3"

# Reading character by character
hello_io.rewind
4.times do
  puts hello_io.getc
end
# L
# i
# n
# e

########################################################################
# Writing to StringIO
# StringIO supports the same writing methods as IO objects

# Writing strings
output = StringIO.new
output.write("Hello")
output.write(", ")
output.write("World!")
puts output.string  # "Hello, World!"

# puts and print also work
output = StringIO.new
output.puts "Line 1"
output.puts "Line 2"
puts output.string.inspect  # "Line 1\nLine 2\n"

# Appending content
output = StringIO.new("Initial")
output.pos = output.string.length  # Move to the end
output.write(" content")
puts output.string  # "Initial content"

########################################################################
# Position and seeking
# You can manipulate the current position in the stream

io = StringIO.new("abcdefghijklmnopqrstuvwxyz")

# Get current position
puts io.pos  # 0

# Read some data and check position
puts io.read(5)  # "abcde"
puts io.pos  # 5

# Set position directly
io.pos = 10
puts io.read(5)  # "klmno"

# Using seek
# IO::SEEK_SET - from beginning
# IO::SEEK_CUR - from current position
# IO::SEEK_END - from end
io.seek(0, IO::SEEK_SET)  # Start
puts io.read(1)  # "a"

io.seek(2, IO::SEEK_CUR)  # 2 characters forward from current
puts io.read(1)  # "d"

io.seek(-3, IO::SEEK_END)  # 3 characters from end
puts io.read  # "xyz"

########################################################################
# Real-world use cases

# 1. Capturing output for testing
def generate_report
  puts "Report title"
  puts "============"
  puts "Important data"
end

# Capture the output
original_stdout = $stdout
captured_output = StringIO.new
$stdout = captured_output

generate_report

# Restore the original stdout
$stdout = original_stdout

puts "Captured output:"
puts captured_output.string

# 2. Parsing string data as a file
csv_data = "name,age,city\nAlice,30,New York\nBob,25,San Francisco"
csv_io = StringIO.new(csv_data)

csv_io.each_line do |line|
  fields = line.chomp.split(',')
  puts "Fields: #{fields.inspect}"
end
# Fields: ["name", "age", "city"]
# Fields: ["Alice", "30", "New York"]
# Fields: ["Bob", "25", "San Francisco"]

# 3. In-memory file operations without touching disk
temp_file = StringIO.new
temp_file.puts "Temporary data"
temp_file.puts "More data"
temp_file.rewind
content = temp_file.read
puts "Read from in-memory file: #{content.inspect}"

########################################################################
# StringIO is part of Ruby's standard library
# It behaves like a File or IO object but works with strings in memory
# Useful for testing, capturing output, or simulating file operations
