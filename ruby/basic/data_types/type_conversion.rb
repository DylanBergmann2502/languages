# Ruby provides multiple ways to convert between different data types

# 1. Converting to String
puts "Converting to Strings:"
puts "Integer to String: #{42.to_s}"                # "42"
puts "Float to String: #{3.14.to_s}"                # "3.14"
puts "Symbol to String: #{:ruby.to_s}"              # "ruby"
puts "Array to String: #{[1, 2, 3].to_s}"           # "[1, 2, 3]"
puts "Hash to String: #{{ a: 1, b: 2 }.to_s}"         # "{:a=>1, :b=>2}"
puts "nil to String: #{nil.to_s}"                   # "" (empty string)
puts "true to String: #{true.to_s}"                 # "true"
puts "false to String: #{false.to_s}"               # "false"

# Formatting numbers as strings
puts "\nFormatting numbers in strings:"
puts "Integer with formatting: #{sprintf("%04d", 42)}"       # "0042"
puts "Float with 2 decimals: #{sprintf("%.2f", 3.14159)}"    # "3.14"
puts "Float with scientific notation: #{sprintf("%e", 1234.5678)}"  # "1.234568e+03"

# 2. Converting to Integer
puts "\nConverting to Integers:"
puts "String to Integer: #{"42".to_i}"               # 42
puts "Float to Integer: #{3.99.to_i}"                # 3 (truncates decimal)
puts "Boolean to Integer: #{true.to_i rescue "Not supported"}"  # Not supported
puts "String with non-digits: #{"42abc".to_i}"       # 42 (stops at non-digit)
puts "Empty string to Integer: #{"".to_i}"           # 0
puts "Invalid string: #{"abc".to_i}"                 # 0
puts "nil to Integer: #{nil.to_i}"                   # 0

# Integer conversion with different bases
puts "\nInteger conversion with bases:"
puts "Binary '101' to Integer: #{"101".to_i(2)}"     # 5
puts "Octal '777' to Integer: #{"777".to_i(8)}"      # 511
puts "Hex 'FF' to Integer: #{"FF".to_i(16)}"         # 255
puts "Base 36 'ruby' to Integer: #{"ruby".to_i(36)}" # 1299022

# Using Integer() method (stricter conversion)
puts "\nUsing Integer() method:"
puts "String to Integer: #{Integer("42")}"           # 42
puts "Float to Integer: #{Integer(3.99)}"            # 3
begin
  Integer("abc")
rescue ArgumentError => e
  puts "Invalid string error: #{e.message}"          # invalid value for Integer(): "abc"
end

# 3. Converting to Float
puts "\nConverting to Floats:"
puts "Integer to Float: #{42.to_f}"                  # 42.0
puts "String to Float: #{"3.14".to_f}"               # 3.14
puts "String with non-digits: #{"3.14abc".to_f}"     # 3.14
puts "Invalid string: #{"abc".to_f}"                 # 0.0
puts "nil to Float: #{nil.to_f}"                     # 0.0

# Using Float() method (stricter conversion)
puts "\nUsing Float() method:"
puts "String to Float: #{Float("3.14")}"             # 3.14
begin
  Float("abc")
rescue ArgumentError => e
  puts "Invalid string error: #{e.message}"          # invalid value for Float(): "abc"
end

# 4. Converting to Symbol
puts "\nConverting to Symbols:"
puts "String to Symbol: #{"ruby".to_sym}"            # :ruby
puts "String to Symbol (alternate): #{"ruby".intern}" # :ruby

# 5. Converting to Array
puts "\nConverting to Arrays:"
puts "String to Array (chars): #{"ruby".chars}"      # ["r", "u", "b", "y"]
puts "String to Array (split): #{"r,u,b,y".split(",")}" # ["r", "u", "b", "y"]
puts "Range to Array: #{(1..5).to_a}"                # [1, 2, 3, 4, 5]
puts "Hash to Array: #{{ a: 1, b: 2 }.to_a}"           # [[:a, 1], [:b, 2]]
puts "Set to Array: #{require "set"; Set[1, 2, 3].to_a}" # [1, 2, 3]

# Using Array() method (safe conversion)
puts "\nUsing Array() method:"
puts "String with Array(): #{Array("ruby")}"         # ["ruby"]
puts "nil with Array(): #{Array(nil)}"               # []
puts "Single integer with Array(): #{Array(5)}"      # [5]
puts "Range with Array(): #{Array(1..3)}"            # [1, 2, 3]

# 6. Converting to Hash
puts "\nConverting to Hashes:"
puts "Array of pairs to Hash: #{[[:a, 1], [:b, 2]].to_h}"  # {:a=>1, :b=>2}
puts "Array of arrays to Hash: #{[["a", 1], ["b", 2]].to_h}" # {"a"=>1, "b"=>2}

# Using Hash[] method
puts "\nUsing Hash[] method:"
puts "Array pairs to Hash: #{Hash[[:a, 1], [:b, 2]]}"      # {:a=>1, :b=>2}
puts "Flat array to Hash: #{Hash[:a, 1, :b, 2]}"           # {:a=>1, :b=>2}

