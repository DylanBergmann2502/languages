# Creating lists
empty_list = []
numbers = [1, 2, 3, 4, 5]
mixed_list = [1, "two", 3.0, True, [5, 6]]

print("Empty list:", empty_list)  # []
print("Numbers list:", numbers)  # [1, 2, 3, 4, 5]
print("Mixed list:", mixed_list)  # [1, 'two', 3.0, True, [5, 6]]

# Creating lists with the list constructor
chars = list("Python")
print("list('Python'):", chars)  # ['P', 'y', 't', 'h', 'o', 'n']
range_list = list(range(1, 6))
print("list(range(1, 6)):", range_list)  # [1, 2, 3, 4, 5]

# Creating lists with list comprehensions
squares = [x**2 for x in range(1, 6)]
print("List comprehension squares:", squares)  # [1, 4, 9, 16, 25]

# Accessing list elements
print("\nAccessing elements:")
print("First element:", numbers[0])  # 1
print("Last element:", numbers[-1])  # 5
print("Slicing (2:4):", numbers[2:4])  # [3, 4]
print("Slicing (1:):", numbers[1:])  # [2, 3, 4, 5]
print("Slicing (:3):", numbers[:3])  # [1, 2, 3]
print("Slicing with step (::2):", numbers[::2])  # [1, 3, 5]
print("Reverse:", numbers[::-1])  # [5, 4, 3, 2, 1]

# Basic list methods
print("\nBasic list methods:")
print("Length:", len(numbers))  # 5
print("Max value:", max(numbers))  # 5
print("Min value:", min(numbers))  # 1
print("Sum of elements:", sum(numbers))  # 15
print("Count of 3:", numbers.count(3))  # 1
print("Index of 3:", numbers.index(3))  # 2

# Modifying lists
print("\nModifying lists:")
fruits = ["apple", "banana", "cherry"]
fruits.append("orange")
print("After append('orange'):", fruits)  # ['apple', 'banana', 'cherry', 'orange']

fruits.insert(1, "blueberry")
print("After insert(1, 'blueberry'):", fruits)  # ['apple', 'blueberry', 'banana', 'cherry', 'orange']

more_fruits = ["kiwi", "mango"]
fruits.extend(more_fruits)
print("After extend(['kiwi', 'mango']):", fruits)
# ['apple', 'blueberry', 'banana', 'cherry', 'orange', 'kiwi', 'mango']

# Removing elements
removed = fruits.pop()  # Remove and return the last item
print("Popped item:", removed)  # mango
print("After pop():", fruits)
# ['apple', 'blueberry', 'banana', 'cherry', 'orange', 'kiwi']

fruits.pop(1)  # Remove item at specific index
print("After pop(1):", fruits)
# ['apple', 'banana', 'cherry', 'orange', 'kiwi']

fruits.remove("cherry")  # Remove by value
print("After remove('cherry'):", fruits)
# ['apple', 'banana', 'orange', 'kiwi']

# Sorting lists
print("\nSorting lists:")
unsorted = [3, 1, 4, 1, 5, 9, 2, 6]
print("Original:", unsorted)  # [3, 1, 4, 1, 5, 9, 2, 6]

# Non-destructive sort
sorted_list = sorted(unsorted)
print("sorted():", sorted_list)  # [1, 1, 2, 3, 4, 5, 6, 9]
print("Original after sorted():", unsorted)  # [3, 1, 4, 1, 5, 9, 2, 6]

# Destructive sort
unsorted.sort()
print("After .sort():", unsorted)  # [1, 1, 2, 3, 4, 5, 6, 9]

# Reversing lists
numbers = [1, 2, 3, 4, 5]
# Non-destructive reverse
reversed_list = list(reversed(numbers))
print("\nlist(reversed()):", reversed_list)  # [5, 4, 3, 2, 1]
print("Original after reversed():", numbers)  # [1, 2, 3, 4, 5]

