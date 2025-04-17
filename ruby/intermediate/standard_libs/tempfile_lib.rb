# Tempfile creates temporary files that are automatically deleted when closed
# It's useful for working with temporary data that should not persist
require "tempfile"

########################################################################
# Creating a Tempfile
# You can create a basic Tempfile or customize with basename and directory

# Basic Tempfile
# Creates a file with a random name in the system's temp directory
basic_temp = Tempfile.new
puts "Basic temp path: #{basic_temp.path}"
puts "File exists? #{File.exist?(basic_temp.path)}"

# Tempfile with a basename
# The actual filename will be basename + random string
named_temp = Tempfile.new("my_prefix")
puts "Named temp path: #{named_temp.path}"  # Something like /tmp/my_prefix20230316-12345-abc123

# Tempfile with basename and extension
# Use an array: [basename, extension]
html_temp = Tempfile.new(["webpage", ".html"])
puts "HTML temp path: #{html_temp.path}"  # Something like /tmp/webpage20230316-12345-abc123.html

# Tempfile in specific directory
custom_dir_temp = Tempfile.new("custom", Dir.pwd)
puts "Custom dir temp: #{custom_dir_temp.path}"  # Uses current directory instead of system temp

########################################################################
# Working with Tempfile contents
# Tempfile offers the same methods as File for reading and writing

# Writing to a Tempfile
content_temp = Tempfile.new
content_temp.write("Hello, temporary world!")
content_temp.rewind  # Move position back to beginning
puts content_temp.read  # "Hello, temporary world!"

# Using blocks for automatic file handling
Tempfile.open("block_example") do |file|
  file.puts "Line 1"
  file.puts "Line 2"
  file.puts "Line 3"
  file.rewind
  puts file.read  # Outputs all three lines
end  # File is automatically closed after block

# Using the Tempfile with other IO methods
csv_temp = Tempfile.new(["data", ".csv"])
csv_temp.puts "id,name,value"
csv_temp.puts "1,apple,2.50"
csv_temp.puts "2,banana,1.75"
csv_temp.puts "3,orange,3.25"
csv_temp.rewind

# Read line by line
csv_temp.each_line.with_index do |line, index|
  puts "Line #{index + 1}: #{line.chomp}"
end

########################################################################
# Cleaning up Tempfiles
# Tempfiles are designed to be automatically cleaned up

# Method 1: Using #close to close the file (still exists on filesystem)
basic_temp.close
puts "After close - File exists? #{File.exist?(basic_temp.path)}"

# Method 2: Using #close! to close AND unlink the file (removes from filesystem)
named_temp_path = named_temp.path  # Store the path before closing
named_temp.close!
puts "After close! - File exists? #{File.exist?(named_temp_path)}"
puts "Path after close!: #{named_temp.path.inspect}"  # Will show nil

# Method 3: Using #unlink to mark file for deletion when closed
# The file stays open but will be deleted once closed
html_temp.unlink
puts "After unlink - File exists? #{File.exist?(html_temp.path)}"
puts "After unlink - Can still write? #{!html_temp.closed?}"
html_temp.close
puts "After close following unlink - File exists? #{File.exist?(html_temp.path)}"

########################################################################
# Persistence and cleanup behavior

# Tempfiles are removed if Ruby exits normally
puts "Temp files are automatically deleted when your Ruby process exits cleanly"

# But they might not be removed if Ruby crashes or is terminated abruptly
puts "However, if your program crashes, temp files might remain on disk"

# For critical cleanup, you can use at_exit
cleanup_temp = Tempfile.new("cleanup_example")
puts "Created: #{cleanup_temp.path}"

at_exit do
  puts "Cleaning up tempfile in at_exit hook"
  cleanup_temp.close!
end

########################################################################
# Real-world use cases

# 1. Processing uploaded files
def process_upload(uploaded_content)
  temp = Tempfile.new(["upload", ".dat"])
  temp.binmode  # Important for binary data
  temp.write(uploaded_content)
  temp.rewind

  # Process the data
  result = "Processed #{temp.size} bytes of data"

  temp.close!
  return result
end

puts process_upload("Simulated file upload content")

# 2. Creating a temp file and counting lines (cross-platform)
text_temp = Tempfile.new(["input", ".txt"])
text_temp.write("Ruby\nPython\nJavaScript\nGo\n")
text_temp.close  # Close but don't delete yet

# Count lines by reading the file directly (works on all platforms)
line_count = File.readlines(text_temp.path).size
puts "File has #{line_count} lines"

text_temp.unlink  # Now delete the file

# 3. As a temporary storage for downloaded content
def download_and_process(url)
  # In a real app, you'd download content from the URL
  content = "Downloaded content from #{url}"

  temp = Tempfile.new("download")
  temp.write(content)
  temp.rewind

  # Process downloaded content
  processed = temp.read.upcase

  temp.close!
  return processed
end

puts download_and_process("https://example.com/data.txt")

########################################################################
# Working with binary data
binary_temp = Tempfile.new("binary")
binary_temp.binmode  # Set to binary mode for non-text data
binary_data = [0xFF, 0x00, 0xAA, 0x55].pack("C*")  # Some binary data
binary_temp.write(binary_data)
binary_temp.rewind

# Read binary data back
binary_temp.binmode
read_data = binary_temp.read
puts "Binary data length: #{read_data.bytesize} bytes"
puts "Binary data bytes: #{read_data.bytes.map { |b| "0x#{b.to_s(16).upcase}" }.join(", ")}"

binary_temp.close!

########################################################################
# Tempfile vs File.open differences
# 1. Tempfile creates a unique filename automatically
# 2. Tempfile provides methods for secure cleanup
# 3. Tempfile is designed for temporary storage that shouldn't persist