# 7. Converting to Boolean
puts "\nConverting to Booleans:"
# Ruby doesn't have a direct to_bool method, but uses truthiness
puts "Integer truthiness (0): #{!!0}"                # true (only nil and false are falsey)
puts "Empty string truthiness: #{!!""}"              # true
puts "Empty array truthiness: #{!![]}"               # true
puts "nil truthiness: #{!!nil}"                      # false
puts "false truthiness: #{!!false}"                  # false

# 8. Converting to Rational numbers
puts "\nConverting to Rational numbers:"
require "rational" if RUBY_VERSION < "1.9" # Not needed in modern Ruby
puts "Integer to Rational: #{42.to_r}"                # (42/1)
puts "Float to Rational: #{3.14.to_r}"                # (157/50)
puts "String to Rational: #{"3.14".to_r}"             # (157/50)
puts "String fraction to Rational: #{"2/3".to_r}"     # (2/3)

# Using Rational() method
puts "\nUsing Rational() method:"
puts "Creating from integers: #{Rational(2, 3)}"      # (2/3)
puts "Creating from string: #{Rational("2/3")}"       # (2/3)

# 9. Converting to Complex numbers
puts "\nConverting to Complex numbers:"
require "complex" if RUBY_VERSION < "1.9" # Not needed in modern Ruby
puts "Integer to Complex: #{42.to_c}"                 # (42+0i)
puts "Float to Complex: #{3.14.to_c}"                 # (3.14+0i)
puts "String to Complex: #{"3.14".to_c}"              # (3.14+0i)
puts "String with i to Complex: #{"1+2i".to_c}"       # (1+2i)

# Using Complex() method
puts "\nUsing Complex() method:"
puts "Creating from integers: #{Complex(2, 3)}"       # (2+3i)
puts "Creating from string: #{Complex("2+3i")}"       # (2+3i)

# 10. Specialized conversions
puts "\nSpecialized conversions:"
puts "Integer to binary string: #{42.to_s(2)}"        # "101010"
puts "Integer to hex string: #{42.to_s(16)}"          # "2a"
puts "Integer to character: #{65.chr}"                # "A"
puts "String to time: #{Time.parse("2023-05-15") rescue 'Requires: require \"time\"'}" # Requires: require "time"

require "time"
puts "String to time: #{Time.parse("2023-05-15")}"    # 2023-05-15 00:00:00

# 11. Implicit Conversions
puts "\nImplicit conversions:"
# The + operator implicitly converts numbers
puts "Implicit number conversion: #{5 + 3.14}"        # 8.14

# String interpolation implicitly calls to_s
num = 42
puts "Implicit string conversion: #{num}"             # 42

# Array concatenation converts to array with Array()
puts "Implicit array conversion: #{[1, 2] + Array(3)}" # [1, 2, 3]

# 12. Custom Object Conversion
puts "\nCustom object conversion:"

class Person
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_s
    "#{@name} (#{@age})"
  end

  def to_i
    @age
  end

  def to_h
    { name: @name, age: @age }
  end

  def to_a
    [@name, @age]
  end
end

person = Person.new("Ruby", 30)
puts "Person to string: #{person.to_s}"               # Ruby (30)
puts "Person to integer: #{person.to_i}"              # 30
puts "Person to hash: #{person.to_h}"                 # {:name=>"Ruby", :age=>30}
puts "Person to array: #{person.to_a}"                # ["Ruby", 30]

# 13. Type conversion edge cases
puts "\nType conversion edge cases:"
puts "Float::INFINITY to Integer: #{Float::INFINITY.to_i rescue "Error"}"  # Error or implementation-dependent
puts "Bignum conversion: #{(10 ** 100).class}"         # Integer
puts "Large number to String: #{(10 ** 100).to_s}"     # 10000000000000000000000000000000000000000000000000...
puts "String with underscores to Integer: #{"1_000_000".to_i}" # 1000000

# 14. Converting between collections
puts "\nConverting between collections:"
require "set"
arr = [1, 2, 3, 2, 1]
set = Set.new(arr)
new_arr = set.to_a

puts "Original array: #{arr}"                 # [1, 2, 3, 2, 1]
puts "Converted to Set: #{set}"               # #<Set: {1, 2, 3}>
puts "Back to array (duplicates removed): #{new_arr}" # [1, 2, 3]

# Hash to nested arrays and back
hash = { a: 1, b: 2 }
nested_arrays = hash.to_a  # [[:a, 1], [:b, 2]]
back_to_hash = nested_arrays.to_h  # {:a=>1, :b=>2}

puts "Original hash: #{hash}"                 # {:a=>1, :b=>2}
puts "Converted to nested arrays: #{nested_arrays}" # [[:a, 1], [:b, 2]]
puts "Back to hash: #{back_to_hash}"          # {:a=>1, :b=>2}
