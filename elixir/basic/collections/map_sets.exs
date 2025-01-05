# MapSets have these characteristics
# Ensure uniqueness of elements
# Perform set operations efficiently (union, intersection, difference)
# Check membership quickly (O(1) operation)

# MapSet isn't heavily talked about/used in Elixir because
# Many simple use cases can be handled with list operations and Enum functions
# In web development, you often work with lists and maps more frequently
# Set operations are more common in specific domains
# like data processing or mathematical computations

# Creating a MapSet
set1 = MapSet.new([1, 2, 3, 2, 1])  # Duplicates are automatically removed
IO.inspect(set1)  # #MapSet<[1, 2, 3]>

# Adding elements
set2 = MapSet.put(set1, 4)
IO.inspect(set2)  # #MapSet<[1, 2, 3, 4]>

# Checking membership
result1 = MapSet.member?(set2, 3)
IO.inspect(result1)  # true

# Remove an element
set3 = MapSet.delete(set2, 2)
IO.inspect(set3)  # #MapSet<[1, 3, 4]>

# Set operations
set_a = MapSet.new([1, 2, 3])
set_b = MapSet.new([3, 4, 5])

# Union
union = MapSet.union(set_a, set_b)
IO.inspect(union)  # #MapSet<[1, 2, 3, 4, 5]>

# Intersection
intersection = MapSet.intersection(set_a, set_b)
IO.inspect(intersection)  # #MapSet<[3]>

# Difference
difference = MapSet.difference(set_a, set_b)
IO.inspect(difference)  # #MapSet<[1, 2]>

# Size of a set
size = MapSet.size(set_a)
IO.inspect(size)  # 3

# Convert to list
list = MapSet.to_list(set_a)
IO.inspect(list)  # [1, 2, 3]
