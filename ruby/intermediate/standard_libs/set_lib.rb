# Set is a collection of unordered values with no duplicates
# It provides methods for set-theoretic operations and is implemented using a Hash
# First, let's require the set library
require "set"

########################################################################
# Creating Sets
# There are multiple ways to create a Set

# Create an empty Set
empty_set = Set.new
puts "Empty set: #{empty_set.inspect}" # #<Set: {}>

# Create a Set from an Array
array = [1, 2, 3, 4, 5]
set_from_array = Set.new(array)
puts "Set from array: #{set_from_array.inspect}" # #<Set: {1, 2, 3, 4, 5}>

# Create a Set with duplicate elements - duplicates are automatically removed
duplicate_array = [1, 2, 2, 3, 3, 3, 4, 5, 5]
set_from_duplicates = Set.new(duplicate_array)
puts "Set from array with duplicates: #{set_from_duplicates.inspect}" # #<Set: {1, 2, 3, 4, 5}>

# Create a Set using the literal syntax with Kernel#Set
s1 = Set[1, 2, 3, 4, 5]
puts "Set created with literal syntax: #{s1.inspect}" # #<Set: {1, 2, 3, 4, 5}>

# Create a Set with a block - each element will be processed by the block
set_with_block = Set.new([1, 2, 3, 4, 5]) { |i| i * 2 }
puts "Set created with a block: #{set_with_block.inspect}" # #<Set: {2, 4, 6, 8, 10}>

########################################################################
# Basic Operations
# Sets provide methods for common operations

# Check if a Set is empty
puts "Is empty_set empty? #{empty_set.empty?}" # true

# Get the size/length of a Set
puts "Size of set_from_array: #{set_from_array.size}" # 5
puts "Length of set_from_array: #{set_from_array.length}" # 5 (alias for size)

# Check if a Set includes an element
puts "Does set_from_array include 3? #{set_from_array.include?(3)}" # true
puts "Does set_from_array include 10? #{set_from_array.include?(10)}" # false

# Alternative ways to check membership
puts "Is 3 a member of set_from_array? #{set_from_array.member?(3)}" # true
puts "Is 3 === set_from_array? #{set_from_array === 3}" # true (another alias for include?)

########################################################################
# Adding and Removing Elements
# Sets provide methods for adding and removing elements

# Add a single element
set = Set.new([1, 2, 3])
set.add(4)
puts "After adding 4: #{set.inspect}" # #<Set: {1, 2, 3, 4}>

# Add can be chained (returns the set itself)
set.add(5).add(6)
puts "After adding 5 and 6: #{set.inspect}" # #<Set: {1, 2, 3, 4, 5, 6}>

# << is an alias for add
set << 7
puts "After using << to add 7: #{set.inspect}" # #<Set: {1, 2, 3, 4, 5, 6, 7}>

# Add multiple elements at once
set.merge([8, 9, 10])
puts "After merging [8, 9, 10]: #{set.inspect}" # #<Set: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}>

# Adding duplicates has no effect
set.add(5)
puts "After adding 5 again: #{set.inspect}" # #<Set: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}>

# Remove a single element
set.delete(10)
puts "After deleting 10: #{set.inspect}" # #<Set: {1, 2, 3, 4, 5, 6, 7, 8, 9}>

# Deleting a non-existent element doesn't raise an error
set.delete(100)
puts "After trying to delete 100: #{set.inspect}" # #<Set: {1, 2, 3, 4, 5, 6, 7, 8, 9}>

# Remove elements based on a condition
set.delete_if { |i| i > 7 }
puts "After deleting elements > 7: #{set.inspect}" # #<Set: {1, 2, 3, 4, 5, 6, 7}>

# Keep elements based on a condition (opposite of delete_if)
set.keep_if { |i| i.even? }
puts "After keeping only even elements: #{set.inspect}" # #<Set: {2, 4, 6}>

