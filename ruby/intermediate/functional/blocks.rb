# Blocks are chunks of code enclosed between curly braces {} or do/end keywords

########################################################################
# Basic block usage with each method
puts "Basic block with curly braces:"
[1, 2, 3].each { |num| puts num }
# 1
# 2
# 3

puts "\nBasic block with do/end (preferred for multi-line blocks):"
[1, 2, 3].each do |num|
  puts num * 2
end
# 2
# 4
# 6

########################################################################
# Block parameters and variables
puts "\nBlock parameters:"
["apple", "banana", "cherry"].each_with_index do |fruit, index|
  puts "#{index + 1}. #{fruit}"
end
# 1. apple
# 2. banana
# 3. cherry

# Variable scope in blocks
puts "\nVariable scope in blocks:"
x = "outer variable"
1.times do
  puts "Inside block: #{x}"      # Can access variables from outer scope
  y = "inner variable"
  puts "Defined inside block: #{y}"
end
# Inside block: outer variable
# Defined inside block: inner variable
# puts y                         # Would raise error: undefined local variable

########################################################################
# Creating methods that accept blocks with yield
puts "\nMethods with yield:"

def greet
  puts "Before yield"
  yield
  puts "After yield"
end

greet { puts "Inside the block!" }
# Before yield
# Inside the block!
# After yield

# Yield with parameters
puts "\nYield with parameters:"

def calculate(num1, num2)
  puts "Calculating..."
  result = yield(num1, num2)
  puts "Result: #{result}"
end

calculate(5, 3) { |a, b| a + b }
# Calculating...
# Result: 8
calculate(5, 3) { |a, b| a * b }
# Calculating...
# Result: 15

########################################################################
# Checking if a block was given
puts "\nChecking if a block was given:"

def optional_block
  if block_given?
    puts "Block was provided"
    yield
  else
    puts "No block was given"
  end
end

optional_block { puts "I'm optional!" }
# Block was provided
# I'm optional!
optional_block
# No block was given

########################################################################
# Returning values from blocks
puts "\nReturning values from blocks:"
result = [1, 2, 3, 4, 5].map do |num|
  num * num
end
puts "Squared numbers: #{result}"
# Squared numbers: [1, 4, 9, 16, 25]

sum = [1, 2, 3, 4, 5].inject(0) do |accumulator, num|
  accumulator + num
end
puts "Sum: #{sum}"
# Sum: 15

########################################################################
# Custom iterators using blocks
puts "\nCustom iterator:"

def three_times
  yield(1)
  yield(2)
  yield(3)
end

three_times { |n| puts "Iteration #{n}" }
# Iteration 1
# Iteration 2
# Iteration 3

# More practical custom iterator
puts "\nCustom countdown iterator:"

def countdown(from)
  from.downto(1) do |i|
    yield i
  end
  puts "Blast off!"
end

countdown(5) { |i| puts "#{i}..." }
# 5...
# 4...
# 3...
# 2...
# 1...
# Blast off!

########################################################################
# Converting blocks to Proc objects with &block parameter
puts "\nBlocks as Proc objects:"

def store_block(&block)
  puts "Block stored as a Proc!"
  block.call("Hello from stored block")
end

store_block { |msg| puts msg }
# Block stored as a Proc!
# Hello from stored block

########################################################################
# Blocks vs. method calls performance
puts "\nBlocks are often more efficient than explicit method calls:"
require "benchmark"

array = (1..1000).to_a

Benchmark.bm do |x|
  x.report("With block:") { array.each { |num| num * 2 } }
  x.report("With method:") { array.each_with_index { |num, _| num * 2 } }
end
#                   user     system      total        real
# With block:   0.000000   0.000000   0.000000 (  0.000025)
# With method:  0.000000   0.000000   0.000000 (  0.000039)

puts "\nBlocks are fundamental to Ruby's design philosophy and enable many of Ruby's elegant syntax features!"