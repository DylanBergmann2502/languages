# In Ruby 2.4+, Fixnum and Bignum were unified into a single Integer class
# No need to worry about size limits - Ruby handles large numbers automatically

# Creating integers
a = 42        # Decimal (base 10)
b = 0b101010  # Binary (base 2) - same as 42
c = 0o52      # Octal (base 8) - same as 42
d = 0x2A      # Hexadecimal (base 16) - same as 42

puts "Different ways to represent 42:"
puts "Decimal: #{a}"
puts "Binary: #{b} (#{0b101010.to_s})"
puts "Octal: #{c} (#{0o52.to_s})"
puts "Hexadecimal: #{d} (#{0x2A.to_s})"

# Underscores can be used for readability with large numbers
million = 1_000_000
billion = 1_000_000_000
puts "\nLarge numbers with underscores:"
puts "Million: #{million}"
puts "Billion: #{billion}"

# Basic arithmetic operations
puts "\nBasic arithmetic:"
puts "Addition: 5 + 3 = #{5 + 3}"         # 8
puts "Subtraction: 10 - 4 = #{10 - 4}"    # 6
puts "Multiplication: 6 * 7 = #{6 * 7}"   # 42
puts "Division: 20 / 4 = #{20 / 4}"       # 5
puts "Integer division: 7 / 2 = #{7 / 2}" # 3 (Note: Returns quotient (truncated))
puts "Remainder (modulo): 7 % 2 = #{7 % 2}"  # 1
puts "Exponentiation: 2 ** 8 = #{2 ** 8}" # 256

# Division with integers vs floats
puts "\nDivision details:"
puts "Integer division: 7 / 2 = #{7 / 2}"        # Returns 3 (not 3.5)
puts "Float division: 7 / 2.0 = #{7 / 2.0}"      # Returns 3.5
puts "Float division: 7.0 / 2 = #{7.0 / 2}"      # Returns 3.5
puts "Float division: 7.fdiv(2) = #{7.fdiv(2)}"  # Returns 3.5

# Divmod returns quotient and remainder as an array
quotient, remainder = 17.divmod(5)
puts "\ndivmod example:"
puts "17.divmod(5) = [#{quotient}, #{remainder}]"  # [3, 2]

# Integer methods
number = 42
puts "\nInteger methods:"
puts "Even? #{number.even?}"       # true
puts "Odd? #{number.odd?}"         # false
puts "Absolute value of -42: #{-42.abs}"  # 42
puts "Next integer after 42: #{number.next}"  # 43
puts "Previous integer before 42: #{number.pred}"  # 41

# Bit operations
puts "\nBit operations:"
puts "15 & 9 (AND): #{15 & 9}"    # 9 (bitwise AND)
puts "15 | 9 (OR): #{15 | 9}"     # 15 (bitwise OR)
puts "15 ^ 9 (XOR): #{15 ^ 9}"    # 6 (bitwise XOR)
puts "~15 (NOT): #{~15}"          # -16 (bitwise NOT)
puts "8 << 2 (shift left): #{8 << 2}"   # 32 (shift bits left)
puts "32 >> 2 (shift right): #{32 >> 2}" # 8 (shift bits right)

# Number conversions
puts "\nNumber conversions:"
puts "42 to binary: #{42.to_s(2)}"  # "101010"
puts "42 to octal: #{42.to_s(8)}"   # "52"
puts "42 to hex: #{42.to_s(16)}"    # "2a"
puts "Binary string to integer: #{"101010".to_i(2)}"  # 42

# Range checking
puts "\nRange checking:"
num = 42
puts "#{num} in 1..50? #{(1..50).include?(num)}"  # true
puts "#{num} in 1...42? #{(1...42).include?(num)}"  # false (exclusive range)

# Big integers - Ruby handles these automatically
big_num = 12345678901234567890
puts "\nBig integers:"
puts "Big number: #{big_num}"
puts "Big number + 1: #{big_num + 1}"
puts "Big number class: #{big_num.class}"  # Integer

# Times and upto/downto methods
puts "\nTimes and upto/downto methods:"
puts "3.times loop results:"
result = []
3.times { |i| result << i }
puts result.inspect  # [0, 1, 2]

puts "\n1.upto(5) loop results:"
result = []
1.upto(5) { |i| result << i }
puts result.inspect  # [1, 2, 3, 4, 5]

puts "\n5.downto(1) loop results:"
result = []
5.downto(1) { |i| result << i }
puts result.inspect  # [5, 4, 3, 2, 1]

# step method
puts "\nStep method:"
result = []
1.step(10, 2) { |i| result << i }  # Start at 1, go to 10, step by 2
puts result.inspect  # [1, 3, 5, 7, 9]

# Integer.sqrt(n) - Square root (returns largest integer less than or equal to square root)
puts "\nSquare root method (Ruby 2.5+):"
puts "Integer.sqrt(16): #{Integer.sqrt(16)}"  # 4
puts "Integer.sqrt(15): #{Integer.sqrt(15)}"  # 3

# Type checking
puts "\nType checking:"
puts "42.is_a?(Integer): #{42.is_a?(Integer)}"  # true
puts "42.5.is_a?(Integer): #{42.5.is_a?(Integer)}"  # false
puts "42.kind_of?(Numeric): #{42.kind_of?(Numeric)}"  # true
puts "42.instance_of?(Integer): #{42.instance_of?(Integer)}"  # true
