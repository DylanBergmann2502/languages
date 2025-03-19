# Operators in Ruby
# Ruby supports a variety of operators for different operations

########################################################################
# Arithmetic Operators
a = 10
b = 3

puts "Arithmetic Operators:"
puts "a = #{a}, b = #{b}"
puts "a + b = #{a + b}"    # 13 (Addition)
puts "a - b = #{a - b}"    # 7 (Subtraction)
puts "a * b = #{a * b}"    # 30 (Multiplication)
puts "a / b = #{a / b}"    # 3 (Division - note integer division)
puts "a % b = #{a % b}"    # 1 (Modulus - remainder)
puts "a ** b = #{a ** b}"  # 1000 (Exponentiation)

# Float division
puts "a / b (float) = #{a / b.to_f}" # 3.3333333333333335

########################################################################
# Assignment Operators
puts "\nAssignment Operators:"
x = 5
puts "x = 5: #{x}"

x += 3      # Same as x = x + 3
puts "x += 3: #{x}"  # 8

x -= 2      # Same as x = x - 2
puts "x -= 2: #{x}"  # 6

x *= 4      # Same as x = x * 4
puts "x *= 4: #{x}"  # 24

x /= 3      # Same as x = x / 3
puts "x /= 3: #{x}"  # 8

x %= 5      # Same as x = x % 5
puts "x %= 5: #{x}"  # 3

x **= 2     # Same as x = x ** 2
puts "x **= 2: #{x}" # 9

########################################################################
# Comparison Operators
puts "\nComparison Operators:"
a = 10
b = 5
c = 10

puts "a = #{a}, b = #{b}, c = #{c}"
puts "a == c: #{a == c}"  # true (Equal to)
puts "a != b: #{a != b}"  # true (Not equal to)
puts "a > b: #{a > b}"    # true (Greater than)
puts "a < b: #{a < b}"    # false (Less than)
puts "a >= c: #{a >= c}"  # true (Greater than or equal to)
puts "a <= b: #{a <= b}"  # false (Less than or equal to)

# The <=> operator (Spaceship operator)
# Returns -1 if left is less than right, 0 if they're equal, and 1 if left is greater than right
puts "a <=> b: #{a <=> b}"  # 1
puts "a <=> c: #{a <=> c}"  # 0
puts "b <=> a: #{b <=> a}"  # -1

########################################################################
# Logical Operators
puts "\nLogical Operators:"
x = true
y = false

puts "x = #{x}, y = #{y}"
puts "x && y: #{x && y}"  # false (AND - both must be true)
puts "x || y: #{x || y}"  # true (OR - at least one must be true)
puts "!x: #{!x}"          # false (NOT - inverts the boolean value)

# Alternative forms
puts "x and y: #{x and y}"  # false
puts "x or y: #{x or y}"    # true
puts "not x: #{not x}"      # false

# Short-circuit evaluation
# && stops evaluating if left side is false
# || stops evaluating if left side is true
puts "false && this_method_wont_be_called: #{false && (puts "This won't print")}"  # false
puts "true || this_method_wont_be_called: #{true || (puts "This won't print")}"    # true

########################################################################
# Range Operators
puts "\nRange Operators:"
# .. includes the end value
inclusive = 1..5
puts "1..5: #{inclusive.to_a}"  # [1, 2, 3, 4, 5]

# ... excludes the end value
exclusive = 1...5
puts "1...5: #{exclusive.to_a}"  # [1, 2, 3, 4]

########################################################################
# Bitwise Operators
puts "\nBitwise Operators:"
a = 5  # Binary: 101
b = 3  # Binary: 011

puts "a = #{a} (#{a.to_s(2)}), b = #{b} (#{b.to_s(2)})"
puts "a & b: #{a & b} (#{(a & b).to_s(2)})"    # 1 (AND - 001)
puts "a | b: #{a | b} (#{(a | b).to_s(2)})"    # 7 (OR - 111)
puts "a ^ b: #{a ^ b} (#{(a ^ b).to_s(2)})"    # 6 (XOR - 110)
puts "~a: #{~a} (#{(~a).to_s(2)})"             # -6 (NOT - flips all bits)
puts "a << 1: #{a << 1} (#{(a << 1).to_s(2)})" # 10 (Left shift - 1010)
puts "a >> 1: #{a >> 1} (#{(a >> 1).to_s(2)})" # 2 (Right shift - 10)

########################################################################
# Ternary Operator
puts "\nTernary Operator:"
age = 19
status = age >= 18 ? "adult" : "minor"
puts "Age: #{age}, Status: #{status}"  # Age: 19, Status: adult

########################################################################
# Other Operators
puts "\nOther Operators:"

# .. in case statements for ranges
score = 85
grade = case score
  when 90..100 then "A"
  when 80...90 then "B"
  when 70...80 then "C"
  when 60...70 then "D"
  else "F"
  end
puts "Score: #{score}, Grade: #{grade}"  # Score: 85, Grade: B

# =~ operator for regular expression matching
text = "Hello, Ruby!"
puts "text =~ /Ruby/: #{text =~ /Ruby/}"      # 7 (index of match)
puts "text =~ /Python/: #{text =~ /Python/}"  # nil (no match)

# .. and ... for sequences in an array
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
puts "numbers[2..5]: #{numbers[2..5]}"    # [3, 4, 5, 6]
puts "numbers[2...5]: #{numbers[2...5]}"  # [3, 4, 5]

# defined? operator to check if something is defined
puts "defined? puts: #{defined? puts}"  # method
puts "defined? undefined_var: #{defined? undefined_var}"  # nil
