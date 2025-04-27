# Creating dictionaries
empty_dict = {}
person = {"name": "John", "age": 30, "city": "New York"}
using_dict_function = dict(name="Alice", age=25, city="Boston")
from_tuples = dict([("name", "Bob"), ("age", 35), ("city", "Chicago")])

# Printing dictionaries
print(empty_dict)  # {}
print(person)  # {'name': 'John', 'age': 30, 'city': 'New York'}
print(using_dict_function)  # {'name': 'Alice', 'age': 25, 'city': 'Boston'}
print(from_tuples)  # {'name': 'Bob', 'age': 35, 'city': 'Chicago'}

# Accessing values
print(person["name"])  # John
print(person.get("age"))  # 30
print(person.get("phone", "Not found"))  # Not found (default value if key doesn't exist)

# Adding or modifying elements
person["email"] = "john@example.com"
person["age"] = 31
print(person)  # {'name': 'John', 'age': 31, 'city': 'New York', 'email': 'john@example.com'}

# Removing elements
removed_age = person.pop("age")
print(f"Removed age: {removed_age}")  # Removed age: 31
print(person)  # {'name': 'John', 'city': 'New York', 'email': 'john@example.com'}

# Remove and return last inserted item (Python 3.7+ maintains insertion order)
last_item = person.popitem()
print(f"Last item: {last_item}")  # Last item: ('email', 'john@example.com')
print(person)  # {'name': 'John', 'city': 'New York'}

# Delete a key
person["age"] = 30
del person["age"]
print(person)  # {'name': 'John', 'city': 'New York'}

# Clear dictionary
person_copy = person.copy()
person_copy.clear()
print(person_copy)  # {}

# Dictionary methods
keys = person.keys()
values = person.values()
items = person.items()

print(keys)    # dict_keys(['name', 'city'])
print(values)  # dict_values(['John', 'New York'])
print(items)   # dict_items([('name', 'John'), ('city', 'New York')])

# Converting views to lists
print(list(keys))    # ['name', 'city']
print(list(values))  # ['John', 'New York']
print(list(items))   # [('name', 'John'), ('city', 'New York')]

# Checking if a key exists
print("name" in person)  # True
print("age" in person)   # False

# Dictionary comprehensions
squares = {x: x*x for x in range(6)}
print(squares)  # {0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

# Filtering with comprehensions
even_squares = {x: x*x for x in range(10) if x % 2 == 0}
print(even_squares)  # {0: 0, 2: 4, 4: 16, 6: 36, 8: 64}

# Merging dictionaries
dict1 = {"a": 1, "b": 2}
dict2 = {"b": 3, "c": 4}

# Python 3.9+ way
if hasattr(dict1, "merge"):  # Check if Python 3.9+
    merged = dict1 | dict2
    print(merged)  # {'a': 1, 'b': 3, 'c': 4}
else:
    # Pre-Python 3.9 way
    merged = {**dict1, **dict2}
    print(merged)  # {'a': 1, 'b': 3, 'c': 4}

# Update method (modifies dict1)
dict1 = {"a": 1, "b": 2}
dict1.update(dict2)
print(dict1)  # {'a': 1, 'b': 3, 'c': 4}

# Nested dictionaries
employee = {
    "name": "John",
    "age": 30,
    "address": {
        "street": "123 Main St",
        "city": "New York",
        "zipcode": "10001"
    },
    "skills": ["Python", "JavaScript", "SQL"]
}

print(employee["address"]["city"])  # New York
print(employee["skills"][0])        # Python

# Using setdefault - get value if exists, set and return if doesn't
contacts = {"John": "123-456-7890"}
print(contacts.setdefault("John", "unknown"))     # 123-456-7890
print(contacts.setdefault("Alice", "555-1234"))   # 555-1234
print(contacts)  # {'John': '123-456-7890', 'Alice': '555-1234'}

# defaultdict from collections module
from collections import defaultdict

# Creates a dict with default values (0 in this case)
word_counts = defaultdict(int)
for word in ["apple", "banana", "apple", "orange", "banana", "apple"]:
    word_counts[word] += 1

print(dict(word_counts))  # {'apple': 3, 'banana': 2, 'orange': 1}

# List as default value
groups = defaultdict(list)
people = [
    ("Sales", "John"), ("Engineering", "Alice"), 
    ("Sales", "Bob"), ("Marketing", "Emma")
]

for dept, person in people:
    groups[dept].append(person)

print(dict(groups))
# {'Sales': ['John', 'Bob'], 'Engineering': ['Alice'], 'Marketing': ['Emma']}

# OrderedDict - explicitly ordered dictionary (mostly obsolete in Python 3.7+)
from collections import OrderedDict
ordered = OrderedDict([('a', 1), ('b', 2), ('c', 3)])
print(ordered)  # OrderedDict([('a', 1), ('b', 2), ('c', 3)])

# Counter - specialized dict for counting
from collections import Counter
fruits = ["apple", "banana", "apple", "orange", "banana", "apple"]
fruit_count = Counter(fruits)
print(fruit_count)  # Counter({'apple': 3, 'banana': 2, 'orange': 1})
print(fruit_count.most_common(2))  # [('apple', 3), ('banana', 2)]

# Dictionary iteration
student_scores = {"Alice": 85, "Bob": 92, "Charlie": 78}

# Iterate through keys (default)
for name in student_scores:
    print(f"{name}: {student_scores[name]}")
# Alice: 85
# Bob: 92
# Charlie: 78

# Iterate through items
for name, score in student_scores.items():
    print(f"{name} scored {score}")
# Alice scored 85
# Bob scored 92
# Charlie scored 78

# Dictionary unpacking
def print_user_info(name, age, city):
    print(f"{name} is {age} years old and lives in {city}")

user = {"name": "David", "age": 28, "city": "San Francisco"}
print_user_info(**user)  # David is 28 years old and lives in San Francisco