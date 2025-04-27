# Basic integer creation and operations
num1 = 42
num2 = -17
large_num = 1_000_000  # Underscores for readability
print(f"Basic integers: {num1}, {num2}, {large_num}")  # 42, -17, 1000000

# Integer operations
print("\nBasic operations:")
print(f"Addition: {num1 + num2}")        # 25
print(f"Subtraction: {num1 - num2}")     # 59
print(f"Multiplication: {num1 * num2}")  # -714
print(f"Division: {num1 / num2}")        # -2.4705882352941178 (returns float)
print(f"Integer division: {num1 // num2}")  # -3 (floors toward negative infinity)
print(f"Modulo: {num1 % num2}")          # 8 (remainder after division)
print(f"Exponentiation: {num1 ** 2}")    # 1764 (42 squared)

# Binary, octal, and hexadecimal
print("\nInteger representations:")
bin_num = 0b1010      # Binary (base 2)
oct_num = 0o52        # Octal (base 8)
hex_num = 0x2A        # Hexadecimal (base 16)
print(f"Binary 0b1010 = {bin_num}")        # 10
print(f"Octal 0o52 = {oct_num}")           # 42
print(f"Hexadecimal 0x2A = {hex_num}")     # 42

# Converting integers to different bases
num = 42
print("\nConverting 42 to different bases:")
print(f"Binary: {bin(num)}")       # 0b101010
print(f"Octal: {oct(num)}")        # 0o52
print(f"Hexadecimal: {hex(num)}")  # 0x2a

# Integer methods and functions
print("\nInteger methods and functions:")
print(f"Absolute value of -17: {abs(num2)}")  # 17
print(f"Power: {pow(num1, 2)}")               # 1764
print(f"Power with modulo: {pow(num1, 2, 5)}")  # 4 (equivalent to (42² % 5))

# Bitwise operations
a = 60  # 0011 1100 in binary
b = 13  # 0000 1101 in binary
print("\nBitwise operations:")
print(f"a = {a} ({bin(a)}), b = {b} ({bin(b)})")
print(f"AND: a & b = {a & b} ({bin(a & b)})")        # 12 (0000 1100)
print(f"OR: a | b = {a | b} ({bin(a | b)})")         # 61 (0011 1101)
print(f"XOR: a ^ b = {a ^ b} ({bin(a ^ b)})")        # 49 (0011 0001)
print(f"NOT: ~a = {~a} ({bin(~a)})")                 # -61
print(f"Left shift: a << 2 = {a << 2} ({bin(a << 2)})")  # 240 (1111 0000)
print(f"Right shift: a >> 2 = {a >> 2} ({bin(a >> 2)})")  # 15 (0000 1111)

# Integer limits in Python
print("\nInteger limits:")
print(f"Python integers have no fixed limit. Example large number: {2**100}")
# 1267650600228229401496703205376

# Bool type is a subclass of int
print("\nBooleans as integers:")
print(f"True + True = {True + True}")  # 2
print(f"False + False = {False + False}")  # 0
print(f"True * 10 = {True * 10}")  # 10

# Useful built-in functions for integers
numbers = [1, 5, 3, 9, 2]
print("\nBuilt-in functions with integers:")
print(f"Sum: {sum(numbers)}")               # 20
print(f"Minimum: {min(numbers)}")           # 1
print(f"Maximum: {max(numbers)}")           # 9
print(f"Sorted: {sorted(numbers)}")         # [1, 2, 3, 5, 9]

# Checking types
print("\nType checking:")
print(f"Type of 42: {type(num1)}")  # <class 'int'>
print(f"Is 42 an instance of int? {isinstance(num1, int)}")  # True

# Converting other types to integers
print("\nType conversion:")
print(f"Float to int: {int(3.14)}")     # 3 (truncates, doesn't round)
print(f"String to int: {int('123')}")   # 123
print(f"Bool to int: {int(True)}")      # 1
print(f"Hex string to int: {int('2A', 16)}")  # 42 (base 16)
print(f"Binary string to int: {int('101010', 2)}")  # 42 (base 2)

# Number systems with int()
print("\nConverting from different number systems:")
print(f"Binary '101010' to int: {int('101010', 2)}")    # 42
print(f"Octal '52' to int: {int('52', 8)}")             # 42
print(f"Decimal '42' to int: {int('42', 10)}")          # 42
print(f"Hex '2A' to int: {int('2A', 16)}")              # 42