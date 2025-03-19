# Input and Output Operations in Ruby
# Ruby provides various ways to handle input and output operations

########################################################################
# Basic Output with puts, print, and p
puts "Basic Output Methods:"

# puts adds a newline after each output
puts "Hello"  # Outputs: Hello + newline
puts "World"  # Outputs: World + newline

# print doesn't add a newline
print "Hello "  # Outputs: Hello (without newline)
print "World"   # Outputs: World (continuing on same line)
puts            # Just adds a newline

# p inspects and prints objects (shows more details)
p "Hello"      # Outputs: "Hello" (with quotes)
p [1, 2, 3]    # Outputs: [1, 2, 3] (array representation)
p nil          # Outputs: nil (shows nil explicitly)

# pp (pretty print) formats complex objects nicely (Ruby 2.5+)
require "pp"
complex_hash = { a: { b: [1, 2, 3], c: { d: 4 } } }
pp complex_hash  # Outputs the hash with nice indentation

########################################################################
# Getting User Input
puts "\nGetting User Input:"

# Basic input with gets
print "Enter your name: "
name = gets            # Read a line of input (includes the newline character)
puts "Hello, #{name}"  # Hello, [name with extra newline]

# Remove the trailing newline with chomp
print "Enter your name again: "
name = gets.chomp       # Read a line and remove newline character
puts "Hello, #{name}!"  # Hello, [name]!

# Converting input to other types
print "Enter a number: "
number = gets.chomp.to_i  # Convert input to integer
puts "#{number} * 2 = #{number * 2}"

print "Enter a decimal number: "
decimal = gets.chomp.to_f  # Convert input to float
puts "#{decimal} * 3.5 = #{decimal * 3.5}"

########################################################################
# Command Line Arguments
puts "\nCommand Line Arguments:"
puts "This script name is: #{$0}"
puts "The arguments provided are:"
ARGV.each_with_index do |arg, index|
  puts "  Argument #{index}: #{arg}"
end

# Note: When using ARGV, gets reads from ARGV instead of standard input
# To read from standard input after using ARGV:
# ARGV.clear
# name = gets.chomp

########################################################################
# Working with files - Reading
puts "\nReading from Files:"

# Reading an entire file at once
begin
  content = File.read("example.txt")
  puts "File content:\n#{content}"
rescue Errno::ENOENT
  puts "File not found! Let's create it first."

  # Creating a sample file
  File.write("example.txt", "This is line 1\nThis is line 2\nThis is line 3")
  content = File.read("example.txt")
  puts "File created and content read:\n#{content}"
end

# Reading file line by line
puts "\nReading line by line:"
File.open("example.txt", "r") do |file|
  file.each_line.with_index do |line, index|
    puts "Line #{index + 1}: #{line}"
  end
end

# Reading file as an array of lines
lines = File.readlines("example.txt")
puts "\nUsing readlines:"
puts "Number of lines: #{lines.size}"
puts "First line: #{lines.first}"

########################################################################
# Working with files - Writing
puts "\nWriting to Files:"

# Writing to a file (overwrites existing content)
File.write("output.txt", "Hello, World!\n")
puts "File 'output.txt' created."

# Appending to a file
File.open("output.txt", "a") do |file|
  file.puts "This line is appended."
  file.puts "And so is this one."
end

# Reading back the file to verify
content = File.read("output.txt")
puts "Updated file content:\n#{content}"

########################################################################
# Handling Binary Data
puts "\nHandling Binary Data:"

# Writing binary data
File.binwrite("binary.dat", [0xFF, 0x00, 0xAB, 0xCD].pack("C*"))
puts "Binary file created."

# Reading binary data
binary_data = File.binread("binary.dat")
puts "Binary data (hex):"
puts binary_data.unpack("H*")[0]  # Convert to hex string

########################################################################
# Standard Streams
puts "\nStandard Streams:"

# Standard output (stdout)
$stdout.puts "This goes to standard output."

# Standard error (stderr)
$stderr.puts "This goes to standard error."

# Redirecting output to a file
original_stdout = $stdout.clone
begin
  $stdout.reopen("redirected.txt", "w")
  puts "This message goes to redirected.txt"
ensure
  $stdout.reopen(original_stdout)
end

puts "Back to normal output."
puts "Content of redirected.txt:"
puts File.read("redirected.txt")

########################################################################
# IO Objects and Methods
puts "\nIO Objects and Methods:"

# Creating a StringIO object (string that behaves like an IO)
require "stringio"
input = StringIO.new("line1\nline2\nline3\n")

# Reading from StringIO
puts input.gets       # line1
puts input.readline   # line2
puts input.read(3)    # lin (read 3 characters)
puts input.eof?       # false

# Writing to StringIO
output = StringIO.new
output.puts "Hello"
output.puts "World"
puts output.string    # Get the content as a string

# File position
file = File.open("example.txt")
puts file.pos         # 0 (start position)
file.gets             # Read a line
puts file.pos         # Position after reading
file.rewind           # Go back to the beginning
puts file.pos         # 0
file.close            # Close the file

########################################################################
# Cleanup - delete temporary files
puts "\nCleaning up temporary files..."
File.delete("example.txt", "output.txt", "binary.dat", "redirected.txt")
puts "Cleanup complete."
