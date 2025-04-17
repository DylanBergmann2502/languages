# Creating strings - different ways
single_quoted = "Hello, Ruby!"
double_quoted = "Hello, Ruby!"
string_method = String.new("Hello, Ruby!")
heredoc = <<TEXT
This is a multi-line string
created using a heredoc.
It preserves whitespace and newlines.
TEXT

puts "Creating strings:"
puts "Single quoted: #{single_quoted}"     # Hello, Ruby!
puts "Double quoted: #{double_quoted}"     # Hello, Ruby!
puts "String.new: #{string_method}"        # Hello, Ruby!
puts "Heredoc:"
puts heredoc                               # Multi-line output

# String interpolation - only works with double quotes
name = "Ruby"
puts "\nString interpolation:"
puts "Hello, #{name}!"                     # Hello, Ruby!
puts 'Hello, #{name}!'                     # Hello, #{name}!
puts "2 + 2 = #{2 + 2}"                    # 2 + 2 = 4

# Escape sequences - different behavior in single vs double quotes
puts "\nEscape sequences:"
puts "Newline: 1\n2"                       # Output on two lines
puts 'Newline: 1\n2'                       # Output: Newline: 1\n2
puts "Tab: 1\t2"                           # Output with tab
puts "Backslash: \\"                       # Output: Backslash: \
puts "Double quote: \""                    # Output: Double quote: "
puts 'Single quote: \''                    # Output: Single quote: '

# Common escape sequences
puts "\nCommon escape sequences (double quotes):"
puts "\\n - Newline: \"Line1\\nLine2\" renders as:\nLine1\nLine2"
puts "\\t - Tab: \"Col1\\tCol2\" renders as:\nCol1\tCol2"
puts "\\r - Carriage return: \"Hello\\rWorld\" renders as:\nWorld"
puts "\\s - Space: \"Hello\\sWorld\" renders as:\nHello World"
puts "\\b - Backspace: \"Hello\\bWorld\" renders as:\nHellWorld"

# String concatenation
puts "\nString concatenation:"
puts "Hello, " + "Ruby!"                   # Hello, Ruby!
puts "Hello, " << "Ruby!"                  # Hello, Ruby!
puts "Hello, ".concat("Ruby!")             # Hello, Ruby!

greeting = "Hello"
greeting << ", " << "Ruby!"
puts greeting                              # Hello, Ruby!

# String multiplication
puts "\nString multiplication:"
puts "Ruby! " * 3                          # Ruby! Ruby! Ruby!

# Accessing characters
str = "Hello, Ruby!"
puts "\nAccessing characters:"
puts "First character: #{str[0]}"          # H
puts "5th character: #{str[4]}"            # o
puts "Last character: #{str[-1]}"          # !
puts "Range (2..6): #{str[2..6]}"          # llo,
puts "Range (2...6): #{str[2...6]}"        # llo,
puts "Offset and length (7, 4): #{str[7, 4]}"  # Ruby

# String methods for accessing parts
puts "\nString access methods:"
puts "First 5 characters: #{str.slice(0, 5)}"  # Hello
puts "First char: #{str.chr}"              # H
puts "First match of 'l': #{str.index("l")}"  # 2
puts "Last match of 'l': #{str.rindex("l")}"  # 3

# String cases
puts "\nString cases:"
puts "Uppercase: #{str.upcase}"            # HELLO, RUBY!
puts "Lowercase: #{str.downcase}"          # hello, ruby!
puts "Capitalize: #{"ruby".capitalize}"    # Ruby
puts "Swapcase: #{str.swapcase}"           # hELLO, rUBY!

mixed_case = "HeLLo"
puts "Original: #{mixed_case}"             # HeLLo
puts "Uppercase? #{mixed_case.upcase?}"    # false
puts "Lowercase? #{mixed_case.downcase?}"  # false

# String transformations
puts "\nString transformations:"
puts "Reverse: #{str.reverse}"             # !ybuR ,olleH
puts "Strip whitespace: #{" hello ".strip}"  # hello
puts "Left strip: #{" hello".lstrip}"      # hello
puts "Right strip: #{"hello ".rstrip}"     # hello
puts "Remove letters: #{"hello".delete("l")}"  # heo
puts "Center (20): #{str.center(20, "*")}"  # ***Hello, Ruby!****
puts "Left justify (20): #{str.ljust(20, "*")}"  # Hello, Ruby!********
puts "Right justify (20): #{str.rjust(20, "*")}"  # ********Hello, Ruby!

