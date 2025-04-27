# Creating frozen sets
empty_frozen = frozenset()
frozen_from_list = frozenset([1, 2, 3, 4, 5])
frozen_from_string = frozenset("hello")
frozen_with_duplicates = frozenset([1, 2, 2, 3, 3, 3])  # Duplicates are removed

# Printing frozen sets
print("Empty frozen set:", empty_frozen)  # frozenset()
print("Frozen set from list:", frozen_from_list)  # frozenset({1, 2, 3, 4, 5})
print("Frozen set from string:", frozen_from_string)  # frozenset({'h', 'e', 'l', 'o'})
print("Frozen set with duplicates:", frozen_with_duplicates)  # frozenset({1, 2, 3})

# Basic properties of frozen sets
print("\nBasic properties:")
print("Length of frozen_from_list:", len(frozen_from_list))  # 5
print("Is 3 in frozen_from_list?", 3 in frozen_from_list)  # True
print("Is 6 in frozen_from_list?", 6 in frozen_from_list)  # False

# Set operations with frozen sets
print("\nSet operations:")
frozen_set1 = frozenset([1, 2, 3, 4])
frozen_set2 = frozenset([3, 4, 5, 6])

# Union - all elements from both sets
union_result = frozen_set1 | frozen_set2  # or: frozen_set1.union(frozen_set2)
print("Union:", union_result)  # frozenset({1, 2, 3, 4, 5, 6})

# Intersection - elements common to both sets
intersection_result = frozen_set1 & frozen_set2  # or: frozen_set1.intersection(frozen_set2)
print("Intersection:", intersection_result)  # frozenset({3, 4})

# Difference - elements in first set but not in second
difference_result = frozen_set1 - frozen_set2  # or: frozen_set1.difference(frozen_set2)
print("Difference (1-2):", difference_result)  # frozenset({1, 2})
print("Difference (2-1):", frozen_set2 - frozen_set1)  # frozenset({5, 6})

# Symmetric difference - elements in either set but not in both
symmetric_diff = frozen_set1 ^ frozen_set2  # or: frozen_set1.symmetric_difference(frozen_set2)
print("Symmetric difference:", symmetric_diff)  # frozenset({1, 2, 5, 6})

# Subset, superset, and disjoint
subset_example = frozenset([1, 2])
print("\nSubset, superset, disjoint:")
print("Is subset_example a subset of frozen_set1?", subset_example <= frozen_set1)  # True
print("Is frozen_set1 a superset of subset_example?", frozen_set1 >= subset_example)  # True
print("Are frozen_set1 and subset_example disjoint?", frozen_set1.isdisjoint(subset_example))  # False
print("Are frozen_set1 and frozenset([7, 8]) disjoint?", frozen_set1.isdisjoint(frozenset([7, 8])))  # True

# Immutability - frozen sets cannot be modified
print("\nImmutability:")
try:
    frozen_set1.add(5)  # This will raise an AttributeError
except AttributeError as e:
    print("Error when trying to add element:", e)

try:
    frozen_set1.remove(1)  # This will raise an AttributeError
except AttributeError as e:
    print("Error when trying to remove element:", e)

# Using frozen sets as dictionary keys
print("\nUsing frozen sets as dictionary keys:")
mapping = {
    frozenset([1, 2]): "Set with 1 and 2",
    frozenset([3, 4]): "Set with 3 and 4"
}
print("Dictionary with frozen set keys:", mapping)
print("Value for frozenset([1, 2]):", mapping[frozenset([1, 2])])  # "Set with 1 and 2"

# Comparing with regular sets
print("\nComparing with regular sets:")
regular_set = {1, 2, 3}
print("Equality check:", frozenset([1, 2, 3]) == regular_set)  # True

# Converting between frozen sets and other collections
print("\nConverting between types:")
back_to_list = list(frozen_from_list)
back_to_set = set(frozen_from_list)
print("Frozen set to list:", back_to_list)  # [1, 2, 3, 4, 5] (order may vary)
print("Frozen set to set:", back_to_set)  # {1, 2, 3, 4, 5}

# Performance comparison for hashable operations
import sys
print("\nMemory usage:")
regular_set = {1, 2, 3, 4, 5}
frozen_set = frozenset([1, 2, 3, 4, 5])
print(f"Regular set size: {sys.getsizeof(regular_set)} bytes")
print(f"Frozen set size: {sys.getsizeof(frozen_set)} bytes")

# Use cases for frozen sets
print("\nUse cases:")

# 1. As elements in other sets
set_of_frozen_sets = {frozenset([1, 2]), frozenset([3, 4])}
print("Set of frozen sets:", set_of_frozen_sets)  # {frozenset({1, 2}), frozenset({3, 4})}

# 2. In functions that require hashable collections
def process_unique_items(hashable_collection):
    # Demonstrate using a frozen set in a function
    return f"Processed {len(hashable_collection)} unique items"

result = process_unique_items(frozen_set1)
print("Function result:", result)  # "Processed 4 unique items"

# 3. Caching results of set operations
cached_results = {}
def get_common_elements(set1, set2):
    # Converting to frozenset to use as a dictionary key
    key = (frozenset(set1), frozenset(set2))
    if key not in cached_results:
        print("Calculating intersection...")
        cached_results[key] = frozenset(set1) & frozenset(set2)
    return cached_results[key]

# First call calculates the result
print("\nCaching example:")
result1 = get_common_elements([1, 2, 3], [2, 3, 4])
print("First call result:", result1)  # frozenset({2, 3})

# Second call uses cached result
result2 = get_common_elements([1, 2, 3], [2, 3, 4])
print("Second call result:", result2)  # frozenset({2, 3}) (no "Calculating" message)