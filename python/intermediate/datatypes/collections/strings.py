# Creating strings
simple_string = 'Hello, World!'
double_quoted = "Python Strings"
multiline_string = '''This is a
multiline string in
Python'''

# Printing strings
print(simple_string)  # Hello, World!
print(double_quoted)  # Python Strings
print(multiline_string)
# This is a
# multiline string in
# Python

# String length
print(len(simple_string))  # 13

# Accessing characters (strings are sequences)
print(simple_string[0])   # H (first character)
print(simple_string[-1])  # ! (last character)

# Slicing strings
print(simple_string[0:5])   # Hello
print(simple_string[7:])    # World!
print(simple_string[:5])    # Hello
print(simple_string[-6:])   # World!
print(simple_string[::2])   # Hlo ol! (step by 2)

# String concatenation
first_name = "John"
last_name = "Doe"
full_name = first_name + " " + last_name
print(full_name)  # John Doe

# String repetition
print("=" * 20)  # ====================

# String methods
text = "  Python is Amazing  "
print(text.upper())          # PYTHON IS AMAZING
print(text.lower())          # python is amazing
print(text.strip())          # Python is Amazing
print(text.replace("Amazing", "Awesome"))  # Python is Awesome
print(text.split())          # ['Python', 'is', 'Amazing']
print(",".join(["A", "B", "C"]))  # A,B,C

# Checking substrings
print("Python" in text)      # True
print(text.startswith(" "))  # True
print(text.endswith("ing"))  # False

# Finding substrings
print(text.find("is"))       # 9
print(text.find("not"))      # -1 (not found)

# String formatting - multiple approaches
name = "Alice"
age = 30

# Using % operator (old style)
print("My name is %s and I am %d years old." % (name, age))
# My name is Alice and I am 30 years old.

# Using format() method
print("My name is {} and I am {} years old.".format(name, age))
# My name is Alice and I am 30 years old.

# Using f-strings (Python 3.6+, recommended)
print(f"My name is {name} and I am {age} years old.")
# My name is Alice and I am 30 years old.

# String operations on multiline strings
poem = """
Roses are red,
Violets are blue,
Python is fun,
And so are you!
"""
print(poem.count("\n"))  # 5
print(poem.strip())      # Removes leading/trailing whitespace

# Escape sequences
escaped_string = "This is a \"quoted\" text with a \\ backslash and a \n new line."
print(escaped_string)
# This is a "quoted" text with a \ backslash and a 
# new line.

# Raw strings - ignores escape sequences
raw_string = r"C:\Users\Username\Documents"
print(raw_string)  # C:\Users\Username\Documents

# String methods for validation
numeric_string = "12345"
alpha_string = "Hello"
print(numeric_string.isdigit())  # True
print(alpha_string.isalpha())    # True
print("Hello123".isalnum())      # True
print("   ".isspace())           # True

# Useful string transformations
print("hello world".title())     # Hello World
print("hello world".capitalize())  # Hello world
print("Hello World".swapcase())  # hELLO wORLD

# String alignment
text = "Python"
print(text.ljust(10, '-'))    # Python----
print(text.rjust(10, '-'))    # ----Python
print(text.center(10, '-'))   # --Python--

# String encoding and decoding
encoded = "Pythön".encode("utf-8")
print(encoded)  # b'Pyth\xc3\xb6n'
print(encoded.decode("utf-8"))  # Pythön