# Destructive reverse
numbers.reverse()
print("After .reverse():", numbers)  # [5, 4, 3, 2, 1]

# List operations
print("\nList operations:")
list1 = [1, 2, 3]
list2 = [4, 5, 6]
concatenated = list1 + list2
print("list1 + list2:", concatenated)  # [1, 2, 3, 4, 5, 6]
repeated = list1 * 3
print("list1 * 3:", repeated)  # [1, 2, 3, 1, 2, 3, 1, 2, 3]

# Checking membership
print("\nMembership:")
print("2 in list1:", 2 in list1)  # True
print("7 in list1:", 7 in list1)  # False

# Iterating over lists
print("\nIterating over lists:")
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(f"I like {fruit}")
# I like apple
# I like banana
# I like cherry

# Enumerate for index and value
print("\nUsing enumerate:")
for i, fruit in enumerate(fruits):
    print(f"{i+1}. {fruit}")
# 1. apple
# 2. banana
# 3. cherry

# List methods for filtering and mapping
print("\nFiltering and mapping:")
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Filter (using list comprehension)
evens = [n for n in numbers if n % 2 == 0]
print("Even numbers:", evens)  # [2, 4, 6, 8, 10]

# Map (using list comprehension)
squared = [n**2 for n in numbers]
print("Squared numbers:", squared)  # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

# More powerful list comprehensions
coords = [(x, y) for x in range(1, 4) for y in range(1, 3)]
print("Coordinate pairs:", coords)
# [(1, 1), (1, 2), (2, 1), (2, 2), (3, 1), (3, 2)]

# Alternative with filter/map functions
evens_alt = list(filter(lambda x: x % 2 == 0, numbers))
print("Filter with lambda:", evens_alt)  # [2, 4, 6, 8, 10]

squared_alt = list(map(lambda x: x**2, numbers))
print("Map with lambda:", squared_alt)  # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

# List unpacking
print("\nList unpacking:")
first, *middle, last = [1, 2, 3, 4, 5]
print("First:", first)  # 1
print("Middle:", middle)  # [2, 3, 4]
print("Last:", last)  # 5

# Nested lists (multi-dimensional)
print("\nNested lists:")
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]
print("Matrix:")
for row in matrix:
    print(row)
# [1, 2, 3]
# [4, 5, 6]
# [7, 8, 9]

print("Element at row 1, col 2:", matrix[1][2])  # 6

# Flattening a nested list
flattened = [item for sublist in matrix for item in sublist]
print("Flattened matrix:", flattened)  # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Deep copy vs shallow copy
import copy
print("\nCopy operations:")
original = [[1, 2, 3], [4, 5, 6]]
shallow = original.copy()  # or list(original)
deep = copy.deepcopy(original)

original[0][0] = 99
print("Original after modification:", original)  # [[99, 2, 3], [4, 5, 6]]
print("Shallow copy (also modified):", shallow)  # [[99, 2, 3], [4, 5, 6]]
print("Deep copy (unchanged):", deep)  # [[1, 2, 3], [4, 5, 6]]

# Creating a list with common pitfall for beginners
print("\nCommon pitfalls:")
wrong_matrix = [[0] * 3] * 3
print("Initial wrong matrix:", wrong_matrix)  # [[0, 0, 0], [0, 0, 0], [0, 0, 0]]

wrong_matrix[0][0] = 1
print("Wrong matrix after modification:", wrong_matrix)
# [[1, 0, 0], [1, 0, 0], [1, 0, 0]] - all rows modified!

# Correct way to create a matrix
correct_matrix = [[0 for _ in range(3)] for _ in range(3)]
print("Initial correct matrix:", correct_matrix)
# [[0, 0, 0], [0, 0, 0], [0, 0, 0]]

correct_matrix[0][0] = 1
print("Correct matrix after modification:", correct_matrix)
# [[1, 0, 0], [0, 0, 0], [0, 0, 0]] - only first row modified