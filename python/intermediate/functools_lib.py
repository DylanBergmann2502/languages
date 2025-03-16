import functools
import time
from datetime import datetime


# Example 1: @functools.lru_cache - Memoization decorator to cache function results
@functools.lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)


print("Fibonacci example:")
print(fibonacci(30))  # 832040
# Without caching, this would be extremely slow
print(fibonacci.cache_info())  # CacheInfo(hits=28, misses=31, maxsize=128, currsize=31)


# Example 2: functools.partial - Create new function with partial application of arguments
def multiply(x, y):
    return x * y


# Create a new function that multiplies by 2
double = functools.partial(multiply, 2)
print("\nPartial example:")
print(double(5))  # 10

# Example 3: functools.reduce - Apply function cumulatively to items of an iterable
numbers = [1, 2, 3, 4, 5]
product = functools.reduce(lambda x, y: x * y, numbers)
print("\nReduce example:")
print(product)  # 120 (1*2*3*4*5)


# Example 4: @functools.wraps - Preserve metadata when writing decorators
def my_decorator(func):
    @functools.wraps(func)  # This preserves func's metadata
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__} at {datetime.now()}")
        return func(*args, **kwargs)

    return wrapper


@my_decorator
def greet(name):
    """Greet someone by name"""
    return f"Hello, {name}!"


print("\nWraps example:")
print(greet("World"))  # Hello, World!
print(greet.__name__)  # greet (without @wraps, this would be "wrapper")
print(greet.__doc__)  # Greet someone by name


# Example 5: @functools.total_ordering - Fill in comparison methods automatically
@functools.total_ordering
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def __eq__(self, other):
        return self.age == other.age

    def __lt__(self, other):
        return self.age < other.age


print("\nTotal ordering example:")
p1 = Person("Alice", 30)
p2 = Person("Bob", 25)
print(p1 > p2)  # True
print(p1 >= p2)  # True
print(p1 <= p2)  # False


# Example 6: functools.singledispatch - Single dispatch generic functions
@functools.singledispatch
def process(obj):
    print(f"Default handler: {obj}")


@process.register
def _(obj: list):
    print(f"Processing list with {len(obj)} items")


@process.register
def _(obj: str):
    print(f"Processing string: {obj}")


@process.register(int)  # Alternative syntax
def _(obj):
    print(f"Processing integer: {obj}")


print("\nSingledispatch example:")
process(10)  # Processing integer: 10
process("hello")  # Processing string: hello
process([1, 2, 3])  # Processing list with 3 items
process({"a": 1})  # Default handler: {'a': 1}


# Example 7: @functools.cache - Simple unbounded cache (Python 3.9+)
# If you're on Python 3.8 or earlier, comment this out
@functools.cache
def expensive_function(n):
    time.sleep(0.1)  # Simulate expensive computation
    return n * 2


print("\nCache example:")
start = time.time()
for i in range(5):
    expensive_function(1)  # Only the first call takes time
end = time.time()
print(f"Time taken: {end - start:.2f} seconds")  # Around 0.1s, not 0.5s


# Example 8: functools.cmp_to_key - Convert old-style comparison function to key function
def compare_length(a, b):
    return len(a) - len(b)


words = ["python", "is", "awesome", "and", "functional"]
sorted_words = sorted(words, key=functools.cmp_to_key(compare_length))
print("\nCmp_to_key example:")
print(sorted_words)  # ['is', 'and', 'python', 'awesome', 'functional']
