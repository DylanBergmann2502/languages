# A Proc is an object that encapsulates a block of code which can be stored in a variable,
# passed to a method, and called later.

########################################################################
# Creating Procs
puts "Creating Procs:"

# Using Proc.new
greeter = Proc.new { |name| puts "Hello, #{name}!" }
greeter.call("Ruby")

# Using proc method (shorthand syntax)
multiplier = proc { |x| x * 3 }
puts multiplier.call(5)

# Alternative calling methods
puts "\nDifferent ways to call a Proc:"
doubler = proc { |x| x * 2 }
puts doubler.call(5)      # => 10
puts doubler.(5)          # => 10
puts doubler[5]           # => 10
puts doubler === 5        # => 10 (used in case statements)

########################################################################
# Procs remember their context (closure)
puts "\nProcs as closures:"

def create_multiplier(factor)
  proc { |number| number * factor }
end

double = create_multiplier(2)
triple = create_multiplier(3)
puts double.call(5)  # => 10
puts triple.call(5)  # => 15

########################################################################
# Procs vs. Blocks
puts "\nProcs vs. Blocks:"

# Converting a block to a Proc with &
def block_to_proc(&my_proc)
  puts "Block converted to Proc"
  my_proc.call("World")
end

block_to_proc { |name| puts "Hello, #{name}!" }

# Passing a Proc as a block with &
puts "\nPassing a Proc as a block:"
say_hi = proc { |name| puts "Hi, #{name}!" }
names = ["Alice", "Bob", "Charlie"]

# Pass Proc as a block to each method
names.each(&say_hi)

########################################################################
# Procs with parameters
puts "\nProcs with parameters:"

# Proc with multiple parameters
calculator = proc { |x, y| puts "#{x} + #{y} = #{x + y}" }
calculator.call(3, 4)

# Proc with default argument behavior
puts "\nProc parameter handling:"
default_proc = proc { |a, b, c| puts "a=#{a}, b=#{b}, c=#{c}" }
default_proc.call(1)                # a=1, b=nil, c=nil
default_proc.call(1, 2, 3, 4, 5)    # a=1, b=2, c=3 (extra args ignored)

########################################################################
# Returning from Procs
puts "\nReturning from Procs:"

def test_proc_return
  puts "Before proc"
  my_proc = proc { return "Returned from proc" }
  result = my_proc.call
  puts "After proc: #{result}"  # Never reached!
  return "Returned from method"
end

puts test_proc_return  # => "Returned from proc"

########################################################################
# Procs as objects
puts "\nProcs as first-class objects:"

# Storing Procs in data structures
operations = {
  add: proc { |x, y| x + y },
  subtract: proc { |x, y| x - y },
  multiply: proc { |x, y| x * y },
  divide: proc { |x, y| x / y },
}

puts operations[:add].call(5, 3)      # => 8
puts operations[:multiply].call(5, 3)  # => 15

########################################################################
# Currying Procs
puts "\nCurrying Procs:"
multiply = proc { |x, y| x * y }
curried_multiply = multiply.curry

double = curried_multiply[2]
triple = curried_multiply[3]

puts double.call(5)  # => 10
puts triple.call(5)  # => 15

########################################################################
# Composing Procs
puts "\nComposing Procs (functional composition):"
square = proc { |x| x * x }
increment = proc { |x| x + 1 }

# Create a new proc that applies both operations
square_then_increment = proc { |x| increment.call(square.call(x)) }
puts square_then_increment.call(5)  # => 26 (5² + 1)

########################################################################
# Performance considerations
puts "\nProcs vs. Methods performance:"
require "benchmark"

array = (1..1000).to_a

Benchmark.bm do |x|
  x.report("Method:") { array.map { |n| n * 2 } }
  doubler = proc { |n| n * 2 }
  x.report("Proc:") { array.map(&doubler) }
end

puts "\nProcs are powerful objects that enable functional programming styles in Ruby!"
