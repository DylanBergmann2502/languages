# The Enumerable module provides collection classes with powerful traversal
# and searching methods. Arrays and Hashes both include this module.

# Basic collections for demonstration
numbers = [1, 2, 3, 4, 5]
hash = { a: 1, b: 2, c: 3 }
range = (1..5)

puts "Collections for demonstration:"
puts "Numbers: #{numbers}"
puts "Hash: #{hash}"
puts "Range: #{range}"

# Iteration Methods
puts "\n--- Basic Iteration ---"

# each - Fundamental iterator
puts "\neach:"
numbers.each { |n| print "#{n} " }
puts "\n"

# each_with_index - Provides index along with element
puts "\neach_with_index:"
numbers.each_with_index { |n, i| puts "Index #{i}: #{n}" }

# each_with_object - Passes object to block, returns object
puts "\neach_with_object:"
result = numbers.each_with_object([]) { |n, arr| arr << n * 2 }
puts "Doubled with each_with_object: #{result}"

hash_result = hash.each_with_object({}) { |(k, v), h| h[k] = v * 2 }
puts "Doubled hash values: #{hash_result}"

# Transformation Methods
puts "\n--- Transformation Methods ---"

# map/collect - Creates new array with results of block
puts "\nmap/collect:"
squares = numbers.map { |n| n * n }
puts "Squares with map: #{squares}"

# flat_map - Map + flatten(1)
puts "\nflat_map:"
nested = [[1, 2], [3, 4]]
flattened = nested.flat_map { |arr| arr }
puts "Flattened with flat_map: #{flattened}"
expanded = nested.flat_map { |arr| arr.map { |n| n * 2 } }
puts "Expanded with flat_map: #{expanded}"

# Filtering Methods
puts "\n--- Filtering Methods ---"

# select/find_all - Returns elements meeting condition
puts "\nselect/find_all:"
evens = numbers.select { |n| n.even? }
puts "Even numbers: #{evens}"

# reject - Returns elements NOT meeting condition
puts "\nreject:"
odds = numbers.reject { |n| n.even? }
puts "Odd numbers: #{odds}"

# grep - Selects elements matching pattern
puts "\ngrep:"
strings = ["apple", "banana", "apricot", "berry"]
a_fruits = strings.grep(/^a/)
puts "Fruits starting with 'a': #{a_fruits}"

# grep_v - Selects elements NOT matching pattern (Ruby 2.6+)
puts "\ngrep_v:"
non_a_fruits = strings.grep_v(/^a/)
puts "Fruits not starting with 'a': #{non_a_fruits}"

# Finding Methods
puts "\n--- Finding Methods ---"

# find/detect - Returns first element meeting condition
puts "\nfind/detect:"
first_even = numbers.find { |n| n.even? }
puts "First even number: #{first_even}"

# find_index - Returns index of first matching element
puts "\nfind_index:"
even_index = numbers.find_index { |n| n.even? }
puts "Index of first even number: #{even_index}"

# Checking Methods
puts "\n--- Checking Methods ---"

# all? - True if all elements meet condition
puts "\nall?:"
all_positive = numbers.all? { |n| n > 0 }
puts "All positive? #{all_positive}"

# any? - True if any element meets condition
puts "\nany?:"
any_even = numbers.any? { |n| n.even? }
puts "Any even? #{any_even}"

# none? - True if no element meets condition
puts "\nnone?:"
none_negative = numbers.none? { |n| n < 0 }
puts "None negative? #{none_negative}"

# one? - True if exactly one element meets condition
puts "\none?:"
one_greater_than_four = numbers.one? { |n| n > 4 }
puts "One greater than 4? #{one_greater_than_four}"

# include?/member? - Checks if collection includes value
puts "\ninclude?/member?:"
includes_three = numbers.include?(3)
puts "Includes 3? #{includes_three}"

# Counting and Mathematical Methods
puts "\n--- Counting and Mathematical Methods ---"

# count - Counts elements meeting condition
puts "\ncount:"
even_count = numbers.count { |n| n.even? }
puts "Count of even numbers: #{even_count}"

# tally - Count occurrences (Ruby 2.7+)
puts "\ntally:"
letters = ["a", "b", "a", "c", "a", "b"]
tally_result = letters.tally
puts "Letter counts: #{tally_result}"

