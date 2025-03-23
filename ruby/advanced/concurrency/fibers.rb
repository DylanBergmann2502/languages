# Ruby Fibers
# Fibers are lightweight cooperative concurrency primitives.
# Unlike threads, fibers must be explicitly scheduled and give up control voluntarily.

########################################################################
# Basic Fiber Creation
# Create a fiber using Fiber.new with a block of code
fiber = Fiber.new do
  puts "Fiber started"
  Fiber.yield "First yield"
  puts "Fiber resumed"
  Fiber.yield "Second yield"
  puts "Fiber resumed again"
  "Final value"
end

# Resume the fiber to start execution
puts "Resuming fiber first time:"
result1 = fiber.resume
puts "Fiber yielded: #{result1}"
# Resuming fiber first time:
# Fiber started
# Fiber yielded: First yield

puts "\nResuming fiber second time:"
result2 = fiber.resume
puts "Fiber yielded: #{result2}"
# 
# Resuming fiber second time:
# Fiber resumed
# Fiber yielded: Second yield

puts "\nResuming fiber third time:"
result3 = fiber.resume
puts "Fiber returned: #{result3}"
# 
# Resuming fiber third time:
# Fiber resumed again
# Fiber returned: Final value

puts "\nFiber status: #{fiber.alive? ? "alive" : "dead"}"
# 
# Fiber status: dead

# Attempting to resume a dead fiber raises an error
begin
  fiber.resume
rescue => e
  puts "Error resuming dead fiber: #{e.message}"
end
# Error resuming dead fiber: dead fiber called

########################################################################
# Fibers with Arguments
# You can pass arguments to fibers when resuming them
fiber = Fiber.new do |first_arg|
  puts "Fiber received: #{first_arg}"
  second_arg = Fiber.yield "Send me another value"
  puts "Fiber received second value: #{second_arg}"
  "Done"
end

puts "\nResuming fiber with argument:"
result = fiber.resume("Hello, Fiber!")
puts "Fiber yielded: #{result}"
# 
# Resuming fiber with argument:
# Fiber received: Hello, Fiber!
# Fiber yielded: Send me another value

puts "\nResuming fiber with second argument:"
final = fiber.resume("Resuming with this value")
puts "Fiber returned: #{final}"
# 
# Resuming fiber with second argument:
# Fiber received second value: Resuming with this value
# Fiber returned: Done

########################################################################
# Using Fibers for Generators
# Fibers make it easy to create generator-like functionality
def fibonacci
  Fiber.new do
    a, b = 0, 1
    loop do
      Fiber.yield a
      a, b = b, a + b
    end
  end
end

fib = fibonacci
puts "\nGenerating Fibonacci sequence:"
10.times do
  puts fib.resume
end
# 
# Generating Fibonacci sequence:
# 0
# 1
# 1
# 2
# 3
# 5
# 8
# 13
# 21
# 34

########################################################################
# Fiber-based Iteration
# Creating an iterator using fibers
def list_iterator(list)
  Fiber.new do
    list.each do |item|
      Fiber.yield item
    end
    nil # Return nil when done
  end
end

fruits = ["apple", "banana", "cherry", "date"]
iterator = list_iterator(fruits)

puts "\nIterating with fibers:"
while (fruit = iterator.resume)
  puts "Got fruit: #{fruit}"
end
puts "Iterator exhausted"
# 
# Iterating with fibers:
# Got fruit: apple
# Got fruit: banana
# Got fruit: cherry
# Got fruit: date
# Iterator exhausted

########################################################################
# Fiber Pools and Reusing Fibers
# Fibers can be reset and reused (Ruby 3.0+)
if Fiber.respond_to?(:reset)
  puts "\nResetting and reusing a fiber (Ruby 3.0+):"
  counter_fiber = Fiber.new do
    count = 0
    loop do
      Fiber.yield count += 1
    end
  end

  3.times { puts "Count: #{counter_fiber.resume}" }
  
  # Reset the fiber
  counter_fiber.reset if counter_fiber.respond_to?(:reset)
  puts "Fiber has been reset"
  
  3.times { puts "Count after reset: #{counter_fiber.resume}" }
else
  puts "\nFiber reset is not available in this Ruby version"
  # 
  # Fiber reset is not available in this Ruby version
end

########################################################################
# Fibers vs. Threads
# Comparing fiber and thread behavior
puts "\nComparing Fibers and Threads:"

puts "1. Creating a fiber (does not run automatically):"
fiber = Fiber.new do
  puts "  - Fiber is now running"
  Fiber.yield
  puts "  - Fiber resumed"
end
puts "  - Fiber is created but not running yet"
# 
# Comparing Fibers and Threads:
# 1. Creating a fiber (does not run automatically):
#   - Fiber is created but not running yet

puts "2. Creating a thread (runs immediately):"
thread = Thread.new do
  puts "  - Thread is now running"
  sleep 0.1
  puts "  - Thread continued after sleep"
end
puts "  - Main thread continues while thread runs"
thread.join
# 2. Creating a thread (runs immediately):
#   - Thread is now running
#   - Main thread continues while thread runs
#   - Thread continued after sleep

puts "3. Now resuming the fiber:"
fiber.resume
puts "  - Back to main after first fiber yield"
fiber.resume
puts "  - Fiber completed"
# 3. Now resuming the fiber:
#   - Fiber is now running
#   - Back to main after first fiber yield
#   - Fiber resumed
#   - Fiber completed

########################################################################
# Fibers for Asynchronous Operations
# Simple example of using fibers for async-like operations
def async_operation(operation)
  fiber = Fiber.current

  # Simulate async operation with a separate thread
  Thread.new do
    result = operation.call
    # Resume the fiber with the result when operation completes
    fiber.resume(result) if fiber.alive?
  end

  # Yield control until the operation completes
  result = Fiber.yield
  return result
end

main_fiber = Fiber.new do
  puts "\nStarting async operations:"

  # Start multiple "async" operations
  result1 = async_operation -> {
                              sleep 0.2
                              "First operation completed"
                            }

  puts "First result: #{result1}"

  result2 = async_operation -> {
                              sleep 0.1
                              "Second operation completed"
                            }

  puts "Second result: #{result2}"

  "All operations completed"
end

puts main_fiber.resume
# 
# Starting async operations:
# First result: First operation completed
# Second result: Second operation completed
# All operations completed