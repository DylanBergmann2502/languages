# Creating and using custom iterators in Ruby

# Ruby's iterators are powerful tools that allow us to traverse collections
# This file focuses on creating custom iterators for specialized use cases

#################################################################
# Basic Custom Iterators with Blocks

puts "--- BASIC CUSTOM ITERATORS ---"

# A simple method that yields values to a block
def count_to(limit)
  1.upto(limit) do |i|
    yield i
  end
end

puts "\nCounting to 5:"
count_to(5) { |n| puts "Number: #{n}" }
# Output:
# Number: 1
# Number: 2
# Number: 3
# Number: 4
# Number: 5

# Iterator with conditional yielding
def even_numbers_up_to(limit)
  1.upto(limit) do |i|
    yield i if i.even?
  end
end

puts "\nEven numbers up to 10:"
even_numbers_up_to(10) { |n| puts n }
# Output:
# 2
# 4
# 6
# 8
# 10

#################################################################
# Custom Iterators with Local State

puts "\n--- ITERATORS WITH LOCAL STATE ---"

# Iterator that tracks state between yields
def fibonacci_sequence(count)
  a, b = 0, 1
  count.times do
    yield a
    a, b = b, a + b
  end
end

puts "\nFirst 10 Fibonacci numbers:"
fibonacci_sequence(10) { |n| print "#{n} " }
puts
# Output: 0 1 1 2 3 5 8 13 21 34

# Iterator that maintains an accumulator
def running_sum(numbers)
  sum = 0
  numbers.each do |n|
    sum += n
    yield n, sum
  end
end

puts "\nRunning sum of [1, 2, 3, 4, 5]:"
running_sum([1, 2, 3, 4, 5]) do |number, sum|
  puts "After adding #{number}, sum is #{sum}"
end
# Output:
# After adding 1, sum is 1
# After adding 2, sum is 3
# After adding 3, sum is 6
# After adding 4, sum is 10
# After adding 5, sum is 15

#################################################################
# Creating Enumerators from Scratch

puts "\n--- CREATING ENUMERATORS ---"

# An Enumerator is an object that provides iteration functionality
# It allows for external iteration control (unlike blocks)

# Creating an Enumerator using the Kernel#to_enum method
countdown = 5.downto(1).to_enum
puts "\nCountdown using an Enumerator:"
begin
  5.times { puts countdown.next }
rescue StopIteration
  puts "Blast off!"
end
# Output:
# 5
# 4
# 3
# 2
# 1

# Creating an Enumerator with Enumerator.new
alphabet = Enumerator.new do |yielder|
  ("A".."Z").each { |letter| yielder << letter }
end

puts "\nFirst 5 letters from our alphabet Enumerator:"
5.times { puts alphabet.next }
# Output:
# A
# B
# C
# D
# E

puts "\nNext 3 letters:"
3.times { puts alphabet.next }
# Output:
# F
# G
# H

#################################################################
# Using the Enumerable Module in Custom Classes

puts "\n--- CUSTOM ENUMERABLE CLASSES ---"

# Creating a class that includes Enumerable
class Seasons
  include Enumerable

  SEASONS = ["Spring", "Summer", "Fall", "Winter"]

  def each
    SEASONS.each { |season| yield season }
  end
end

seasons = Seasons.new

puts "\nSeasons in alphabetical order:"
puts seasons.sort
# Output:
# Fall
# Spring
# Summer
# Winter

puts "\nSeasons with length > 5 characters:"
puts seasons.select { |s| s.length > 5 }
# Output:
# Spring
# Summer
# Winter

#################################################################
# Advanced: Infinite Sequences

puts "\n--- INFINITE SEQUENCES ---"

# Creating an Enumerator for an infinite sequence
def endless_fibonacci
  Enumerator.new do |yielder|
    a, b = 0, 1
    loop do
      yielder << a
      a, b = b, a + b
    end
  end
end

fibonacci = endless_fibonacci

puts "\nFirst 8 Fibonacci numbers from infinite sequence:"
8.times { print "#{fibonacci.next} " }
puts
# Output: 0 1 1 2 3 5 8 13

# Prime number generator using the Sieve of Eratosthenes approach
def prime_generator
  Enumerator.new do |yielder|
    # First prime
    yielder << 2

    # Keep track of all numbers we need to check
    candidates = Hash.new(true)
    num = 3

    loop do
      if candidates[num]
        yielder << num

        # Mark all multiples as non-prime
        i = num * num
        while i < num * 100 # Limit to avoid excessive memory use
          candidates[i] = false
          i += num
        end
      end

      num += 2  # Only check odd numbers
    end
  end
end