# Remove and return an arbitrary element
# Note: Set doesn't have a 'pop' method like Array does
# Instead, we can take the first element and then delete it

# Alternative approaches:
element = set.first  # Get an arbitrary element
set.delete(element)  # Remove it
puts "Removed element: #{element}"
puts "Set after removal: #{set.inspect}"

# Or use #take which is available through Enumerable
element = set.take(1)[0]  # Get the first element as an array and extract it
set.delete(element)
puts "Removed element via take: #{element}"
puts "Set after removal: #{set.inspect}"

########################################################################
# Set Operations
# Sets provide methods for common set operations

# Create two sets for demonstration
set1 = Set[1, 2, 3, 4, 5]
set2 = Set[4, 5, 6, 7, 8]

puts "set1: #{set1.inspect}"
puts "set2: #{set2.inspect}"

# Union (elements in either set)
union = set1 + set2  # or set1.union(set2) or set1 | set2
puts "Union (set1 + set2): #{union.inspect}" # #<Set: {1, 2, 3, 4, 5, 6, 7, 8}>

# Intersection (elements in both sets)
intersection = set1 & set2  # or set1.intersection(set2)
puts "Intersection (set1 & set2): #{intersection.inspect}" # #<Set: {4, 5}>

# Difference (elements in set1 but not in set2)
difference = set1 - set2  # or set1.difference(set2)
puts "Difference (set1 - set2): #{difference.inspect}" # #<Set: {1, 2, 3}>

# Symmetric Difference (elements in either set but not in both)
symmetric_difference = set1 ^ set2  # or set1.difference(set2).union(set2.difference(set1))
puts "Symmetric Difference (set1 ^ set2): #{symmetric_difference.inspect}" # #<Set: {1, 2, 3, 6, 7, 8}>

# Subset and superset relations
set3 = Set[1, 2]
puts "set3: #{set3.inspect}"

# Check if set3 is a subset of set1
puts "Is set3 a subset of set1? #{set3.subset?(set1)}" # true

# Check if set1 is a superset of set3
puts "Is set1 a superset of set3? #{set1.superset?(set3)}" # true

# Check if sets are disjoint (have no elements in common)
puts "Are set1 and set3 disjoint? #{set1.disjoint?(set3)}" # false
puts "Are set3 and Set[4, 5] disjoint? #{set3.disjoint?(Set[4, 5])}" # true

########################################################################
# Iterating Over Sets
# Sets are enumerable, so you can use all Enumerable methods

# Basic iteration
puts "Elements in set1:"
set1.each { |element| puts "- #{element}" }

# Mapping elements (returns an Array, not a Set)
squares = set1.map { |n| n * n }
puts "Squares of elements in set1: #{squares.inspect}" # [1, 4, 9, 16, 25]

# Converting map result back to a Set if needed
square_set = Set.new(set1.map { |n| n * n })
puts "Square set: #{square_set.inspect}" # #<Set: {1, 4, 9, 16, 25}>

# Filtering elements
evens = set1.select { |n| n.even? }
puts "Even elements in set1: #{evens.inspect}" # #<Set: {2, 4}>

# Other Enumerable methods work too
puts "Sum of set1: #{set1.sum}" # 15
puts "Maximum in set1: #{set1.max}" # 5
puts "All elements in set1 < 10? #{set1.all? { |n| n < 10 }}" # true

########################################################################
# Comparing Sets
# Sets can be compared for equality

# Two sets are equal if they contain the same elements
set_a = Set[1, 2, 3]
set_b = Set[3, 2, 1]  # Order doesn't matter
set_c = Set[1, 2, 3, 4]

puts "set_a: #{set_a.inspect}"
puts "set_b: #{set_b.inspect}"
puts "set_c: #{set_c.inspect}"

puts "set_a == set_b? #{set_a == set_b}" # true
puts "set_a == set_c? #{set_a == set_c}" # false

