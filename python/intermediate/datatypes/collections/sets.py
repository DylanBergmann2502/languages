# Creating sets
empty_set = set()  # Note: {} creates an empty dict, not a set
numbers = {1, 2, 3, 4, 5}
mixed_set = {1, "two", 3.0, True, (5, 6)}  # Note: can't include mutable objects like lists

print("Empty set:", empty_set)  # set()
print("Numbers set:", numbers)  # {1, 2, 3, 4, 5}
print("Mixed set:", mixed_set)  # {1, 'two', 3.0, True, (5, 6)}

# Creating sets from other iterables
list_to_set = set([1, 2, 2, 3, 3, 3])  # Removes duplicates
print("Set from list with duplicates:", list_to_set)  # {1, 2, 3}

string_to_set = set("hello")  # Creates set from string characters
print("Set from string:", string_to_set)  # {'h', 'e', 'l', 'o'}

# Set comprehensions
squares_set = {x**2 for x in range(1, 6)}
print("Set comprehension squares:", squares_set)  # {1, 4, 9, 16, 25}

# Basic set operations
print("\nBasic set methods:")
print("Length:", len(numbers))  # 5
print("Min value:", min(numbers))  # 1
print("Max value:", max(numbers))  # 5
print("Sum of elements:", sum(numbers))  # 15

# Membership testing (very fast operation - O(1))
print("\nMembership testing:")
print("3 in numbers:", 3 in numbers)  # True
print("10 in numbers:", 10 in numbers)  # False

# Adding elements
print("\nAdding elements:")
fruits = {"apple", "banana", "cherry"}
print("Original set:", fruits)  # {'apple', 'banana', 'cherry'}

fruits.add("orange")
print("After add('orange'):", fruits)  # {'apple', 'banana', 'cherry', 'orange'}

# Adding multiple elements
fruits.update(["kiwi", "mango"])
print("After update(['kiwi', 'mango']):", fruits)
# {'apple', 'banana', 'cherry', 'kiwi', 'mango', 'orange'}

# Removing elements
print("\nRemoving elements:")
fruits.remove("banana")  # Raises KeyError if not found
print("After remove('banana'):", fruits)
# {'apple', 'cherry', 'kiwi', 'mango', 'orange'}

# Safe removal
fruits.discard("nonexistent")  # No error if not found
print("After discard('nonexistent'):", fruits)  # Unchanged

# Pop removes and returns an arbitrary element
popped = fruits.pop()
print("Popped element:", popped)
print("After pop():", fruits)

# Clear removes all elements
fruits.clear()
print("After clear():", fruits)  # set()

# Set operations (mathematical)
print("\nSet operations:")
A = {1, 2, 3, 4, 5}
B = {4, 5, 6, 7, 8}

# Union (elements in either set)
union = A | B  # or A.union(B)
print("A | B (union):", union)  # {1, 2, 3, 4, 5, 6, 7, 8}

# Intersection (elements in both sets)
intersection = A & B  # or A.intersection(B)
print("A & B (intersection):", intersection)  # {4, 5}

# Difference (elements in A but not in B)
difference = A - B  # or A.difference(B)
print("A - B (difference):", difference)  # {1, 2, 3}

# Symmetric difference (elements in either set, but not both)
sym_diff = A ^ B  # or A.symmetric_difference(B)
print("A ^ B (symmetric difference):", sym_diff)  # {1, 2, 3, 6, 7, 8}

# Updating sets in place
print("\nUpdating sets:")
C = {1, 2, 3}
D = {3, 4, 5}
print("Original C:", C)  # {1, 2, 3}

# Update with union
C |= {6, 7}  # or C.update({6, 7})
print("C after union update:", C)  # {1, 2, 3, 6, 7}

# Update with intersection
C &= {1, 3, 6, 8}  # or C.intersection_update({1, 3, 6, 8})
print("C after intersection update:", C)  # {1, 3, 6}

# Update with difference
C -= {3}  # or C.difference_update({3})
print("C after difference update:", C)  # {1, 6}

# Update with symmetric difference
C ^= {1, 2, 3}  # or C.symmetric_difference_update({1, 2, 3})
print("C after symmetric difference update:", C)  # {2, 3, 6}

# Set comparisons
print("\nSet comparisons:")
X = {1, 2, 3}
Y = {1, 2, 3, 4, 5}
Z = {1, 2, 3}

print("X == Z:", X == Z)  # True (same elements)
print("X != Y:", X != Y)  # True (different elements)

# Subset testing
print("X.issubset(Y):", X.issubset(Y))  # True
print("X <= Y:", X <= Y)  # True (subset)
print("X < Y:", X < Y)  # True (proper subset)
print("X < Z:", X < Z)  # False (not a proper subset)

# Superset testing
print("Y.issuperset(X):", Y.issuperset(X))  # True
print("Y >= X:", Y >= X)  # True (superset)
print("Y > X:", Y > X)  # True (proper superset)

# Disjoint testing (no common elements)
print("X.isdisjoint({6, 7}):", X.isdisjoint({6, 7}))  # True
print("X.isdisjoint({3, 4}):", X.isdisjoint({3, 4}))  # False

# Frozen sets (immutable sets)
print("\nFrozen sets:")
frozen = frozenset([1, 2, 3])
print("Frozen set:", frozen)  # frozenset({1, 2, 3})

# Try to modify (will cause error)
try:
    frozen.add(4)
except AttributeError as e:
    print("Error when modifying frozen set:", e)

# Use cases for sets
print("\nUse cases:")

# 1. Remove duplicates from a list
duplicates = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
unique = list(set(duplicates))
print("Removing duplicates:", unique)  # [1, 2, 3, 4]

# 2. Finding unique characters in a string
print("Unique chars in 'mississippi':", set("mississippi"))  # {'m', 'i', 's', 'p'}

# 3. Set operations in practice
tags1 = {"python", "programming", "code"}
tags2 = {"python", "web", "development"}

common_tags = tags1 & tags2
all_tags = tags1 | tags2
unique_to_tags1 = tags1 - tags2

print("Common tags:", common_tags)  # {'python'}
print("All tags:", all_tags)  # {'python', 'programming', 'code', 'web', 'development'}
print("Tags unique to set 1:", unique_to_tags1)  # {'programming', 'code'}

# 4. Quick membership testing
valid_users = {"alice", "bob", "charlie", "dave"}
user = "bob"
if user in valid_users:
    print(f"{user} is a valid user")  # Will print

# 5. Finding items in one list but not another
list1 = [1, 2, 3, 4, 5]
list2 = [4, 5, 6, 7, 8]
items_only_in_list1 = set(list1) - set(list2)
print("Items only in list1:", items_only_in_list1)  # {1, 2, 3}

# Performance considerations
print("\nPerformance demo:")
import time

# Create a large set and list with the same elements
large_set = set(range(100000))
large_list = list(range(100000))

# Test lookup performance
element = 99999  # Last element
not_element = 100001  # Not in either

# Set lookup
start = time.time()
result = element in large_set
end = time.time()
print(f"Set lookup (found): {end - start:.10f} seconds")

# List lookup
start = time.time()
result = element in large_list
end = time.time()
print(f"List lookup (found): {end - start:.10f} seconds")

# Not found case
start = time.time()
result = not_element in large_set
end = time.time()
print(f"Set lookup (not found): {end - start:.10f} seconds")

start = time.time()
result = not_element in large_list
end = time.time()
print(f"List lookup (not found): {end - start:.10f} seconds")