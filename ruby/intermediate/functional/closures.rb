# A closure is a function that captures (closes over) the variables and constants
# in its surrounding context at the time of creation.

########################################################################
# Basic Closure Example
puts "Basic Closure Example:"

def create_greeter(greeting)
  # The lambda "closes over" the greeting variable
  ->(name) { puts "#{greeting}, #{name}!" }
end

hello_greeter = create_greeter("Hello")
hi_greeter = create_greeter("Hi")

hello_greeter.call("Ruby")  # => Hello, Ruby!
hi_greeter.call("World")    # => Hi, World!

########################################################################
# Capturing the surrounding environment
puts "\nClosures capture the surrounding environment:"

def counter_generator
  count = 0
  # This lambda has access to and remembers the count variable
  -> { count += 1 }
end

counter = counter_generator
puts counter.call  # => 1
puts counter.call  # => 2
puts counter.call  # => 3

# Each closure gets its own separate environment
counter2 = counter_generator
puts counter2.call  # => 1 (new counter)
puts counter.call   # => 4 (original counter continues)

########################################################################
# Closures capture variables, not values
puts "\nClosures capture variable references, not just values:"

def value_changer
  x = 10
  getter = -> { x }
  setter = ->(v) { x = v }
  [getter, setter]
end

getter, setter = value_changer
puts "Original value: #{getter.call}"  # => 10

setter.call(25)
puts "After setting: #{getter.call}"   # => 25

########################################################################
# Closure Scope and Variables
puts "\nClosure Scope and Variables:"

# Local variables
x = 1
increment_x = -> { x += 1 }
puts "x before: #{x}"     # => 1
puts increment_x.call     # => 2
puts "x after: #{x}"      # => 2

# Block parameters shadow outer variables
puts "\nVariable shadowing:"
y = 10
[1, 2, 3].each do |y|
  puts "Inside block: y = #{y}"  # Block parameter y shadows outer y
end
puts "Outside block: y = #{y}"   # Still 10, wasn't changed

########################################################################
# Closures with different Ruby constructs
puts "\nClosures with different Ruby constructs:"

# Blocks are closures
puts "Blocks as closures:"
message = "Hello from block"
1.times do
  puts message
end

# Procs are closures
puts "\nProcs as closures:"
message = "Hello from proc"
my_proc = Proc.new { puts message }
my_proc.call

# Lambdas are closures
puts "\nLambdas as closures:"
message = "Hello from lambda"
my_lambda = -> { puts message }
my_lambda.call

# Methods are NOT closures
puts "\nMethods are NOT closures:"
message = "Hello from outside"

def my_method
  # Can't access message from here
  puts defined?(message) ? message : "message is not accessible"
end

my_method  # => "message is not accessible"

########################################################################
# Binding objects
puts "\nBinding objects:"

def get_binding(value)
  binding
end

# Create bindings with different values of x
binding1 = get_binding(1)
binding2 = get_binding(100)

# Evaluate code within those bindings
puts eval("value", binding1)  # => 1
puts eval("value", binding2)  # => 100

########################################################################
# Common Closure Patterns
puts "\nClosure Patterns:"

# Memoization
def fibonacci_generator
  memo = { 0 => 0, 1 => 1 }

  # This lambda remembers the memo hash between calls
  ->(n) do
    if memo.has_key?(n)
      memo[n]
    else
      memo[n] = fibonacci_generator.call(n - 1) + fibonacci_generator.call(n - 2)
    end
  end
end

fib = fibonacci_generator
puts "Fibonacci(10): #{fib.call(10)}"

# Data privacy / encapsulation
puts "\nUsing closures for data privacy:"

def create_account(initial_balance)
  balance = initial_balance

  # Return a hash of lambdas that can manipulate the balance
  {
    deposit: ->(amount) { balance += amount },
    withdraw: ->(amount) do
      if amount <= balance
        balance -= amount
        true
      else
        false
      end
    end,
    balance: -> { balance },
  }
end

account = create_account(100)
puts "Initial balance: #{account[:balance].call}"
account[:deposit].call(50)
puts "After deposit: #{account[:balance].call}"
success = account[:withdraw].call(30)
puts "Withdrawal successful: #{success}"
puts "After withdrawal: #{account[:balance].call}"

########################################################################
# Closures and GC
puts "\nClosures and garbage collection:"

def potential_memory_leak
  large_array = Array.new(1000000) { |i| i }
  puts "Large array created with size: #{large_array.size}"

  # If we return this closure, it keeps a reference to large_array
  # preventing it from being garbage collected
  -> { large_array.sample }
end

# Uncomment to test (will use significant memory)
# memory_leak = potential_memory_leak
# puts "Random sample: #{memory_leak.call}"

puts "\nClosures are fundamental to functional programming patterns in Ruby!"