# sum - Sums elements
puts "\nsum:"
sum_result = numbers.sum
puts "Sum: #{sum_result}"
sum_squares = numbers.sum { |n| n * n }
puts "Sum of squares: #{sum_squares}"

# min, max - Find minimum/maximum
puts "\nmin/max:"
puts "Min: #{numbers.min}"
puts "Max: #{numbers.max}"

# minmax - Returns array with [min, max]
puts "\nminmax:"
puts "Minmax: #{numbers.minmax}"

# min_by, max_by - Find based on block value
puts "\nmin_by/max_by:"
words = ["apple", "banana", "fig", "strawberry"]
shortest = words.min_by { |word| word.length }
longest = words.max_by { |word| word.length }
puts "Shortest word: #{shortest}"
puts "Longest word: #{longest}"

# Grouping and Sorting Methods
puts "\n--- Grouping and Sorting Methods ---"

# sort - Sorts collection
puts "\nsort:"
unsorted = [3, 1, 4, 1, 5, 9, 2, 6]
sorted = unsorted.sort
puts "Sorted: #{sorted}"

# sort_by - Sorts based on block return value
puts "\nsort_by:"
words = ["apple", "banana", "fig", "strawberry"]
by_length = words.sort_by { |word| word.length }
puts "Sorted by length: #{by_length}"

# group_by - Groups elements by block result
puts "\ngroup_by:"
grouped = numbers.group_by { |n| n.even? ? "even" : "odd" }
puts "Grouped by parity: #{grouped}"

# partition - Divides into two arrays based on block
puts "\npartition:"
evens_and_odds = numbers.partition { |n| n.even? }
puts "Partitioned into evens and odds: #{evens_and_odds}"

# chunk - Groups consecutive elements
puts "\nchunk:"
puts "Chunked by parity:"
numbers.chunk { |n| n.even? }.each do |even, elements|
  puts "#{even ? "Even" : "Odd"}: #{elements}"
end

# Advanced Methods
puts "\n--- Advanced Methods ---"

# reduce/inject - Accumulates result
puts "\nreduce/inject:"
sum = numbers.reduce(0) { |acc, n| acc + n }
puts "Sum with reduce: #{sum}"

product = numbers.reduce(1) { |acc, n| acc * n }
puts "Product with reduce: #{product}"

# Using symbol shorthand with reduce
sum_shorthand = numbers.reduce(:+)
puts "Sum with symbol shorthand: #{sum_shorthand}"
product_shorthand = numbers.reduce(:*)
puts "Product with symbol shorthand: #{product_shorthand}"

# cycle - Repeats iteration specified number of times
puts "\ncycle:"
print "First 3 cycles: "
numbers.cycle(3) { |n| print "#{n} " }
puts

# zip - Combines elements from multiple arrays
puts "\nzip:"
letters = ["a", "b", "c", "d", "e"]
zipped = numbers.zip(letters)
puts "Zipped arrays: #{zipped}"
zipped_with_block = []
numbers.zip(letters) { |number, letter| zipped_with_block << "#{letter}:#{number}" }
puts "Zipped with block: #{zipped_with_block}"

# take/drop - Take or drop first n elements
puts "\ntake/drop:"
puts "First 3 elements: #{numbers.take(3)}"
puts "Drop first 3 elements: #{numbers.drop(3)}"

# take_while/drop_while - Take/drop based on condition
puts "\ntake_while/drop_while:"
take_result = numbers.take_while { |n| n < 4 }
puts "Take while < 4: #{take_result}"
drop_result = numbers.drop_while { |n| n < 4 }
puts "Drop while < 4: #{drop_result}"

# Lazy Enumeration (for large or infinite collections)
puts "\n--- Lazy Enumeration ---"
infinite = (1..Float::INFINITY).lazy

# Process first 5 even squares
puts "First 5 even squares:"
even_squares = infinite.map { |n| n * n }.select { |n| n.even? }.take(5).force
puts even_squares

# Defining own Enumerable class
puts "\n--- Custom Enumerable Class ---"

class Fibonacci
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    return enum_for(:each) unless block_given?

    a, b = 0, 1
    while a < @limit
      yield a
      a, b = b, a + b
    end
  end
end

fib = Fibonacci.new(100)
puts "Fibonacci numbers < 100:"
puts fib.to_a
puts "Even Fibonacci numbers < 100:"
puts fib.select { |n| n.even? }
