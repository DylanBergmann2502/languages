# Pathname is a class for representing file paths
# It provides methods for working with paths without performing actual I/O operations
# First, let's require the pathname library
require "pathname"

########################################################################
# Creating Pathname objects
# You can create a Pathname object from a string
path = Pathname.new("/home/user/documents/file.txt")
puts path # /home/user/documents/file.txt

# Or create from multiple path segments using Pathname.join
joined_path = Pathname.new("/home").join("user", "documents", "file.txt")
puts joined_path # /home/user/documents/file.txt

# Pathname.pwd returns the current working directory as a Pathname object
current_dir = Pathname.pwd
puts "Current directory: #{current_dir}"

########################################################################
# Path components
# Pathname provides methods to access different parts of the path

# Get the basename (filename)
puts path.basename # file.txt
# Get basename without the extension
puts path.basename(".txt") # file

# Get the dirname (directory portion)
puts path.dirname # /home/user/documents

# Get the extname (file extension)
puts path.extname # .txt

# Split a path into its directory and basename components
dir, base = path.split
puts "Directory: #{dir}, Basename: #{base}" # Directory: /home/user/documents, Basename: file.txt

########################################################################
# Path manipulations
# Pathname provides methods to create new paths based on existing ones

# Join paths using the / operator
new_path = Pathname.new("/home/user") / "documents" / "file.txt"
puts new_path # /home/user/documents/file.txt

# Append a string to a path
path_with_suffix = path.sub_ext(".bak")
puts path_with_suffix # /home/user/documents/file.bak

# Get absolute path
relative_path = Pathname.new("docs/file.txt")
abs_path = relative_path.expand_path
puts "Relative: #{relative_path}, Absolute: #{abs_path}"

# Relative paths
path1 = Pathname.new("/home/user/documents")
path2 = Pathname.new("/home/user/downloads/file.txt")
rel_path = path2.relative_path_from(path1)
puts rel_path # ../downloads/file.txt

########################################################################
# Path normalization
# Pathname can clean up and normalize paths

# Clean up redundant path components
messy_path = Pathname.new("/home/user/../user/./documents//file.txt")
puts messy_path.cleanpath # /home/user/documents/file.txt

# Resolve symbolic links (doesn't perform actual I/O operations)
puts path.realpath if path.exist? # This would resolve all symlinks if the path exists

########################################################################
# Path tests
# Pathname provides methods to test properties of paths (without performing I/O operations)

# Path type checks
puts "Is absolute? #{path.absolute?}" # true
puts "Is relative? #{relative_path.relative?}" # true
puts "Is root? #{path.root?}" # false

# Path comparisons
path_a = Pathname.new("/home/user/documents")
path_b = Pathname.new("/home/user/documents")
path_c = Pathname.new("/home/user/downloads")
puts "path_a == path_b: #{path_a == path_b}" # true
puts "path_a == path_c: #{path_a == path_c}" # false

########################################################################
# File operations
# Pathname wraps File and Dir methods for convenient file operations

# File existence checks (these do perform I/O operations)
test_path = Pathname.pwd.join("test_file.txt")

# Create a test file
File.write(test_path, "test content")

# Check existence
puts "Exists? #{test_path.exist?}" # true
puts "File? #{test_path.file?}" # true
puts "Directory? #{test_path.directory?}" # false

# Reading and writing
content = test_path.read
puts "File content: #{content}" # File content: test content

test_path.write("new content")
puts "Updated content: #{test_path.read}" # Updated content: new content

# File metadata
puts "Size: #{test_path.size} bytes" # Size: 11 bytes
puts "Mtime: #{test_path.mtime}" # Last modification time

# Directory operations
if test_path.exist?
  # Delete our test file
  test_path.delete
  puts "Test file deleted"
end

# Create a directory
test_dir = Pathname.pwd.join("test_dir")
test_dir.mkdir unless test_dir.exist?
puts "Created directory: #{test_dir}" if test_dir.exist?

# List directory contents
Pathname.pwd.children.each do |child|
  puts "- #{child.basename} (#{child.file? ? "file" : "directory"})"
end

# Clean up test directory
test_dir.rmdir if test_dir.exist?
puts "Test directory removed" unless test_dir.exist?

########################################################################
# Traversing file hierarchies
# Pathname makes it easy to traverse directory trees

# Find all .rb files in the current directory and subdirectories
rb_files = Pathname.pwd.glob("**/*.rb")
puts "Ruby files in this directory:"
rb_files.each do |file|
  puts "- #{file.relative_path_from(Pathname.pwd)}"
end

# A simple recursive directory listing (limited to 2 levels for brevity)
def list_directory(path, level = 0, max_level = 2)
  return if level > max_level

  indent = "  " * level
  puts "#{indent}#{path.basename}/"

  path.children.sort.each do |child|
    if child.directory?
      list_directory(child, level + 1, max_level)
    else
      puts "#{indent}  #{child.basename}"
    end
  end
end

# Uncomment to see directory listing
list_directory(Pathname.pwd)
