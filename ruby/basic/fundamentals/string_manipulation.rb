# String Manipulation in Ruby
# Ruby offers many powerful ways to work with strings

########################################################################
# Creating Strings
puts "Different ways to create strings:"
single_quoted = "Hello"
double_quoted = "World"
string_method = String.new("Hello World")

puts single_quoted  # Hello
puts double_quoted  # World
puts string_method  # Hello World

# Multiline strings using heredoc
multiline = <<~HEREDOC
  This is a multiline string.
  It preserves line breaks and formatting.
  It's useful for longer text blocks.
HEREDOC

puts multiline

########################################################################
# String Concatenation
puts "\nString Concatenation:"
# Using the + operator
name = "Ruby"
greeting = "Hello, " + name + "!"
puts greeting  # Hello, Ruby!

# Using the << operator (modifies the original string)
message = "Hello"
message << ", " << "Ruby" << "!"
puts message  # Hello, Ruby!

# Using String#concat
str = "Hello"
str.concat(", ", "Ruby", "!")
puts str  # Hello, Ruby!

########################################################################
# String Interpolation (only works with double quotes)
puts "\nString Interpolation:"
name = "Ruby"
age = 30
puts "#{name} is #{age} years old."  # Ruby is 30 years old.
puts '#{name} is #{age} years old.'  # #{name} is #{age} years old.

# Interpolation can include expressions
puts "5 + 5 = #{5 + 5}"  # 5 + 5 = 10

########################################################################
# Accessing Characters
puts "\nAccessing Characters:"
str = "Hello"
puts str[0]       # H (first character)
puts str[1]       # e
puts str[-1]      # o (last character)
puts str[0, 3]    # Hel (3 characters starting from index 0)
puts str[1..3]    # ell (characters from index 1 to 3, inclusive)
puts str[1...3]   # el (characters from index 1 to 2, exclusive of index 3)

########################################################################
# String Methods for Changing Case
puts "\nChanging Case:"
message = "hElLo, WoRlD!"
puts message.upcase       # HELLO, WORLD!
puts message.downcase     # hello, world!
puts message.capitalize   # Hello, world!
puts message.swapcase     # HeLlO, wOrLd!

# These methods don't change the original string
puts message              # hElLo, WoRlD!

# For modifying the original string, use methods with ! suffix
message.upcase!
puts message              # HELLO, WORLD!

########################################################################
# Checking String Content
puts "\nChecking String Content:"
text = "Hello, Ruby World!"

puts text.include?("Ruby")     # true
puts text.start_with?("Hello") # true
puts text.end_with?("!")       # true
puts text.empty?               # false
puts "".empty?                 # true
puts text.nil?                 # false
puts nil.to_s.empty?           # true

########################################################################
# Finding Substrings
puts "\nFinding Substrings:"
text = "Ruby is fun. Ruby is powerful."

puts text.index("Ruby")        # 0 (index of first occurrence)
puts text.rindex("Ruby")       # 13 (index of last occurrence)
puts text.count("u")           # 3 (number of 'u' characters)

# Using regular expressions
puts text =~ /fun/             # 8 (index of match)
puts text.match(/fun/).to_s    # fun (the matched text)

########################################################################
# Replacing Content
puts "\nReplacing Content:"
text = "Ruby is fun. Ruby is powerful."

# Replace first occurrence
puts text.sub("Ruby", "Python")  # Python is fun. Ruby is powerful.

# Replace all occurrences
puts text.gsub("Ruby", "Python") # Python is fun. Python is powerful.

# With regular expressions
puts text.gsub(/[aeiou]/, "*")   # R*by *s f*n. R*by *s p*w*rf*l.

# Original string remains unchanged
puts text                       # Ruby is fun. Ruby is powerful.

# Use sub! or gsub! to modify the original
text.gsub!("Ruby", "Python")
puts text                       # Python is fun. Python is powerful.

########################################################################
# Splitting and Joining
puts "\nSplitting and Joining:"
sentence = "Ruby is a programming language"

# Split string into an array of words
words = sentence.split
puts words.inspect               # ["Ruby", "is", "a", "programming", "language"]

# Split with custom delimiter
csv = "apple,banana,orange"
fruits = csv.split(",")
puts fruits.inspect              # ["apple", "banana", "orange"]

# Join array elements into a string
puts words.join(" ")             # Ruby is a programming language
puts fruits.join(", ")           # apple, banana, orange

########################################################################
# Trimming Whitespace
puts "\nTrimming Whitespace:"
text = "  Hello, World!  "

puts text.strip                 # "Hello, World!" (removes leading/trailing spaces)
puts text.lstrip                # "Hello, World!  " (removes leading spaces)
puts text.rstrip                # "  Hello, World!" (removes trailing spaces)

########################################################################
# String Formatting
puts "\nString Formatting:"
# Using format (printf style)
puts format("Name: %s, Age: %d", "Alice", 30)  # Name: Alice, Age: 30

# Using formatted string literals (Ruby 2.6+)
name = "Alice"
age = 30
puts "Name: #{name}, Age: #{age}"  # Name: Alice, Age: 30

########################################################################
# Converting to/from Other Types
puts "\nType Conversion:"
number = 42
puts number.to_s        # "42" (integer to string)
puts "42".to_i          # 42 (string to integer)
puts "3.14".to_f        # 3.14 (string to float)
puts [1, 2, 3].to_s     # "[1, 2, 3]" (array to string)

########################################################################
# Freezing Strings
puts "\nFreezing Strings:"
str = "Hello"
str.freeze  # Makes the string immutable

begin
  str[0] = "J"
rescue => e
  puts "Error: #{e.message}"  # Error: can't modify frozen String
end

# A literal string with a freeze comment (Ruby 2.3+) is automatically frozen
frozen_str = "I'm frozen"  # frozen_string_literal: true
puts frozen_str.frozen?    # true or false depending on Ruby version and settings

########################################################################
# Other Useful String Methods
puts "\nOther Useful Methods:"
text = "hello world"

puts text.length        # 11 (number of characters)
puts text.size          # 11 (alias for length)
puts text.reverse       # dlrow olleh
puts text.chars         # ["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"]
puts text.chars.uniq    # ["h", "e", "l", "o", " ", "w", "r", "d"]
puts text.ljust(15, "*")  # hello world****
puts text.rjust(15, "*")  # ****hello world
puts text.center(15, "*") # **hello world**
puts "42".rjust(5, "0")   # 00042 (useful for padding numbers)
