# Basic boolean values
true_value = True
false_value = False
print(f"Basic boolean values: {true_value}, {false_value}")  # True, False

# Boolean as subclass of int
print("\nBooleans as integers:")
print(f"True as integer: {int(True)}")  # 1
print(f"False as integer: {int(False)}")  # 0
print(f"True + True = {True + True}")  # 2
print(f"True * 8 = {True * 8}")  # 8
print(f"False * 100 = {False * 100}")  # 0

# Comparison operators that return booleans
print("\nComparison operators:")
x, y = 5, 10
print(f"x = {x}, y = {y}")
print(f"x == y: {x == y}")  # False
print(f"x != y: {x != y}")  # True
print(f"x < y: {x < y}")  # True
print(f"x > y: {x > y}")  # False
print(f"x <= y: {x <= y}")  # True
print(f"x >= y: {x >= y}")  # False

# Logical operators
print("\nLogical operators:")
a, b = True, False
print(f"a = {a}, b = {b}")
print(f"a and b: {a and b}")  # False
print(f"a or b: {a or b}")  # True
print(f"not a: {not a}")  # False
print(f"not b: {not b}")  # True

# Short-circuit evaluation
print("\nShort-circuit evaluation:")
def true_func():
    print("true_func called")
    return True

def false_func():
    print("false_func called")
    return False

print("False and true_func():")
result = False and true_func()  # true_func not called
print(f"Result: {result}")  # False

print("\nTrue or false_func():")
result = True or false_func()  # false_func not called
print(f"Result: {result}")  # True

# Truth value testing
print("\nTruth value testing:")
print(f"bool(0): {bool(0)}")  # False
print(f"bool(1): {bool(1)}")  # True
print(f"bool(-5): {bool(-5)}")  # True
print(f"bool(''): {bool('')}")  # False
print(f"bool('hello'): {bool('hello')}")  # True
print(f"bool([]): {bool([])}")  # False
print(f"bool([1, 2]): {bool([1, 2])}")  # True
print(f"bool(None): {bool(None)}")  # False

# Objects that define __bool__ or __len__
print("\nCustom truth testing:")
class AlwaysTrue:
    def __bool__(self):
        return True

class AlwaysFalse:
    def __bool__(self):
        return False

class EmptyList:
    def __len__(self):
        return 0  # Empty, so evaluates to False

print(f"bool(AlwaysTrue()): {bool(AlwaysTrue())}")  # True
print(f"bool(AlwaysFalse()): {bool(AlwaysFalse())}")  # False
print(f"bool(EmptyList()): {bool(EmptyList())}")  # False

# Boolean operations in if statements
print("\nBoolean operations in if statements:")
x = 10
if x > 5 and x < 15:
    print(f"x = {x} is between 5 and 15")

name = "Alice"
if name == "Alice" or name == "Bob":
    print(f"Hello, {name}!")

# Boolean operations with collections
print("\nBoolean operations with collections:")
my_list = [1, 2, 3]
print(f"5 in my_list: {5 in my_list}")  # False
print(f"2 in my_list: {2 in my_list}")  # True
print(f"4 not in my_list: {4 not in my_list}")  # True

# Using any() and all()
print("\nUsing any() and all():")
numbers = [2, 4, 6, 8, 9]
print(f"numbers: {numbers}")
print(f"any(n > 5 for n in numbers): {any(n > 5 for n in numbers)}")  # True
print(f"all(n > 5 for n in numbers): {all(n > 5 for n in numbers)}")  # False
print(f"all(n < 10 for n in numbers): {all(n < 10 for n in numbers)}")  # True

# Conditional expressions (ternary operator)
print("\nConditional expressions:")
age = 20
status = "adult" if age >= 18 else "minor"
print(f"Age {age} is {status}")  # adult

# Common boolean patterns
print("\nCommon boolean patterns:")

# Pattern 1: Default values
value = None
result = value or "default"
print(f"value or default: {result}")  # default

# Pattern 2: Early returns
def process_positive(num):
    if not (isinstance(num, (int, float)) and num > 0):
        return "Invalid input"
    return f"Processing {num}"

print(f"process_positive(5): {process_positive(5)}")  # Processing 5
print(f"process_positive(-3): {process_positive(-3)}")  # Invalid input
print(f"process_positive('hello'): {process_positive('hello')}")  # Invalid input

# Pattern 3: Boolean masking with lists
values = [1, 0, 3, 0, 5]
mask = [bool(x) for x in values]
print(f"values: {values}")
print(f"mask: {mask}")  # [True, False, True, False, True]

# Bitwise operations on booleans
print("\nBitwise operations:")
print(f"True & False: {True & False}")  # False (AND)
print(f"True | False: {True | False}")  # True (OR)
print(f"True ^ False: {True ^ False}")  # True (XOR)
print(f"True ^ True: {True ^ True}")  # False (XOR)