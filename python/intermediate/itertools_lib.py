import itertools

# Example 1: count - creates an infinite counter
counter = itertools.count(start=10, step=2)
print("Count example:")
for i in range(5):
    print(next(counter), end=" ")  # 10 12 14 16 18

# Example 2: cycle - cycles through an iterable infinitely
print("\n\nCycle example:")
cycler = itertools.cycle(["red", "green", "blue"])
for i in range(6):
    print(next(cycler), end=" ")  # red green blue red green blue

# Example 3: repeat - repeats an element n times (or indefinitely)
print("\n\nRepeat example:")
repeater = itertools.repeat("hello", 3)
print(list(repeater))  # ['hello', 'hello', 'hello']

# Example 4: chain - chains multiple iterables together
print("\nChain example:")
result = itertools.chain([1, 2], [3, 4], [5, 6])
print(list(result))  # [1, 2, 3, 4, 5, 6]

# Example 5: compress - filters elements based on selectors
print("\nCompress example:")
data = ["A", "B", "C", "D", "E"]
selectors = [True, False, True, False, True]
result = itertools.compress(data, selectors)
print(list(result))  # ['A', 'C', 'E']

# Example 6: dropwhile - drops items while condition is true
print("\nDropwhile example:")
data = [1, 2, 3, 4, 5, 6, 7]
result = itertools.dropwhile(lambda x: x < 5, data)
print(list(result))  # [5, 6, 7]

# Example 7: takewhile - takes items while condition is true
print("\nTakewhile example:")
data = [1, 2, 3, 4, 5, 6, 7]
result = itertools.takewhile(lambda x: x < 5, data)
print(list(result))  # [1, 2, 3, 4]

# Example 8: filterfalse - filters elements that don't meet condition
print("\nFilterfalse example:")
data = [1, 2, 3, 4, 5, 6, 7]
result = itertools.filterfalse(lambda x: x % 2 == 0, data)
print(list(result))  # [1, 3, 5, 7]

# Example 9: groupby - groups consecutive items by key
print("\nGroupby example:")
data = "AAAABBBCCDAABBB"
for key, group in itertools.groupby(data):
    print(key, ":", list(group))
# A : ['A', 'A', 'A', 'A']
# B : ['B', 'B', 'B']
# C : ['C', 'C']
# D : ['D']
# A : ['A', 'A']
# B : ['B', 'B', 'B']

# Example 10: islice - slices an iterator
print("\nIslice example:")
data = "ABCDEFG"
result = itertools.islice(data, 2, 6, 2)
print(list(result))  # ['C', 'E']

# Example 11: combinations - returns r length subsequences
print("\nCombinations example:")
data = ["A", "B", "C"]
result = itertools.combinations(data, 2)
print(list(result))  # [('A', 'B'), ('A', 'C'), ('B', 'C')]

# Example 12: permutations - returns r length permutations
print("\nPermutations example:")
data = ["A", "B", "C"]
result = itertools.permutations(data, 2)
print(
    list(result)
)  # [('A', 'B'), ('A', 'C'), ('B', 'A'), ('B', 'C'), ('C', 'A'), ('C', 'B')]

# Example 13: product - cartesian product of input iterables
print("\nProduct example:")
result = itertools.product(["A", "B"], [1, 2])
print(list(result))  # [('A', 1), ('A', 2), ('B', 1), ('B', 2)]

# Example 14: accumulate - accumulates values (default: sum)
print("\nAccumulate example:")
data = [1, 2, 3, 4, 5]
result = itertools.accumulate(data)
print(list(result))  # [1, 3, 6, 10, 15]

# Using a different function with accumulate
import operator

print("\nAccumulate with multiplication:")
result = itertools.accumulate(data, operator.mul)
print(list(result))  # [1, 2, 6, 24, 120]
