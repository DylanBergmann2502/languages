# Basic None value
none_value = None
print(f"Basic None value: {none_value}")  # None

# Type of None
print(f"\nType of None: {type(None)}")  # <class 'NoneType'>

# None is a singleton - there is only one None object
print("\nNone is a singleton:")
a = None
b = None
print(f"a is b: {a is b}")  # True
print(f"a == b: {a == b}")  # True

# Identity vs equality
print("\nIdentity vs equality:")
print(f"None == 0: {None == 0}")        # False
print(f"None == '': {None == ''}")       # False
print(f"None == False: {None == False}") # False

# Truth value of None
print("\nTruth value of None:")
print(f"bool(None): {bool(None)}")  # False

if None:
    print("This won't print")
else:
    print("None evaluates to False in a boolean context")

# Common uses of None - default return value
print("\nNone as default return value:")

def function_without_return():
    pass  # Do something but don't return anything

result = function_without_return()
print(f"Function without return value returns: {result}")  # None

# None as default parameter
print("\nNone as default parameter:")

def greet(name=None):
    if name is None:
        return "Hello, Guest!"
    return f"Hello, {name}!"

print(f"greet(): {greet()}")         # Hello, Guest!
print(f"greet('Alice'): {greet('Alice')}")  # Hello, Alice!

# None vs empty collections/values
print("\nNone vs empty values:")
empty_string = ""
empty_list = []
empty_dict = {}
zero = 0

print(f"None is None: {None is None}")                  # True
print(f"empty_string is None: {empty_string is None}")  # False
print(f"empty_list is None: {empty_list is None}")      # False
print(f"empty_dict is None: {empty_dict is None}")      # False
print(f"zero is None: {zero is None}")                  # False

# Best practice - use 'is' not '==' when comparing with None
print("\nUsing 'is' with None:")
print(f"None is None: {None is None}")  # True (recommended)
print(f"None == None: {None == None}")  # True (works but not preferred)

# None in mutable default arguments (a common pitfall)
print("\nNone in mutable default arguments:")

def bad_append(item, lst=[]):  # PROBLEMATIC: mutable default argument
    lst.append(item)
    return lst

def good_append(item, lst=None):  # CORRECT: using None as sentinel
    if lst is None:
        lst = []
    lst.append(item)
    return lst

print(f"First call to bad_append(1): {bad_append(1)}")      # [1]
print(f"Second call to bad_append(2): {bad_append(2)}")     # [1, 2] - unexpected!

print(f"First call to good_append(1): {good_append(1)}")    # [1]
print(f"Second call to good_append(2): {good_append(2)}")   # [2] - as expected

# Explicit vs implicit None
print("\nExplicit vs implicit None:")

def explicit_none():
    return None

def implicit_none():
    return

print(f"explicit_none(): {explicit_none()}")  # None
print(f"implicit_none(): {implicit_none()}")  # None

# None in conditions and logical operations
print("\nNone in conditions and logical operations:")
x = None
y = "value"

print(f"x or 'default': {x or 'default'}")  # 'default'
print(f"y or 'default': {y or 'default'}")  # 'value'

# None in list filtering
print("\nNone in list filtering:")
values = [1, None, 3, None, 5]
filtered = [x for x in values if x is not None]
print(f"Original list: {values}")
print(f"Filtered list: {filtered}")  # [1, 3, 5]

# Common methods that return None
print("\nMethods that return None:")
my_list = [1, 2, 3]
result = my_list.append(4)  # append modifies list in-place and returns None
print(f"my_list.append(4) returns: {result}")  # None
print(f"Modified list: {my_list}")  # [1, 2, 3, 4]

# None in assert statements
print("\nNone in assertions:")
try:
    assert None, "None is falsy so this will raise an AssertionError"
except AssertionError as e:
    print(f"AssertionError occurred: {e}")