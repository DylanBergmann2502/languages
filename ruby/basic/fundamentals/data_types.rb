# Data Types in Ruby
# Ruby has several built-in data types

########################################################################
# Numbers: Integers and Floats
integer = 42
float = 3.14

puts integer        # 42
puts float          # 3.14
puts integer.class  # Integer
puts float.class    # Float

# Math operations
puts 5 + 3          # 8 (addition)
puts 5 - 3          # 2 (subtraction)
puts 5 * 3          # 15 (multiplication)
puts 5 / 3          # 1 (integer division)
puts 5.0 / 3        # 1.6666666666666667 (float division)
puts 5 % 3          # 2 (modulo/remainder)
puts 5 ** 3         # 125 (exponentiation)

########################################################################
# Strings: Sequences of characters
single_quoted = "Hello"
double_quoted = 'World'

puts single_quoted + " " + double_quoted  # Hello World

# String interpolation (only works with double quotes)
name = "Ruby"
puts "Hello, #{name}!"  # Hello, Ruby!
puts 'Hello, #{name}!'  # Hello, #{name}!

# Common string methods
phrase = "hello world"
puts phrase.upcase      # HELLO WORLD
puts phrase.capitalize  # Hello world
puts phrase.length      # 11
puts phrase.split       # ["hello", "world"]
puts phrase.include?("hello")  # true

########################################################################
# Symbols: Immutable, reusable identifiers
# Symbols are like strings but are used for identifiers
# They start with a colon
status = :success
puts status         # success
puts status.class   # Symbol

# Symbols with the same name refer to the same object
puts :success.object_id == :success.object_id  # true
puts "success".object_id == "success".object_id  # false

########################################################################
# Booleans: true and false
is_sunny = true
is_raining = false

puts is_sunny         # true
puts is_raining       # false
puts is_sunny.class   # TrueClass
puts is_raining.class # FalseClass

########################################################################
# nil: Ruby's "nothing" value
empty_value = nil
puts empty_value        # nil
puts empty_value.class  # NilClass
puts empty_value.nil?   # true

########################################################################
# Arrays: Ordered collections of objects
fruits = ["apple", "banana", "orange"]
puts fruits         # Prints each element on a new line
puts fruits.class   # Array
puts fruits[0]      # apple (first element)
puts fruits[-1]     # orange (last element)
puts fruits.length  # 3

# Arrays can contain mixed types
mixed = [1, "two", :three, 4.0, nil, true]
puts mixed          # Prints each element on a new line

########################################################################
# Hashes: Collections of key-value pairs
person = {
  "name" => "Alice",
  "age" => 30,
  "is_student" => true,
}

puts person["name"]  # Alice
puts person.class    # Hash

# Symbol keys are more common in modern Ruby code
person = {
  name: "Alice",
  age: 30,
  is_student: true,
}

puts person[:name]   # Alice

########################################################################
# Ranges: Sequences of values
digit_range = 0..9        # Inclusive range (includes 9)
alpha_range = "a"..."z"   # Exclusive range (excludes 'z')

puts digit_range.class    # Range
puts digit_range.to_a     # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
puts alpha_range.to_a     # ["a", "b", "c", ... "y"]

########################################################################
# Type conversion
puts "5".to_i        # 5 (string to integer)
puts 5.to_s          # "5" (integer to string)
puts 5.to_f          # 5.0 (integer to float)
puts [1, 2, 3].to_s  # "[1, 2, 3]" (array to string)
