# ranges.rb - Understanding ranges in Ruby

# Creating ranges
inclusive_range = 1..10      # Inclusive range (includes 10)
exclusive_range = 1...10     # Exclusive range (excludes 10)
char_range = "a".."z"        # Character range
reverse_range = 10..1        # Reverse range (exists but behaves differently)

puts "Range examples:"
puts "Inclusive range (1..10): #{inclusive_range}"       # 1..10
puts "Exclusive range (1...10): #{exclusive_range}"      # 1...10
puts "Character range ('a'..'z'): #{char_range}"         # "a".."z"
puts "Reverse range (10..1): #{reverse_range}"           # 10..1

# Range to array conversion
puts "\nConverting ranges to arrays:"
puts "Inclusive range to array: #{(1..5).to_a}"          # [1, 2, 3, 4, 5]
puts "Exclusive range to array: #{(1...5).to_a}"         # [1, 2, 3, 4]
puts "Character range to array: #{("a".."e").to_a}"      # ["a", "b", "c", "d", "e"]
puts "Reverse range to array: #{(10..1).to_a}"           # [] (empty because reverse)

# Membership testing
puts "\nMembership testing:"
puts "5 in 1..10? #{(1..10).include?(5)}"               # true
puts "10 in 1..10? #{(1..10).include?(10)}"             # true
puts "10 in 1...10? #{(1...10).include?(10)}"           # false
puts "'c' in 'a'..'z'? #{("a".."z").include?("c")}"     # true

# Using cover? method (faster for numeric and string ranges)
puts "\nUsing the cover? method:"
puts "5 covered by 1..10? #{(1..10).cover?(5)}"         # true
puts "10.5 covered by 1..10? #{(1..10).cover?(10.5)}"   # false
puts "'cat' covered by 'a'..'z'? #{("a".."z").cover?("cat")}" # true (!)
puts "'cat' included in 'a'..'z'? #{("a".."z").include?("cat")}" # false

# Note: cover? tests if the start/end of the range "cover" the value
# include? checks if value is actually in the list of range elements

# Iterating through ranges
puts "\nIterating through ranges:"
print "Using each: "
(1..5).each { |num| print "#{num} " }                   # 1 2 3 4 5
puts

print "Collecting values: "
puts (1..5).map { |num| num * 2 }.inspect               # [2, 4, 6, 8, 10]

print "Selecting values: "
puts (1..10).select { |num| num.even? }.inspect         # [2, 4, 6, 8, 10]

# Range bounds and properties
puts "\nRange properties:"
puts "First element: #{(1..10).first}"                  # 1
puts "First 3 elements: #{(1..10).first(3).inspect}"    # [1, 2, 3]
puts "Last element: #{(1..10).last}"                    # 10
puts "Last 3 elements: #{(1..10).last(3).inspect}"      # [8, 9, 10]
puts "Begin value: #{(1..10).begin}"                    # 1
puts "End value: #{(1..10).end}"                        # 10
puts "Exclusive? #{(1..10).exclude_end?}"               # false
puts "Exclusive? #{(1...10).exclude_end?}"              # true
puts "Size: #{(1..10).size}"                            # 10
puts "Size of char range: #{("a".."z").size}"           # 26

# Ranges with steps
puts "\nRanges with steps:"
print "Step by 2: "
(1..10).step(2) { |num| print "#{num} " }               # 1 3 5 7 9
puts

# Using ranges with case statements
puts "\nRanges in case statements:"

def grade_letter(score)
  case score
  when 90..100
    "A"
  when 80...90
    "B"
  when 70...80
    "C"
  when 60...70
    "D"
  else
    "F"
  end
end

puts "Score 95 gets grade: #{grade_letter(95)}"         # A
puts "Score 82 gets grade: #{grade_letter(82)}"         # B
puts "Score 45 gets grade: #{grade_letter(45)}"         # F

# Ranges for slicing
array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
puts "\nRanges for slicing:"
puts "Array[2..5]: #{array[2..5].inspect}"              # [2, 3, 4, 5]
puts "Array[2...5]: #{array[2...5].inspect}"            # [2, 3, 4]
puts "Array[2..-1]: #{array[2..-1].inspect}"            # [2, 3, 4, 5, 6, 7, 8, 9]
puts "Array[-5..-2]: #{array[-5..-2].inspect}"          # [5, 6, 7, 8]

string = "Hello, Ruby World!"
puts "String[0..4]: #{string[0..4]}"                    # Hello
puts "String[7..-2]: #{string[7..-2]}"                  # Ruby World

# Endless ranges (Ruby 2.6+)
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.6")
  puts "\nEndless ranges (Ruby 2.6+):"
  endless = (1..)
  puts "Endless range: #{endless}"
  puts "First 5 elements: #{endless.first(5).inspect}"    # [1, 2, 3, 4, 5]

  puts "Array[3..]: #{array[3..].inspect}"               # [3, 4, 5, 6, 7, 8, 9]
else
  puts "\nEndless ranges not available in this Ruby version (requires 2.6+)"
end

# Beginless ranges (Ruby 2.7+)
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.7")
  puts "\nBeginless ranges (Ruby 2.7+):"
  beginless = (..5)
  puts "Beginless range: #{beginless}"
  puts "Array[..3]: #{array[..3].inspect}"                # [0, 1, 2, 3]
  puts "5 covered by ..10? #{(..10).cover?(5)}"           # true
  puts "-5 covered by ..10? #{(..10).cover?(-5)}"         # true
else
  puts "\nBeginless ranges not available in this Ruby version (requires 2.7+)"
end

# Generating random numbers from a range
puts "\nRandom numbers from a range:"
puts "Random from 1..10: #{rand(1..10)}"                # Random number between 1 and 10 (inclusive)
puts "Random from 1...10: #{rand(1...10)}"              # Random number between 1 and 9

# Using ranges with each_with_index
puts "\nRanges with each_with_index:"
print "Indices and values: "
("a".."e").each_with_index { |letter, index| print "(#{index}:#{letter}) " }  # (0:a) (1:b) (2:c) (3:d) (4:e)
puts

# Range iteration efficiency (ranges don't create intermediate arrays)
puts "\nRange iteration efficiency:"
puts "Memory usage of direct range iteration:"
require "benchmark"
puts Benchmark.measure {
  sum = 0
  (1..1_000_000).each { |i| sum += i }
}.format("%r")

puts "Memory usage with array conversion:"
puts Benchmark.measure {
  sum = 0
  (1..1_000_000).to_a.each { |i| sum += i }
}.format("%r")

# Infinite ranges (beware of endless loops!)
puts "\nCareful with infinite ranges:"
puts "You can create endless ranges but must limit iterations"
puts "Example: (1..).first(5) => #{(1..).first(5).inspect}" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.6")

# Custom objects in ranges
puts "\nCustom objects in ranges:"

class Temperature
  include Comparable
  attr_reader :celsius

  def initialize(celsius)
    @celsius = celsius
  end

  def <=>(other)
    celsius <=> other.celsius
  end

  def to_s
    "#{celsius}°C"
  end
end

freezing = Temperature.new(0)
boiling = Temperature.new(100)
temp_range = freezing..boiling

warm = Temperature.new(30)
cold = Temperature.new(-10)

puts "Warm (#{warm}) in range? #{temp_range.include?(warm)}"  # true
puts "Cold (#{cold}) in range? #{temp_range.include?(cold)}"  # false