primes = prime_generator

puts "\nFirst 10 prime numbers:"
10.times { print "#{primes.next} " }
puts
# Output: 2 3 5 7 11 13 17 19 23 29

#################################################################
# Custom Collection Class with Advanced Iteration

puts "\n--- CUSTOM COLLECTION CLASS ---"

# A custom circular buffer with iteration support
class CircularBuffer
  include Enumerable

  def initialize(size)
    @buffer = Array.new(size)
    @max_size = size
    @head = 0
    @tail = 0
    @full = false
  end

  def push(item)
    @buffer[@tail] = item
    @tail = (@tail + 1) % @max_size

    # If tail catches up to head, we're full
    if @tail == @head
      @full = true
      @head = (@head + 1) % @max_size
    end
  end

  def pop
    return nil if empty?

    value = @buffer[@head]
    @buffer[@head] = nil
    @head = (@head + 1) % @max_size
    @full = false
    value
  end

  def size
    if @full
      @max_size
    elsif @head <= @tail
      @tail - @head
    else
      @max_size - (@head - @tail)
    end
  end

  def empty?
    !@full && @head == @tail
  end

  def each
    return to_enum(:each) unless block_given?

    if empty?
      # Empty buffer, nothing to iterate
    elsif @head < @tail
      @head.upto(@tail - 1) { |i| yield @buffer[i] }
    else
      @head.upto(@max_size - 1) { |i| yield @buffer[i] }
      0.upto(@tail - 1) { |i| yield @buffer[i] }
    end

    self
  end

  def to_s
    items = map { |item| item.to_s }
    "[#{items.join(", ")}]"
  end
end

puts "\nTest of CircularBuffer:"
buffer = CircularBuffer.new(3)

puts "Creating a buffer with capacity 3"
puts "Initial buffer: #{buffer} (size: #{buffer.size})"
# Output: Initial buffer: [] (size: 0)

puts "Pushing 'A' into buffer"
buffer.push("A")
puts "Buffer: #{buffer} (size: #{buffer.size})"
# Output: Buffer: [A] (size: 1)

puts "Pushing 'B' into buffer"
buffer.push("B")
puts "Buffer: #{buffer} (size: #{buffer.size})"
# Output: Buffer: [A, B] (size: 2)

puts "Pushing 'C' into buffer"
buffer.push("C")
puts "Buffer: #{buffer} (size: #{buffer.size})"
# Output: Buffer: [A, B, C] (size: 3)

puts "Pushing 'D' into buffer (should displace 'A')"
buffer.push("D")
puts "Buffer: #{buffer} (size: #{buffer.size})"
# Output: Buffer: [B, C, D] (size: 3)

puts "Popping from buffer: #{buffer.pop}"
# Output: Popping from buffer: B
puts "Buffer: #{buffer} (size: #{buffer.size})"
# Output: Buffer: [C, D] (size: 2)

puts "Using buffer with Enumerable methods:"
puts "Items in buffer: #{buffer.to_a.join(", ")}"
# Output: Items in buffer: C, D
puts "First item: #{buffer.first}"
# Output: First item: C
puts "Does buffer include 'C'? #{buffer.include?("C")}"
# Output: Does buffer include 'C'? true

#################################################################
# External Iterators vs Internal Iterators

puts "\n--- EXTERNAL VS INTERNAL ITERATORS ---"

range = (1..5)

puts "\nInternal iterator (each):"
range.each { |i| print "#{i} " }
puts
# Output: 1 2 3 4 5

puts "\nExternal iterator (manual):"
iterator = range.to_enum
begin
  until iterator.size == 0
    print "#{iterator.next} "
  end
rescue StopIteration
  puts # Add a newline at the end
end
puts
# Output: 1 2 3 4 5

puts "\nExternal iterator (loop):"
iterator = range.to_enum
loop do
  print "#{iterator.next} "
rescue StopIteration
  break
end
puts
# Output: 1 2 3 4 5

#################################################################
# Lazy Evaluation with Enumerator::Lazy

puts "\n--- LAZY EVALUATION ---"

# Generate a potentially infinite sequence but only take what we need
def naturals
  Enumerator.new do |yielder|
    n = 1
    loop do
      yielder << n
      n += 1
    end
  end
end

puts "\nFirst 5 even squares greater than 20:"
result = naturals.lazy
  .map { |n| n * n } # Square each number
  .select { |n| n.even? } # Keep only even squares
  .drop_while { |n| n <= 20 } # Skip until we pass 20
  .take(5) # Take only 5 numbers
  .to_a                    # Convert to array
puts result.join(", ")
# Output: 36, 64, 100, 144, 196
