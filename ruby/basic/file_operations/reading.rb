# reading.rb - Basic file reading operations in Ruby

########################################################################
# Opening and reading an entire file at once
puts "--- Reading entire file at once ---"

# Create a test file to work with
File.write("sample.txt", "Line 1\nLine 2\nLine 3\nLine 4\nLine 5")

# Read the entire file content as a single string
content = File.read("sample.txt")
puts "File content:"
puts content

# Read file with explicit encoding
utf8_content = File.read("sample.txt", encoding: "UTF-8")
puts "UTF-8 encoded content is same as default: #{utf8_content == content}"

########################################################################
# Reading file line by line
puts "\n--- Reading file line by line ---"

# Using File.foreach - memory efficient for large files
puts "Using File.foreach:"
File.foreach("sample.txt") do |line|
  puts "  > #{line.chomp}"  # chomp removes trailing newline
end

# Using File.readlines - loads all lines into an array
puts "\nUsing File.readlines:"
lines = File.readlines("sample.txt")
puts "Total lines: #{lines.count}"
puts "Lines array: #{lines.inspect}"
puts "First line: #{lines[0].chomp}"

########################################################################
# Opening file with a block (auto-closes when done)
puts "\n--- Using file with a block ---"

File.open("sample.txt", "r") do |file|
  # Getting file information
  puts "File path: #{file.path}"
  puts "File size: #{file.size} bytes"

  # Read first 7 characters
  puts "First 7 chars: #{file.read(7).inspect}"

  # Read next 5 characters
  puts "Next 5 chars: #{file.read(5).inspect}"

  # Read to end of file
  puts "Rest of file: #{file.read.inspect}"

  # Rewind to beginning
  file.rewind
  puts "After rewind, first line: #{file.readline.chomp}"
end

########################################################################
# Reading from a specific position
puts "\n--- Reading from specific positions ---"

File.open("sample.txt", "r") do |file|
  # Seek to position 8 from start
  file.seek(8, IO::SEEK_SET)
  puts "After seeking to position 8: #{file.read(5).inspect}"

  # Seek 3 bytes forward from current position
  file.seek(3, IO::SEEK_CUR)
  puts "After seeking 3 bytes forward: #{file.read(5).inspect}"

  # Seek 5 bytes back from end of file
  file.seek(-5, IO::SEEK_END)
  puts "Last 5 bytes of file: #{file.read.inspect}"
end

########################################################################
# Handling non-existent files
puts "\n--- Error handling ---"

begin
  content = File.read("non_existent_file.txt")
rescue Errno::ENOENT => e
  puts "File error: #{e.message}"
end

# Alternative with File.exist?
filename = "another_non_existent_file.txt"
if File.exist?(filename)
  content = File.read(filename)
  puts content
else
  puts "File '#{filename}' does not exist"
end

########################################################################
# Reading binary files
puts "\n--- Reading binary files ---"

# Create a simple binary file
File.open("binary_sample", "wb") do |file|
  file.write([65, 66, 67, 0, 255].pack("C*"))
end

# Read binary file
binary_data = File.binread("binary_sample")
puts "Binary data bytes: #{binary_data.bytes.inspect}"

# Clean up test files
File.delete("sample.txt")
File.delete("binary_sample")
