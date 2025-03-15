# writing.rb - Basic file writing operations in Ruby

########################################################################
# Writing to a file - basic methods
puts "--- Basic file writing ---"

# Write entire string to file at once (creates file if it doesn't exist)
File.write("output.txt", "Hello, Ruby file writing!\nThis is line 2.")
puts "File written with #{File.size("output.txt")} bytes"

# Read it back to verify
content = File.read("output.txt")
puts "Content: #{content.inspect}"

########################################################################
# Appending to files
puts "\n--- Appending to files ---"

# Append to existing file
File.write("output.txt", "\nThis line was appended.", mode: "a")
puts "After append: #{File.read("output.txt").inspect}"

# Another way to append using open with 'a' mode
File.open("output.txt", "a") do |file|
  file.puts "\nAnother appended line using puts"
  file.write "And another using write (no automatic newline)"
end

puts "After second append: #{File.read("output.txt").inspect}"

########################################################################
# Writing line by line
puts "\n--- Writing line by line ---"

lines = ["Line 1", "Line 2", "Line 3", "Line 4"]

File.open("lines.txt", "w") do |file|
  lines.each do |line|
    file.puts line  # puts adds a newline after each line
  end
end

puts "Lines file content:"
puts File.read("lines.txt")

########################################################################
# Writing with different modes
puts "\n--- File modes ---"

# 'w' - Write mode (creates new file or truncates existing one)
File.open("modes.txt", "w") do |file|
  file.puts "This will create a new file or overwrite existing"
end

# 'w+' - Write and read mode
File.open("modes.txt", "w+") do |file|
  file.puts "This can be written and then read"
  file.rewind  # Go back to start of file
  puts "Read back: #{file.read.inspect}"
end

# 'a+' - Append and read mode
File.open("modes.txt", "a+") do |file|
  file.puts "This is appended"
  file.rewind  # Go back to start of file
  puts "Read back after append: #{file.read.inspect}"
end

########################################################################
# Writing binary data
puts "\n--- Writing binary data ---"

# Create an array of bytes
bytes = [82, 117, 98, 121, 0, 255]

# Write binary data
File.binwrite("binary_file", bytes.pack("C*"))
puts "Wrote #{File.size("binary_file")} bytes of binary data"

# Read it back
binary_content = File.binread("binary_file")
puts "Binary data read back: #{binary_content.bytes.inspect}"

########################################################################
# File operations with error handling
puts "\n--- Error handling while writing ---"

begin
  # Try to write to a directory that doesn't exist
  File.write("/nonexistent_dir/test.txt", "This will fail")
rescue Errno::ENOENT => e
  puts "Error: #{e.message}"
end

# Try with a block that ensures file is closed even if there's an error
begin
  File.open("output_with_error.txt", "w") do |file|
    file.puts "This line will be written"
    # Simulate an error
    raise "Simulated error during writing"
    file.puts "This line won't be written"
  end
rescue => e
  puts "Caught error: #{e.message}"
  puts "File was properly closed by the block"
  if File.exist?("output_with_error.txt")
    puts "Content of file after error: #{File.read("output_with_error.txt").inspect}"
  end
end

########################################################################
# Writing with explicit encoding
puts "\n--- Writing with encoding ---"

# Write a file with UTF-8 encoding
File.open("utf8_file.txt", "w:UTF-8") do |file|
  file.puts "This is UTF-8 text with special chars: éêèàâäëüñ"
end

# Read it back and check encoding
utf8_content = File.read("utf8_file.txt")
puts "UTF-8 file encoding: #{utf8_content.encoding}"
puts "UTF-8 content: #{utf8_content}"

# Clean up test files
puts "\n--- Cleaning up ---"
["output.txt", "lines.txt", "modes.txt", "binary_file",
 "output_with_error.txt", "utf8_file.txt"].each do |file|
  File.delete(file) if File.exist?(file)
end
puts "All test files deleted"
