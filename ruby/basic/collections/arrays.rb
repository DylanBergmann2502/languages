# Creating arrays
empty_array = []
numbers = [1, 2, 3, 4, 5]
mixed_array = [1, "two", 3.0, :four, [5, 6]]
puts "Empty array: #{empty_array}"
puts "Numbers array: #{numbers}"
puts "Mixed array: #{mixed_array}"

# Creating arrays with the Array constructor
puts "\nArray constructor:"
zeros = Array.new(5, 0)
puts "Array.new(5, 0): #{zeros}" # [0, 0, 0, 0, 0]

# Be careful with mutable objects as default values
arrays = Array.new(3, [])
puts "Arrays before modification: #{arrays}" # [[], [], []]
arrays[0] << "modified"
# All subarrays are modified!
puts "Arrays after modification: #{arrays}"  # [["modified"], ["modified"], ["modified"]]

# Proper way to initialize with blocks
unique_arrays = Array.new(3) { [] }
puts "Unique arrays before modification: #{unique_arrays}" # [[], [], []]
unique_arrays[0] << "modified"
# Only first array is modified
puts "Unique arrays after modification: #{unique_arrays}"  # [["modified"], [], []]

# Accessing array elements
puts "\nAccessing elements:"
puts "First element: #{numbers[0]}" # 1
puts "Last element: #{numbers[-1]}" # 5
puts "First 3 elements: #{numbers[0, 3]}" # [1, 2, 3]
puts "Elements at index 1 through 3: #{numbers[1..3]}" # [2, 3, 4]
puts "First element (with at): #{numbers.at(0)}" # 1

# Basic array methods
puts "\nBasic array methods:"
puts "Array size: #{numbers.size}"      # 5
puts "Array length: #{numbers.length}"  # Same as size: 5
puts "Array empty?: #{numbers.empty?}"  # false
puts "Array includes 3?: #{numbers.include?(3)}" # true
puts "First element: #{numbers.first}" # 1
puts "Last element: #{numbers.last}"   # 5
puts "First 2 elements: #{numbers.first(2)}" # [1, 2]
puts "Last 2 elements: #{numbers.last(2)}"   # [4, 5]

# Modifying arrays
puts "\nModifying arrays:"
numbers.push(6)
puts "After push(6): #{numbers}" # [1, 2, 3, 4, 5, 6]
numbers << 7  # Shorthand for push
puts "After << 7: #{numbers}"    # [1, 2, 3, 4, 5, 6, 7]
numbers.unshift(0)  # Add to beginning
puts "After unshift(0): #{numbers}" # [0, 1, 2, 3, 4, 5, 6, 7]
popped = numbers.pop  # Remove from end
puts "Popped: #{popped}, Array: #{numbers}" # Popped: 7, Array: [0, 1, 2, 3, 4, 5, 6]
shifted = numbers.shift  # Remove from beginning
puts "Shifted: #{shifted}, Array: #{numbers}" # Shifted: 0, Array: [1, 2, 3, 4, 5, 6]

# Inserting at specific position
numbers.insert(2, 2.5)
puts "After insert(2, 2.5): #{numbers}" # [1, 2, 2.5, 3, 4, 5, 6]

# Removing elements
numbers.delete(2.5)
puts "After delete(2.5): #{numbers}"  # [1, 2, 3, 4, 5, 6]
numbers = [1, 2, 3, 3, 4, 5, 5]
numbers.delete_at(3)
puts "After delete_at(3): #{numbers}" # [1, 2, 3, 4, 5, 5]
unique = numbers.uniq
puts "Unique elements: #{unique}"     # [1, 2, 3, 4, 5]
numbers.uniq!  # Modifies the original array
puts "After uniq!: #{numbers}"        # [1, 2, 3, 4, 5]

