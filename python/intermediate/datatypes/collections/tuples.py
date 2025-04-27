# Creating tuples
empty_tuple = ()
singleton_tuple = (1,)  # Note the comma is required for single-element tuples
numbers = (1, 2, 3, 4, 5)
mixed_tuple = (1, "hello", 3.14, True, [1, 2, 3])
implicit_tuple = 1, 2, 3, 4  # Parentheses are optional

# Printing tuples
print("Empty tuple:", empty_tuple)  # ()
print("Singleton tuple:", singleton_tuple)  # (1,)
print("Numbers tuple:", numbers)  # (1, 2, 3, 4, 5)
print("Mixed tuple:", mixed_tuple)  # (1, 'hello', 3.14, True, [1, 2, 3])
print("Implicit tuple:", implicit_tuple)  # (1, 2, 3, 4)

# Tuple from other sequences
list_to_tuple = tuple([1, 2, 3])
string_to_tuple = tuple("Python")
print("Tuple from list:", list_to_tuple)  # (1, 2, 3)
print("Tuple from string:", string_to_tuple)  # ('P', 'y', 't', 'h', 'o', 'n')

# Accessing tuple elements
print("\nAccessing elements:")
print("First element:", numbers[0])  # 1
print("Last element:", numbers[-1])  # 5
print("Slicing (1-3):", numbers[1:4])  # (2, 3, 4)

# Tuple operations
print("\nTuple operations:")
combined = numbers + (6, 7, 8)
repeated = numbers * 2
print("Combined tuples:", combined)  # (1, 2, 3, 4, 5, 6, 7, 8)
print("Repeated tuple:", repeated)  # (1, 2, 3, 4, 5, 1, 2, 3, 4, 5)

# Tuple methods
print("\nTuple methods:")
more_numbers = (5, 1, 5, 3, 2, 5, 4)
print("Count of 5:", more_numbers.count(5))  # 3
print("Index of 3:", more_numbers.index(3))  # 3

# Membership testing
print("\nMembership testing:")
print("Is 3 in numbers?", 3 in numbers)  # True
print("Is 6 in numbers?", 6 in numbers)  # False

# Tuple unpacking
print("\nTuple unpacking:")
a, b, c = (1, 2, 3)
print(f"a = {a}, b = {b}, c = {c}")  # a = 1, b = 2, c = 3

# Extended unpacking (Python 3.x)
first, *middle, last = (1, 2, 3, 4, 5)
print(f"first = {first}, middle = {middle}, last = {last}")  # first = 1, middle = [2, 3, 4], last = 5

# Swapping variables using tuples
print("\nSwapping variables:")
x, y = 10, 20
print(f"Before swap: x = {x}, y = {y}")  # Before swap: x = 10, y = 20
x, y = y, x  # Tuple packing and unpacking
print(f"After swap: x = {x}, y = {y}")  # After swap: x = 20, y = 10

# Immutability of tuples
print("\nImmutability:")
try:
    numbers[0] = 10  # This will raise a TypeError
except TypeError as e:
    print("Error:", e)  # Error: 'tuple' object does not support item assignment

# But mutable elements inside tuples can be modified
mutable_in_tuple = ([1, 2], [3, 4])
print("Before modification:", mutable_in_tuple)  # ([1, 2], [3, 4])
mutable_in_tuple[0].append(3)
print("After modification:", mutable_in_tuple)  # ([1, 2, 3], [3, 4])

# Tuples as dictionary keys (since they're immutable)
print("\nTuples as dictionary keys:")
coordinates = {
    (0, 0): "origin",
    (1, 0): "right",
    (0, 1): "up"
}
print("Dictionary with tuple keys:", coordinates)  # {(0, 0): 'origin', (1, 0): 'right', (0, 1): 'up'}
print("Value at origin:", coordinates[(0, 0)])  # origin

# Tuple comparison
print("\nTuple comparison:")
print("(1, 2) < (2, 1):", (1, 2) < (2, 1))  # True
print("(1, 2) < (1, 3):", (1, 2) < (1, 3))  # True
print("(1, 2) == (1, 2):", (1, 2) == (1, 2))  # True

# Named tuples (from collections module)
from collections import namedtuple
print("\nNamed tuples:")
Person = namedtuple('Person', ['name', 'age', 'city'])
alice = Person(name='Alice', age=30, city='New York')
print("Named tuple:", alice)  # Person(name='Alice', age=30, city='New York')
print("Access by name:", alice.name)  # Alice
print("Access by index:", alice[0])  # Alice

# Converting tuples to other types
print("\nConverting tuples:")
tuple_to_list = list(numbers)
print("Tuple to list:", tuple_to_list)  # [1, 2, 3, 4, 5]
print("Tuple to string:", ''.join(map(str, numbers)))  # 12345

# Sorting tuples
people = [('Alice', 25), ('Bob', 30), ('Charlie', 20)]
print("\nSorting tuples:")
print("People sorted by name:", sorted(people))  # [('Alice', 25), ('Bob', 30), ('Charlie', 20)]
print("People sorted by age:", sorted(people, key=lambda x: x[1]))  # [('Charlie', 20), ('Alice', 25), ('Bob', 30)]

# Performance benefits of tuples
import sys
list_example = [1, 2, 3, 4, 5]
tuple_example = (1, 2, 3, 4, 5)
print("\nMemory usage:")
print(f"List size: {sys.getsizeof(list_example)} bytes")
print(f"Tuple size: {sys.getsizeof(tuple_example)} bytes")

# Time your tuple operations
import timeit
list_creation = timeit.timeit(stmt="[1, 2, 3, 4, 5]", number=1000000)
tuple_creation = timeit.timeit(stmt="(1, 2, 3, 4, 5)", number=1000000)
print(f"\nTime to create 1M lists: {list_creation:.6f} seconds")
print(f"Time to create 1M tuples: {tuple_creation:.6f} seconds")