# String checking methods
puts "\nString checking methods:"
puts "Contains 'Ruby'? #{str.include?("Ruby")}"     # true
puts "Starts with 'Hello'? #{str.start_with?("Hello")}"  # true
puts "Ends with '!'? #{str.end_with?("!")}"         # true
puts "Empty? #{str.empty?}"                         # false
puts "Empty? #{"".empty?}"                          # true
puts "Blank? #{" \t\n".strip.empty?}"               # true
puts "Length: #{str.length}"                        # 13
puts "Size: #{str.size}"                            # 13
puts "Count of 'l': #{str.count("l")}"             # 2

# String comparison
puts "\nString comparison:"
puts "hello == HELLO: #{"hello" == "HELLO"}"              # false
puts "hello.casecmp?(HELLO): #{"hello".casecmp?("HELLO")}"  # true
puts "abc <=> abd: #{"abc" <=> "abd"}"                    # -1
puts "abc <=> abc: #{"abc" <=> "abc"}"                    # 0
puts "abd <=> abc: #{"abd" <=> "abc"}"                    # 1

# String splitting and joining
str = "apple,banana,orange,grape"
array = str.split(",")
puts "\nString splitting and joining:"
puts "Original: #{str}"                    # apple,banana,orange,grape
puts "Split: #{array.inspect}"             # ["apple", "banana", "orange", "grape"]
puts "Join with '-': #{array.join("-")}"   # apple-banana-orange-grape
puts "Split by character: #{"hello".chars}"  # ["h", "e", "l", "l", "o"]

# String replacement
puts "\nString replacement:"
puts "Replace first: #{str.sub("a", "A")}"  # Apple,banana,orange,grape
puts "Replace all: #{str.gsub("a", "A")}"  # Apple,bAnAnA,orAnge,grApe
puts "Replace with block: #{str.gsub(/[aeiou]/) { |vowel| vowel.upcase }}"  # ApplE,bAnAnA,OrAngE,grApE

text = "ruby programming"
puts "Original: #{text}"                   # ruby programming
puts "Replace (mutating): #{text.sub!("r", "R")}"  # Ruby programming
puts "After mutation: #{text}"             # Ruby programming

# String searching with regular expressions
puts "\nRegular expression searching:"
text = "The year is 2023, month is 05, day is 15"
puts "Contains digit? #{text =~ /\d/}"     # 13 (position of first match)
puts "Matches for digits: #{text.scan(/\d+/)}"  # ["2023", "05", "15"]
puts "Valid email? #{"user@example.com" =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i ? "Yes" : "No"}"  # Yes

# String encoding
puts "\nString encoding:"
puts "Default encoding: #{str.encoding}"              # UTF-8
japanese = "こんにちは"
puts "Japanese string: #{japanese}"                  # こんにちは
puts "Japanese encoding: #{japanese.encoding}"       # UTF-8
puts "Japanese length: #{japanese.length}"           # 5
puts "Japanese bytesize: #{japanese.bytesize}"       # 15

# Freezing strings
puts "\nFreezing strings:"
frozen_str = "Hello".freeze
puts "Frozen: #{frozen_str}"                          # Hello
puts "Frozen? #{frozen_str.frozen?}"                  # true

begin
  frozen_str << " World"
rescue RuntimeError => e
  puts "Error modifying frozen string: #{e.message}"  # can't modify frozen String
end

# String formatting
puts "\nString formatting:"
printf "Formatted: %s, %d, %.2f\n", "string", 42, 3.14159  # Formatted: string, 42, 3.14
puts format("Formatted: %s, %d, %.2f", "string", 42, 3.14159)  # Formatted: string, 42, 3.14

# Interpolated string as expressions
puts "\nInterpolated strings as expressions:"
operation = "+"
puts "5 #{operation} 3 = #{5.send(operation, 3)}"  # 5 + 3 = 8

# Here document (heredoc) with indentation control
puts "\nHeredoc with indentation control:"
code = <<~RUBY
  def hello
    puts "Hello, world!"
  end
  
  hello()
RUBY

puts code
# def hello
#   puts "Hello, world!"
# end
#
# hello()

# String type checking
puts "\nString type checking:"
puts "Hello".is_a?(String)                 # true
puts "Hello".kind_of?(String)              # true
puts "Hello".instance_of?(String)          # true
