# The most basic way to output "Hello, World!" in Ruby
puts "Hello, World!"

########################################################################
# In Ruby, there are several ways to create and display strings
print "Hello, World!\n" # print doesn't automatically add a newline
p "Hello, World!"       # p inspects and prints the object (shows quotes)

# String interpolation allows embedding Ruby expressions inside strings
name = "Ruby"
puts "Hello, #{name}!"  # Hello, Ruby!

########################################################################
# Ruby has both single and double quotes for strings
puts 'Hello, World!'    # Single quotes
puts "Hello, World!"    # Double quotes

# The difference is that double quotes allow for escape sequences and interpolation
puts "Hello,\nWorld!"   # Prints on two lines
puts 'Hello,\nWorld!'   # Prints exactly as is, including \n as characters

########################################################################
# Ruby also has heredocs for multi-line strings
message = <<~HEREDOC
  Hello,
  World!
  This is a multi-line string in Ruby.
HEREDOC

puts message

########################################################################
# You can also use string methods
greeting = "hello, world!"
puts greeting.upcase      # HELLO, WORLD!
puts greeting.capitalize  # Hello, world!
puts greeting.reverse     # !dlrow ,olleh

########################################################################
# In Ruby, everything is an object, even literals
puts "Hello, World!".class  # String
puts "Hello, World!".length # 13
puts "Hello, World!".chars  # ["H", "e", "l", "l", "o", ",", " ", "W", "o", "r", "l", "d", "!"]

# You can chain methods
puts "Hello, World!".upcase.reverse  # !DLROW ,OLLEH