# Combining arrays
puts "\nCombining arrays:"
array1 = [1, 2, 3]
array2 = [4, 5, 6]
combined = array1 + array2
puts "array1 + array2: #{combined}" # [1, 2, 3, 4, 5, 6]
# Modifies array1
puts "array1.concat(array2): #{array1.concat(array2)}" # [1, 2, 3, 4, 5, 6]

# Array subtraction (removes elements from first array that appear in second)
a = [1, 1, 2, 2, 3, 3, 4, 5]
b = [1, 2, 4]
puts "a - b: #{a - b}"  # [3, 3, 5]

# Intersection and union
a = [1, 2, 3, 4]
b = [3, 4, 5, 6]
puts "a & b (intersection): #{a & b}"  # [3, 4]
puts "a | b (union): #{a | b}"  # [1, 2, 3, 4, 5, 6]

# Finding elements with conditions
puts "\nFinding elements:"
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
evens = numbers.select { |n| n.even? }
puts "Even numbers: #{evens}" # [2, 4, 6, 8, 10]
odds = numbers.reject { |n| n.even? }
puts "Odd numbers: #{odds}"   # [1, 3, 5, 7, 9]
first_even = numbers.find { |n| n.even? }
puts "First even number: #{first_even}" # 2

# Transforming arrays
puts "\nTransforming arrays:"
squares = numbers.map { |n| n * n }
puts "Squares: #{squares}" # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
squares_of_evens = numbers.select { |n| n.even? }.map { |n| n * n }
puts "Squares of evens: #{squares_of_evens}" # [4, 16, 36, 64, 100]

# Sorting arrays
puts "\nSorting:"
unsorted = [3, 1, 4, 1, 5, 9, 2, 6, 5]
puts "Sorted: #{unsorted.sort}" # [1, 1, 2, 3, 4, 5, 5, 6, 9]
puts "Sorted descending: #{unsorted.sort.reverse}" # [9, 6, 5, 5, 4, 3, 2, 1, 1]
# Same as reverse
puts "Sorted by custom logic: #{unsorted.sort { |a, b| b <=> a }}" # [9, 6, 5, 5, 4, 3, 2, 1, 1]

# Iterating over arrays
puts "\nIteration:"
fruits = ["apple", "banana", "cherry"]
fruits.each { |fruit| puts "I like #{fruit}" }
# I like apple
# I like banana
# I like cherry

fruits.each_with_index do |fruit, index|
  puts "#{index + 1}. #{fruit}"
end
# 1. apple
# 2. banana
# 3. cherry

# Converting arrays to other objects
puts "\nConverting arrays:"
puts "Join with comma: #{fruits.join(", ")}" # apple, banana, cherry
puts "Join with nothing: #{fruits.join}"     # applebananacherry
puts "Convert to hash: #{[[:a, 1], [:b, 2]].to_h}"  # {:a => 1, :b => 2}

# Destructive vs. non-destructive methods
puts "\nDestructive vs. non-destructive methods:"
array = [1, 2, 3, 4, 5]
new_array = array.select { |n| n.even? }
puts "Original after select: #{array}"  # Unchanged: [1, 2, 3, 4, 5]
puts "Result of select: #{new_array}"   # [2, 4]

array.select! { |n| n.even? }
puts "Original after select!: #{array}"  # Changed: [2, 4]

# Frozen arrays (immutable)
puts "\nFrozen arrays:"
frozen_array = [1, 2, 3].freeze
puts "Frozen array: #{frozen_array}" # [1, 2, 3]
begin
  frozen_array << 4  # This will raise an error
rescue Exception => e
  puts "Error when trying to modify frozen array: #{e.message}" 
end

# Multi-dimensional arrays
puts "\nMulti-dimensional arrays:"
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
puts "Matrix:"
matrix.each { |row| puts row.inspect }
# [1, 2, 3]
# [4, 5, 6]
# [7, 8, 9]
puts "Element at row 1, column 2: #{matrix[1][2]}"  # 6
