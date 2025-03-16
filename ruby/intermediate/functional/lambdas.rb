# Lambdas are a special type of Proc object with slight differences in behavior

########################################################################
# Creating Lambdas
puts "Creating Lambdas:"

# Using lambda keyword
greeting = lambda { |name| puts "Hello, #{name}!" }
greeting.call("Ruby")

# Using -> syntax (stabby lambda)
multiplier = ->(x) { x * 3 }
puts multiplier.call(5)  # => 15

# Lambda with multiple parameters using stabby syntax
calculator = ->(x, y) { x + y }
puts calculator.call(3, 4)  # => 7

########################################################################
# Calling Lambdas
puts "\nDifferent ways to call a Lambda:"
doubler = ->(x) { x * 2 }
puts doubler.call(5)      # => 10
puts doubler.(5)          # => 10
puts doubler[5]           # => 10
# puts doubler === 5      # This works too but is less common with lambdas

########################################################################
# Lambdas vs. Procs: Argument Handling
puts "\nLambda vs. Proc - Argument handling:"

puts "Lambda with strict argument checking:"
strict_lambda = lambda { |a, b| puts "a=#{a}, b=#{b}" }
begin
  strict_lambda.call(1)
  puts "This won't be printed"
rescue ArgumentError => e
  puts "Error: #{e.message}"
end

puts "\nProc with lenient argument handling:"
lenient_proc = proc { |a, b| puts "a=#{a}, b=#{b}" }
lenient_proc.call(1)                # a=1, b=nil (no error)
lenient_proc.call(1, 2, 3, 4, 5)    # a=1, b=2 (extra args ignored)

########################################################################
# Lambdas vs. Procs: Return Behavior
puts "\nLambda vs. Proc - Return behavior:"

def proc_return_test
  puts "Before proc"
  my_proc = proc { return "Returned from proc" }
  result = my_proc.call
  puts "After proc: #{result}"      # Never reached!
  return "Returned from method"
end

def lambda_return_test
  puts "Before lambda"
  my_lambda = lambda { return "Returned from lambda" }
  result = my_lambda.call
  puts "After lambda: #{result}"    # This line gets executed
  return "Returned from method"
end

puts "Proc result: #{proc_return_test}"      # => "Returned from proc"
puts "Lambda result: #{lambda_return_test}"  # => "Returned from method"

########################################################################
# Lambdas as closures
puts "\nLambdas as closures:"

def create_multiplier(factor)
  ->(number) { number * factor }
end

double = create_multiplier(2)
triple = create_multiplier(3)
puts double.call(5)  # => 10
puts triple.call(5)  # => 15

########################################################################
# Lambdas with block syntax
puts "\nUsing lambdas with methods that expect blocks:"
numbers = [1, 2, 3, 4, 5]

# Using & to convert lambda to a block
square = ->(x) { x * x }
squared_numbers = numbers.map(&square)
puts "Squared: #{squared_numbers}"

# Shorthand for simple operations
cubed_numbers = numbers.map(&->(x) { x ** 3 })
puts "Cubed: #{cubed_numbers}"

########################################################################
# Recursion with lambdas
puts "\nRecursive lambdas:"

# Calculating factorial with a recursive lambda
factorial = ->(n) do
  n <= 1 ? 1 : n * factorial.call(n - 1)
end

puts "5! = #{factorial.call(5)}"  # => 120

########################################################################
# Higher-order functions with lambdas
puts "\nHigher-order functions with lambdas:"

# A function that returns a function
def power_function(exponent)
  ->(base) { base ** exponent }
end

square = power_function(2)
cube = power_function(3)
puts "5² = #{square.call(5)}"  # => 25
puts "5³ = #{cube.call(5)}"    # => 125

# A function that takes a function as an argument
def apply_twice(value, function)
  function.call(function.call(value))
end

increment = ->(x) { x + 1 }
puts apply_twice(5, increment)  # => 7 (increment applied twice to 5)

########################################################################
# Method objects vs. Lambdas
puts "\nMethod objects vs. Lambdas:"

# Turn methods into procs using method()
def multiply_by_two(x)
  x * 2
end

method_as_obj = method(:multiply_by_two)
puts method_as_obj.call(5)  # => 10

# Compare with lambda
lambda_version = ->(x) { x * 2 }
puts lambda_version.call(5)  # => 10

# Converting between them
puts numbers.map(&method(:multiply_by_two))  # Same as map(&method_as_obj)

########################################################################
# Performance comparison
puts "\nPerformance comparison:"
require "benchmark"

array = (1..1000).to_a

Benchmark.bm do |x|
  x.report("Block:") { array.map { |n| n * 2 } }
  x.report("Lambda:") { array.map(&->(n) { n * 2 }) }
  x.report("Method:") { array.map(&method(:multiply_by_two)) }
end

puts "\nLambdas are more strict than regular Procs but are often preferred for functional programming in Ruby!"
