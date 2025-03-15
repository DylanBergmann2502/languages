############################################################
# Implicit Returns
# Ruby methods return the value of the last expression by default
def add(a, b)
  a + b  # This value is automatically returned
end

sum = add(5, 3)
puts "Sum: #{sum}"  # Output: Sum: 8

# Multiple expressions - the last one is returned
def process_number(num)
  doubled = num * 2
  squared = num ** 2
  squared  # This is what gets returned
end

result = process_number(4)
puts "Result: #{result}"  # Output: Result: 16

############################################################
# Explicit Returns
# The 'return' keyword can be used to exit a method early
def check_status(status)
  return "Error" if status < 0
  return "Warning" if status == 0
  "Success"  # Implicit return for positive status
end

puts check_status(-1)  # Output: Error
puts check_status(0)   # Output: Warning
puts check_status(1)   # Output: Success

# Early returns for guard clauses
def divide(a, b)
  return "Cannot divide by zero" if b == 0
  a / b
end

puts divide(10, 2)  # Output: 5
puts divide(10, 0)  # Output: Cannot divide by zero

############################################################
# Returning Multiple Values
# Ruby methods can return multiple values as an array
def get_dimensions
  [100, 200]  # Returns width and height as an array
end

width, height = get_dimensions
puts "Width: #{width}, Height: #{height}"  # Output: Width: 100, Height: 200

# A more explicit way using the return keyword
def compute_stats(numbers)
  return 0 if numbers.empty?

  sum = numbers.sum
  average = sum / numbers.size.to_f
  max = numbers.max
  min = numbers.min

  return sum, average, min, max  # Returns multiple values
end

data = [3, 1, 7, 4, 9]
sum, avg, min, max = compute_stats(data)
puts "Sum: #{sum}, Average: #{avg}, Min: #{min}, Max: #{max}"
# Output: Sum: 24, Average: 4.8, Min: 1, Max: 9

############################################################
# Returning Complex Objects
# Ruby methods can return any object type
def create_person
  { name: "Alice", age: 30, skills: ["Ruby", "Rails"] }
end

person = create_person
puts "Name: #{person[:name]}, Age: #{person[:age]}"
puts "Skills: #{person[:skills].join(", ")}"

# Returning custom objects
class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{x}, #{y})"
  end
end

def midpoint(point1, point2)
  mid_x = (point1.x + point2.x) / 2.0
  mid_y = (point1.y + point2.y) / 2.0
  Point.new(mid_x, mid_y)
end

p1 = Point.new(0, 0)
p2 = Point.new(10, 10)
mid = midpoint(p1, p2)
puts "Midpoint: #{mid}"  # Output: Midpoint: (5.0, 5.0)

############################################################
# Return Values in One-Line Methods
# Ruby has shorthand syntax for simple methods
def square(n) = n * n  # Ruby 3.0+ syntax

puts "Square of 5: #{square(5)}"  # Output: Square of 5: 25

# In older Ruby versions, you would write:
def cube(n); n ** 3; end

puts "Cube of 3: #{cube(3)}"  # Output: Cube of 3: 27

############################################################
# Nil Returns
# Methods return nil by default if no value is specified
def log_message(message)
  puts "LOG: #{message}"
  # No explicit return, so nil is returned
end

result = log_message("Testing")
puts "Result is nil: #{result.nil?}"  # Output: Result is nil: true

############################################################
# Returns in Blocks
# The 'return' keyword in a block will exit the method that called the block
def method_with_block
  puts "Before block"
  [1, 2, 3].each do |num|
    puts "In block: #{num}"
    return "Early exit" if num == 2  # This exits the entire method
    puts "After condition"
  end
  puts "After block"  # This won't be executed if return is triggered
  "Normal exit"
end

puts method_with_block
# Output:
# Before block
# In block: 1
# After condition
# In block: 2
# Early exit

############################################################
# Lambda vs Proc Return Behavior
# Lambdas and Procs handle returns differently
def proc_return
  proc = Proc.new { return "Return from proc" }
  proc.call
  "This won't be reached"
end

def lambda_return
  lam = lambda { return "Return from lambda" }
  lam.call
  "This will be reached"
end

puts proc_return    # Output: Return from proc
puts lambda_return  # Output: This will be reached
