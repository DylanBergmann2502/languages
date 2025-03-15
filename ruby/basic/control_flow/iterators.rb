# Ruby iterators are methods that repeatedly execute a block of code

########################################################################
# Basic iteration with each
# each is the most common iterator in Ruby
puts "Basic each iterator:"
[1, 2, 3, 4, 5].each do |number|
  puts "Number: #{number}"
end

# each with a hash
puts "\nHash iteration with each:"
person = { name: "Ruby", age: 30, language: "English" }
person.each do |key, value|
  puts "#{key}: #{value}"
end

# each with single-line block syntax
puts "\nSingle-line block syntax:"
[1, 2, 3].each { |number| puts "Single line: #{number}" }

########################################################################
# each_with_index - provides both the element and its index
puts "\neach_with_index:"
["apple", "banana", "cherry"].each_with_index do |fruit, index|
  puts "#{index + 1}. #{fruit}"
end

########################################################################
# map/collect - transforms each element and returns a new array
puts "\nmap/collect:"
numbers = [1, 2, 3, 4, 5]
squared = numbers.map { |number| number * number }
puts "Original: #{numbers}"
puts "Squared: #{squared}"

# map vs. each
# each returns the original collection, map returns a new transformed collection
original = [1, 2, 3]
with_each = original.each { |n| n * 2 }  # Returns original array
with_map = original.map { |n| n * 2 }    # Returns new transformed array

puts "\nComparing each vs map:"
puts "Original: #{original}"
puts "After each: #{with_each}"  # [1, 2, 3]
puts "After map: #{with_map}"    # [2, 4, 6]

########################################################################
# select/find_all - filters elements based on a condition
puts "\nselect/find_all:"
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
evens = numbers.select { |number| number.even? }
puts "All numbers: #{numbers}"
puts "Even numbers: #{evens}"

########################################################################
# reject - opposite of select, removes elements that match the condition
puts "\nreject:"
odds = numbers.reject { |number| number.even? }
puts "Odd numbers: #{odds}"

########################################################################
# find/detect - returns the first element that matches the condition
puts "\nfind/detect:"
first_even = numbers.find { |number| number.even? }
puts "First even number: #{first_even}"

########################################################################
# all?, any?, none?, one? - check if conditions apply to elements
puts "\nBoolean iterators:"
numbers = [2, 4, 6, 8, 10]
all_even = numbers.all? { |number| number.even? }
puts "All even? #{all_even}"

numbers = [1, 2, 3, 4, 5]
any_even = numbers.any? { |number| number.even? }
puts "Any even? #{any_even}"

none_negative = numbers.none? { |number| number < 0 }
puts "None negative? #{none_negative}"

one_equal_three = numbers.one? { |number| number == 3 }
puts "Exactly one equals 3? #{one_equal_three}"

########################################################################
# reduce/inject - accumulates a value by combining elements
puts "\nreduce/inject:"
sum = [1, 2, 3, 4, 5].reduce(0) { |total, number| total + number }
puts "Sum: #{sum}"

# reduce without initial value uses the first element as the starting point
product = [1, 2, 3, 4, 5].reduce(:*)  # Shorthand for { |product, n| product * n }
puts "Product: #{product}"

########################################################################
# each_with_object - similar to reduce but maintains a persistent object
puts "\neach_with_object:"
result = [1, 2, 3, 4, 5].each_with_object({}) do |number, hash|
  hash[number] = number * number
end
puts "Result hash: #{result}"

########################################################################
# times, upto, downto, step - integer-based iterators
puts "\nInteger iterators:"
puts "times:"
3.times { |i| puts "times iteration #{i}" }

puts "\nupto:"
1.upto(3) { |i| puts "upto iteration #{i}" }

puts "\ndownto:"
3.downto(1) { |i| puts "downto iteration #{i}" }

puts "\nstep:"
1.step(10, 3) { |i| puts "step iteration #{i}" }  # 1, 4, 7, 10

########################################################################
# Breaking out of iterators
puts "\nBreaking out of iterators:"
result = [1, 2, 3, 4, 5].each do |number|
  puts "Processing #{number}"
  break "Stopped at #{number}" if number > 3
end
puts "Result after break: #{result}"
