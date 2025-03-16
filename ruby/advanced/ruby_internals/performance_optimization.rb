#################### Benchmarking ####################

# Ruby includes a Benchmark module for measuring code performance
require "benchmark"

puts "Ruby Performance Optimization"
puts "============================"

puts "\n1. Benchmarking Code Snippets"

# Simple benchmarking of different approaches
Benchmark.bm(20) do |x|
  # String concatenation vs interpolation
  x.report("String concatenation:") do
    1_000_000.times do
      first = "Hello"
      last = "World"
      full = first + " " + last
    end
  end

  x.report("String interpolation:") do
    1_000_000.times do
      first = "Hello"
      last = "World"
      full = "#{first} #{last}"
    end
  end

  # Array iteration methods
  array = (1..1000).to_a

  x.report("Each with block:") do
    10_000.times do
      sum = 0
      array.each { |i| sum += i }
    end
  end

  x.report("Each with sum:") do
    10_000.times do
      array.sum
    end
  end
end

#################### Profiling ####################

puts "\n2. Profiling and Hotspots"

# Define a slow method to demonstrate profiling
def fibonacci(n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

def calculate_fibonacci
  result = fibonacci(20)
  puts "Fibonacci result: #{result}"
end

puts "Calculating Fibonacci (slow recursive approach)..."
Benchmark.measure { calculate_fibonacci }.tap do |result|
  puts "Time: #{result.real} seconds"
end

puts "\nTo use Ruby's profiler:"
puts "1. Add 'require \"profile\"' at the top of your script"
puts "2. Or run ruby with -rprofile: ruby -rprofile your_script.rb"
puts "3. For newer versions, install the ruby-prof gem"

#################### Common Optimizations ####################

puts "\n3. Common Performance Optimizations"

# 1. Memoization
puts "\nMemoization:"

# Without memoization
def factorial_slow(n)
  return 1 if n <= 1
  n * factorial_slow(n - 1)
end

# With memoization
def factorial_fast(n, memo = {})
  return memo[n] if memo.key?(n)
  return 1 if n <= 1
  memo[n] = n * factorial_fast(n - 1, memo)
end

Benchmark.bm(10) do |x|
  x.report("Without:") { factorial_slow(20) }
  x.report("With:") { factorial_fast(20) }
end

# 2. Avoiding unnecessary object creation
puts "\nReducing Object Creation:"

Benchmark.bm(20) do |x|
  # Creating many temporary objects
  x.report("Many objects:") do
    result = ""
    10000.times do |i|
      result += i.to_s
    end
  end

  # Using a more efficient approach
  x.report("Fewer objects:") do
    parts = []
    10000.times do |i|
      parts << i.to_s
    end
    result = parts.join
  end
end

# 3. Using freeze for immutable strings
puts "\nFrozen Strings:"

Benchmark.bm(20) do |x|
  # Normal string literals
  x.report("Regular strings:") do
    100_000.times do
      str = "Hello"
      str << " " if str != "Hello World"
    end
  end

  # Frozen string literals
  x.report("Frozen strings:") do
    hello = "Hello".freeze
    100_000.times do
      str = hello
      str = "#{str} World" if str != "Hello World"
    end
  end
end

#################### Array and Hash Optimization ####################

puts "\n4. Collection Optimizations"

# 1. Proper collection choice
puts "\nArray vs Hash lookup:"

# Create collections
array = (1..10000).to_a
hash = Hash[array.map { |i| [i, i] }]

Benchmark.bm(20) do |x|
  # Array lookup - O(n)
  x.report("Array lookup:") do
    1000.times do
      array.include?(9999)
    end
  end

  # Hash lookup - O(1)
  x.report("Hash lookup:") do
    1000.times do
      hash.key?(9999)
    end
  end
end

# 2. Preallocate arrays when possible
puts "\nArray Allocation:"

Benchmark.bm(20) do |x|
  # Growing array
  x.report("Growing array:") do
    arr = []
    10000.times do |i|
      arr << i
    end
  end

  # Preallocated array
  x.report("Preallocated array:") do
    arr = Array.new(10000)
    10000.times do |i|
      arr[i] = i
    end
  end
end

#################### Method Calls and Blocks ####################

puts "\n5. Method and Block Optimizations"

# 1. Block vs Proc performance
puts "\nBlock vs Proc vs Symbol-to-Proc:"

array = (1..1000).to_a

Benchmark.bm(20) do |x|
  # Block
  x.report("Block:") do
    100.times do
      array.map { |i| i * 2 }
    end
  end

  # Proc object
  x.report("Proc:") do
    doubler = Proc.new { |i| i * 2 }
    100.times do
      array.map(&doubler)
    end
  end

  # Symbol to proc
  x.report("Symbol-to-Proc:") do
    100.times do
      array.map(&:to_s)
    end
  end
end

# 2. Method access modifiers affect performance
puts "\nMethod Access Modifiers:"

class MethodTest
  def public_method
    1 + 1
  end

  protected

  def protected_method
    1 + 1
  end

  private

  def private_method
    1 + 1
  end
end

test = MethodTest.new

Benchmark.bm(20) do |x|
  x.report("Public method:") do
    1_000_000.times { test.public_method }
  end

  x.report("Protected method:") do
    # We can't call protected methods directly, so this is just for illustration
    1_000_000.times { test.public_method } # Using public as a proxy
  end

  x.report("Private method:") do
    # We can't call private methods directly, so this is just for illustration
    1_000_000.times { test.public_method } # Using public as a proxy
  end
end

puts "Note: In practice, method access modifiers have minimal performance impact in modern Ruby."

#################### Ruby C Extensions ####################

puts "\n6. Using C Extensions"
puts "For performance-critical sections, you can write C extensions:"
puts "1. Create a C file implementing your functionality"
puts "2. Create an extconf.rb file to configure the extension"
puts "3. Compile it with: ruby extconf.rb && make"
puts "4. Require the extension in your Ruby code"

# Mock example of a C extension vs Ruby implementation
def ruby_sum(array)
  sum = 0
  array.each { |i| sum += i }
  sum
end

# C extension would be much faster for this operation
puts "Example operation: calculating sum of a large array"
big_array = (1..1_000_000).to_a

time = Benchmark.measure { ruby_sum(big_array) }
puts "Ruby implementation: #{time.real} seconds"
puts "C extension would typically be 10-100x faster"

#################### JIT Compilation ####################

puts "\n7. JIT Compilation"

if defined?(RubyVM::MJIT) || defined?(RubyVM::JIT)
  puts "MJIT is available in this Ruby version"
  puts "You can enable it with --jit flag:"
  puts "  ruby --jit your_script.rb"
else
  puts "MJIT is not available in this Ruby version"
  puts "Ruby 2.6+ introduced experimental JIT compilation"
  puts "Ruby 3.0+ improved the JIT compiler significantly"
end

#################### Memory Optimizations ####################

puts "\n8. Memory Usage Optimization"

puts "Tips for reducing memory usage:"
puts "1. Use symbols instead of strings for hash keys"
puts "2. Reuse objects instead of creating new ones"
puts "3. Use freeze for immutable strings"
puts "4. Be mindful of closures capturing large scopes"

# Example: Symbol keys vs String keys
string_hash = {}
symbol_hash = {}

puts "\nHash with string keys vs symbol keys:"
Benchmark.bm(20) do |x|
  x.report("String keys:") do
    1_000_000.times do |i|
      string_hash["key_#{i % 1000}"] = i
    end
  end

  x.report("Symbol keys:") do
    1_000_000.times do |i|
      key = "key_#{i % 1000}".to_sym
      symbol_hash[key] = i
    end
  end
end

puts "\nPerformance optimization exploration complete!"