# Check if a set is a proper subset (subset but not equal)
puts "Is set_a a proper subset of set_c? #{set_a.proper_subset?(set_c)}" # true
puts "Is set_a a proper subset of set_b? #{set_a.proper_subset?(set_b)}" # false

# Check if a set is a proper superset (superset but not equal)
puts "Is set_c a proper superset of set_a? #{set_c.proper_superset?(set_a)}" # true
puts "Is set_b a proper superset of set_a? #{set_b.proper_superset?(set_a)}" # false

########################################################################
# Frozen Sets
# Sets can be frozen to prevent modification

# Create a frozen set
frozen_set = Set[1, 2, 3].freeze
puts "frozen_set: #{frozen_set.inspect}" # #<Set: {1, 2, 3}>

begin
  frozen_set.add(4)
rescue => e
  puts "Error when modifying frozen set: #{e.message}" # can't modify frozen Set
end

########################################################################
# SortedSet
# Ruby also provides a SortedSet class in the set library
# Note: SortedSet is deprecated in newer Ruby versions
# In Ruby 3.0+, use Set with Array.sort or another approach

# Try to use SortedSet if available
begin
  require "set"

  # Create a SortedSet (elements are kept in sorted order)
  sorted_set = SortedSet.new([3, 1, 4, 1, 5, 9, 2, 6])
  puts "SortedSet: #{sorted_set.inspect}" # #<SortedSet: {1, 2, 3, 4, 5, 6, 9}>

  # SortedSet maintains order when adding elements
  sorted_set.add(7)
  puts "SortedSet after adding 7: #{sorted_set.inspect}" # #<SortedSet: {1, 2, 3, 4, 5, 6, 7, 9}>

  # Alternative for newer Ruby versions
  puts "Note: SortedSet is deprecated in newer Ruby versions"
rescue => e
  # Handle the case where SortedSet is not available
  puts "SortedSet is not available or deprecated:"

  # Alternative using regular Set and sorting when needed
  set = Set[3, 1, 4, 1, 5, 9, 2, 6]
  sorted_elements = set.to_a.sort
  puts "Regular Set: #{set.inspect}"
  puts "Sorted elements: #{sorted_elements.inspect}" # [1, 2, 3, 4, 5, 6, 9]
end

########################################################################
# Practical Use Cases
# Common scenarios where Sets are useful

# 1. Removing duplicates from an array
array_with_duplicates = [1, 2, 3, 2, 1, 4, 5, 4, 3]
unique_array = Set.new(array_with_duplicates).to_a
puts "Original array: #{array_with_duplicates.inspect}"
puts "Array with duplicates removed: #{unique_array.inspect}" # [1, 2, 3, 4, 5]

# 2. Finding common elements between arrays
array1 = [1, 2, 3, 4, 5]
array2 = [3, 4, 5, 6, 7]
common_elements = Set.new(array1) & Set.new(array2)
puts "Common elements between arrays: #{common_elements.to_a.inspect}" # [3, 4, 5]

# 3. Checking for uniqueness in constant time
set = Set.new(["apple", "banana", "orange"])

def contains_fruit?(set, fruit)
  set.include?(fruit) # O(1) operation, much faster than array.include? for large collections
end

puts "Contains apple? #{contains_fruit?(set, "apple")}" # true
puts "Contains grape? #{contains_fruit?(set, "grape")}" # false

# 4. Set-based operations on tags
post1_tags = Set["ruby", "programming", "web"]
post2_tags = Set["ruby", "rails", "web"]

all_tags = post1_tags | post2_tags  # Union
common_tags = post1_tags & post2_tags  # Intersection
unique_to_post1 = post1_tags - post2_tags  # Difference

puts "All tags: #{all_tags.to_a.inspect}" # ["ruby", "programming", "web", "rails"]
puts "Common tags: #{common_tags.to_a.inspect}" # ["ruby", "web"]
puts "Tags only in post1: #{unique_to_post1.to_a.inspect}" # ["programming"]
