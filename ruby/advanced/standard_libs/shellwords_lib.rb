require 'shellwords'

puts "== Basic Shellwords Usage =="

# Shellwords.escape: Escapes special characters in a string for shell commands
command = "grep 'search term' filename.txt"
escaped_command = Shellwords.escape(command)
puts "Original command: #{command}"
puts "Escaped command: #{escaped_command}"

# Shellwords.join: Joins an array of strings into a single shell command string
args = ["ls", "-la", "~/Documents/file with spaces.txt"]
command = Shellwords.join(args)
puts "\nArray joined for shell: #{command}"

# Shellwords.split: Splits a shell command string into an array of arguments
command = "git commit -m 'Initial commit with some changes'"
args = Shellwords.split(command)
puts "\nSplit command arguments:"
args.each_with_index { |arg, i| puts "  Arg #{i}: #{arg}" }

# Real-world example: Running a shell command safely
puts "\n== Practical Example: Building Safe Shell Commands =="

# Unsafe approach (don't do this!)
user_input = "file with spaces.txt; rm -rf ~"
unsafe_command = "cat #{user_input}"
puts "Unsafe command: #{unsafe_command}"
# This would be dangerous if executed!

# Safe approach with Shellwords
safe_command = "cat #{Shellwords.escape(user_input)}"
puts "Safe command: #{safe_command}"

# Safe approach with array and join
command_parts = ["cat", user_input]
safe_command2 = Shellwords.join(command_parts)
puts "Safe command (array method): #{safe_command2}"

# Safe approach with system and array arguments (preferred method)
# system("cat", user_input) # Commented to prevent actual execution

puts "\n== Handling Paths with Spaces =="
path_with_spaces = "My Documents/file name.txt"
escaped_path = Shellwords.escape(path_with_spaces)
puts "Original path: #{path_with_spaces}"
puts "Escaped path: #{escaped_path}"

puts "\n== Shellwords Module Methods =="
# The correct way to use Shellwords module methods
command_line = "echo 'hello world'"
args = Shellwords.shellsplit(command_line)  # shellsplit is an alias for split
puts "Using Shellwords.shellsplit:"
puts args.inspect

# Shorthand module method access
command_line = "grep -i 'important stuff' *.log"
args = Shellwords.shellwords(command_line)  # shellwords is also an alias for split
puts "\nUsing Shellwords.shellwords:"
puts args.inspect

# If you want String#shellwords as an instance method, you need to include it
puts "\n== Extending String with Shellwords =="
class String
  include Shellwords
  def shellwords
    shellsplit
  end
end

# Now we can use the instance method
string_result = "echo 'hello world'".shellwords
puts "Using our custom String#shellwords extension:"
puts string_result.inspect