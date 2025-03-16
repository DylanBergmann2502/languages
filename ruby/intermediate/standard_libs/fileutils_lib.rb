# FileUtils module provides methods for file operations like copying, moving, removing files/directories
# It's very useful when you need to manipulate files without using system commands
require 'fileutils'

##############################################################################
# Basic file operations
# Create a test directory to work with
FileUtils.mkdir_p('test_dir/nested_dir') unless Dir.exist?('test_dir/nested_dir')
puts "Directory created: #{Dir.exist?('test_dir/nested_dir')}" # true

# Create some test files
File.write('test_dir/file1.txt', 'Hello World')
File.write('test_dir/file2.txt', 'Ruby FileUtils')

##############################################################################
# Copying files
# cp copies a file, keeping the same permissions
FileUtils.cp('test_dir/file1.txt', 'test_dir/file1_copy.txt')
puts "Copy exists: #{File.exist?('test_dir/file1_copy.txt')}" # true
puts "Original content: #{File.read('test_dir/file1.txt')}"
puts "Copy content: #{File.read('test_dir/file1_copy.txt')}"

# cp_r recursively copies directories and their contents
FileUtils.cp_r('test_dir', 'test_dir_copy')
puts "Recursive copy exists: #{Dir.exist?('test_dir_copy/nested_dir')}" # true

##############################################################################
# Moving/renaming files
# mv moves or renames files
FileUtils.mv('test_dir/file2.txt', 'test_dir/renamed.txt')
puts "Original file exists: #{File.exist?('test_dir/file2.txt')}" # false
puts "Renamed file exists: #{File.exist?('test_dir/renamed.txt')}" # true

# You can also move files to another directory
FileUtils.mv('test_dir/renamed.txt', 'test_dir/nested_dir/')
puts "Moved file exists: #{File.exist?('test_dir/nested_dir/renamed.txt')}" # true

##############################################################################
# Removing files and directories
# rm removes files
FileUtils.rm('test_dir/file1_copy.txt')
puts "Removed file exists: #{File.exist?('test_dir/file1_copy.txt')}" # false

# rm_r recursively removes directories and their contents
FileUtils.rm_r('test_dir_copy')
puts "Removed directory exists: #{Dir.exist?('test_dir_copy')}" # false

# rm_rf does the same but ignores errors (force)
FileUtils.rm_rf('non_existent_dir') # No error raised

##############################################################################
# Changing permissions
# chmod changes file permissions (similar to Unix chmod)
FileUtils.chmod(0755, 'test_dir/file1.txt')
file_mode = File.stat('test_dir/file1.txt').mode & 0777 # Get file permissions
puts "File permissions (octal): #{file_mode.to_s(8)}"

# chmod_R recursively changes permissions
FileUtils.chmod_R(0700, 'test_dir/nested_dir')

##############################################################################
# Touching files (update timestamp or create if doesn't exist)
FileUtils.touch('test_dir/touched_file.txt')
puts "Touched file exists: #{File.exist?('test_dir/touched_file.txt')}" # true

# You can touch multiple files at once
FileUtils.touch(['test_dir/batch1.txt', 'test_dir/batch2.txt'])

##############################################################################
# Comparing files
# compare returns true if the files are identical
File.write('test_dir/a.txt', 'content')
File.write('test_dir/b.txt', 'content')
File.write('test_dir/c.txt', 'different content')

puts "a.txt == b.txt: #{FileUtils.compare_file('test_dir/a.txt', 'test_dir/b.txt')}" # true
puts "a.txt == c.txt: #{FileUtils.compare_file('test_dir/a.txt', 'test_dir/c.txt')}" # false

##############################################################################
# Creating symbolic links (handling Windows permission issues)
begin
  # ln_s creates a symbolic link
  FileUtils.ln_s('test_dir/file1.txt', 'test_dir/symlink_to_file1')
  puts "Is symlink: #{File.symlink?('test_dir/symlink_to_file1')}" # true
rescue Errno::EACCES => e
  puts "Note: Symbolic link creation failed due to permissions (common on Windows): #{e.message}"
  puts "On Windows, you may need to run as administrator or enable Developer Mode to create symlinks"
end

##############################################################################
# Using the install method to copy files and set permissions in one step
FileUtils.install('test_dir/file1.txt', 'test_dir/installed.txt', mode: 0644)
puts "Installed file exists: #{File.exist?('test_dir/installed.txt')}" # true

##############################################################################
# Directory operations
# Safely create nested directories
FileUtils.mkdir_p('test_dir/a/b/c')
puts "Nested directory created: #{Dir.exist?('test_dir/a/b/c')}" # true

# Get current directory
pwd = FileUtils.pwd
puts "Current directory: #{pwd}"

# Changing directory (temporarily)
original_dir = Dir.pwd
Dir.chdir('test_dir') do
  puts "Temporarily in: #{Dir.pwd}"
  # Do work in test_dir
end
puts "Back in: #{Dir.pwd}" # Should be the original directory

##############################################################################
# Safety and verbosity options
# Most FileUtils methods accept :noop, :verbose, and :force options

# :noop means "no operation" - doesn't actually perform the operation
FileUtils.rm('test_dir/a.txt', noop: true)
puts "File still exists after noop: #{File.exist?('test_dir/a.txt')}" # true

# :verbose outputs operations as they happen
FileUtils.rm('test_dir/a.txt', verbose: true) # Outputs: rm test_dir/a.txt

##############################################################################
# Cleanup
FileUtils.rm_rf('test_dir')
puts "Test directory removed: #{!Dir.exist?('test_dir')}" # true