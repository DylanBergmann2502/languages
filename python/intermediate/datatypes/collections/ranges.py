# Creating ranges
# range(stop) - from 0 to stop-1
simple_range = range(5)
print(list(simple_range))  # [0, 1, 2, 3, 4]

# range(start, stop) - from start to stop-1
start_stop_range = range(2, 8)
print(list(start_stop_range))  # [2, 3, 4, 5, 6, 7]

# range(start, stop, step) - from start to stop-1, stepping by step
step_range = range(1, 10, 2)
print(list(step_range))  # [1, 3, 5, 7, 9]

# Negative step for counting down
countdown = range(10, 0, -1)
print(list(countdown))  # [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

# Basic range properties
nums = range(1, 11)
print(f"Start: {nums.start}")  # Start: 1
print(f"Stop: {nums.stop}")    # Stop: 11
print(f"Step: {nums.step}")    # Step: 1

# Memory efficiency of ranges
import sys
nums_list = list(range(1000))
nums_range = range(1000)
print(f"Size of list: {sys.getsizeof(nums_list)} bytes")  # Size of list: 9032 bytes (varies by Python version)
print(f"Size of range: {sys.getsizeof(nums_range)} bytes")  # Size of range: 48 bytes (varies by Python version)

# Checking membership
print(5 in range(10))      # True
print(10 in range(10))     # False
print(5 in range(6, 10))   # False

# Common use cases for ranges
# 1. For loops
print("For loop with range:")
for i in range(5):
    print(i, end=" ")  # 0 1 2 3 4
print()

# 2. Generating indexes for sequences
fruits = ["apple", "banana", "cherry", "date"]
print("Accessing with indexes:")
for i in range(len(fruits)):
    print(f"Index {i}: {fruits[i]}")
# Index 0: apple
# Index 1: banana
# Index 2: cherry
# Index 3: date

# 3. Creating numeric lists
squares = [x**2 for x in range(1, 6)]
print(f"Squares: {squares}")  # Squares: [1, 4, 9, 16, 25]

# 4. Generating specific number sequences
even_numbers = list(range(0, 11, 2))
print(f"Even numbers: {even_numbers}")  # Even numbers: [0, 2, 4, 6, 8, 10]

odd_numbers = list(range(1, 11, 2))
print(f"Odd numbers: {odd_numbers}")    # Odd numbers: [1, 3, 5, 7, 9]

# 5. Summing ranges
print(f"Sum of numbers 1-100: {sum(range(1, 101))}")  # Sum of numbers 1-100: 5050

# 6. Using ranges with slices
r = range(0, 20)
print(list(r[5:15:2]))  # [5, 7, 9, 11, 13]

# 7. Converting ranges
# To list
print(list(range(5)))  # [0, 1, 2, 3, 4]
# To tuple
print(tuple(range(5)))  # (0, 1, 2, 3, 4)
# To set
print(set(range(5)))  # {0, 1, 2, 3, 4}

# 8. Comparing ranges
r1 = range(0, 5)
r2 = range(0, 5)
r3 = range(0, 6)
print(f"r1 == r2: {r1 == r2}")  # r1 == r2: True
print(f"r1 == r3: {r1 == r3}")  # r1 == r3: False

# 9. Finding index in range
try:
    # Ranges don't have an index method - this will fail
    print(range(10).index(5))
except AttributeError as e:
    print(f"Error: {e}")
    # Instead, for a range with start=0 and step=1, the index is the value itself
    r = range(10)
    print(f"Index of 5 in range(10): {5 if 5 in r else 'Not found'}")  # Index of 5 in range(10): 5

# 10. Range edge cases
print(list(range(5, 5)))    # [] - Empty range (start equals stop)
print(list(range(5, 2)))    # [] - Empty range (start > stop with positive step)
print(list(range(5, 2, -1)))  # [5, 4, 3] - Works with negative step

# 11. Range as an iterator
iterator = iter(range(3))
print(next(iterator))  # 0
print(next(iterator))  # 1
print(next(iterator))  # 2

try:
    print(next(iterator))
except StopIteration:
    print("Iterator exhausted")  # Iterator exhausted