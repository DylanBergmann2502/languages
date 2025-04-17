# Creating floats
a = 3.14
b = 2.5e3      # Scientific notation: 2.5 × 10^3 = 2500.0
c = 1.2e-3     # Scientific notation: 1.2 × 10^-3 = 0.0012
d = 0.5        # Regular decimal notation

puts "Different ways to represent floats:"
puts "Regular: #{a}"                   # 3.14
puts "Scientific (positive exponent): #{b}"  # 2500.0
puts "Scientific (negative exponent): #{c}"  # 0.0012
puts "Decimal less than 1: #{d}"       # 0.5

# Creating floats from integers
integer_to_float = 42.0
float_by_division = 42 / 2.0
float_by_conversion = 42.to_f

puts "\nCreating floats from integers:"
puts "Integer with decimal: #{integer_to_float}"  # 42.0
puts "Division with decimal: #{float_by_division}"  # 21.0
puts "Using to_f method: #{float_by_conversion}"  # 42.0

# Basic arithmetic with floats
puts "\nBasic arithmetic with floats:"
puts "Addition: 5.2 + 3.8 = #{5.2 + 3.8}"          # 9.0
puts "Subtraction: 10.5 - 4.2 = #{10.5 - 4.2}"      # 6.3
puts "Multiplication: 6.5 * 2.0 = #{6.5 * 2.0}"     # 13.0
puts "Division: 20.0 / 4.0 = #{20.0 / 4.0}"         # 5.0
puts "Division integer by float: 7 / 2.0 = #{7 / 2.0}"  # 3.5
puts "Modulo: 7.5 % 2 = #{7.5 % 2}"                # 1.5
puts "Exponentiation: 2.5 ** 2 = #{2.5 ** 2}"      # 6.25

# Float precision
puts "\nFloat precision:"
puts "0.1 + 0.2 = #{0.1 + 0.2}"           # 0.30000000000000004 (not exactly 0.3)
puts "0.1 + 0.2 == 0.3: #{0.1 + 0.2 == 0.3}"  # false

# When precision matters, use round, ceil, floor
sum = 0.1 + 0.2
puts "Sum rounded: #{sum.round(1)}"       # 0.3
puts "After rounding, sum == 0.3: #{sum.round(1) == 0.3}"  # true

# Float methods
puts "\nFloat methods:"
puts "Absolute value of -3.14: #{-3.14.abs}"       # 3.14
puts "Ceiling of 3.14: #{3.14.ceil}"               # 4 (next integer up)
puts "Floor of 3.14: #{3.14.floor}"                # 3 (next integer down)
puts "Round 3.14 to nearest integer: #{3.14.round}"  # 3
puts "Round 3.56 to nearest integer: #{3.56.round}"  # 4
puts "Round 3.567 to 2 decimals: #{3.567.round(2)}"  # 3.57
puts "Integer part of 3.14: #{3.14.to_i}"          # 3 (truncates decimal)
puts "Is 3.0 an integer value? #{3.0.integer?}"    # true
puts "Is 3.14 an integer value? #{3.14.integer?}"  # false

# Float rounding modes (Ruby 2.4+)
puts "\nRounding modes:"
puts "Round 3.5 (default): #{3.5.round}"  # 4 (rounds away from zero)
puts "Round -3.5 (default): #{-3.5.round}"  # -4 (rounds away from zero)
puts "Round 3.5 (half up): #{3.5.round(half: :up)}"  # 4
puts "Round 3.5 (half down): #{3.5.round(half: :down)}"  # 3
puts "Round 3.5 (half even): #{3.5.round(half: :even)}"  # 4

# Infinite and NaN (Not a Number)
puts "\nSpecial float values:"
infinity = Float::INFINITY
negative_infinity = -Float::INFINITY
not_a_number = Float::NAN

puts "Infinity: #{infinity}"                  # Infinity
puts "Negative infinity: #{negative_infinity}"  # -Infinity
puts "Not a Number: #{not_a_number}"          # NaN

puts "Is infinity finite? #{infinity.finite?}"             # false
puts "Is 42.0 finite? #{42.0.finite?}"                     # true
puts "Is infinity infinite? #{infinity.infinite?}"         # 1
puts "Is negative infinity infinite? #{negative_infinity.infinite?}"  # -1
puts "Is NaN a number? #{not_a_number.nan?}"               # true

# Float constants
puts "\nFloat constants:"
puts "Float::EPSILON (smallest difference): #{Float::EPSILON}"  # 2.220446049250313e-16
puts "Float::MAX (largest representable): #{Float::MAX}"  # 1.7976931348623157e+308
puts "Float::MIN (smallest positive): #{Float::MIN}"  # 2.2250738585072014e-308
puts "Float::DIG (decimal digits of precision): #{Float::DIG}"  # 15
puts "Float::INFINITY: #{Float::INFINITY}"  # Infinity

# Comparing floats safely (due to precision issues)
puts "\nComparing floats:"
a = 0.1 + 0.2             # 0.30000000000000004
b = 0.3                   # 0.3
epsilon = 0.0001

puts "a = #{a}, b = #{b}"
puts "a == b: #{a == b}"                            # false
puts "Safe comparison with epsilon: #{(a - b).abs < epsilon}"  # true

# Using Complex numbers (when operations result in square roots of negative numbers)
require "complex"
puts "\nComplex numbers:"
puts "Square root of -1: #{Math.sqrt(Complex(-1))}"  # (0+1i)
puts "Complex: #{Complex(3, 4)}"                    # (3+4i)
puts "Complex arithmetic: #{Complex(3, 4) * Complex(1, 2)}"  # (-5+10i)

# Type checking
puts "\nType checking:"
puts "3.14.is_a?(Float): #{3.14.is_a?(Float)}"            # true
puts "3.14.is_a?(Integer): #{3.14.is_a?(Integer)}"        # false
puts "3.14.is_a?(Numeric): #{3.14.is_a?(Numeric)}"        # true
puts "3.14.kind_of?(Float): #{3.14.kind_of?(Float)}"      # true
puts "3.14.instance_of?(Float): #{3.14.instance_of?(Float)}"  # true

# Converting between numeric types
puts "\nType conversion:"
puts "Float to Integer: #{3.14.to_i}"  # 3 (truncates decimal portion)
puts "Float to Rational: #{3.14.to_r}"  # 157/50
puts "Float to String: #{3.14.to_s}"  # "3.14"
puts "Float to String (engineering notation): #{(1234.56).to_s("E")}"  # "1.23456E+03"
puts "Float to String (formatted): #{sprintf("%.4f", 3.14159)}"  # "3.1416"
