# Basic float creation
a = 3.14
b = -0.5
scientific = 1.23e-4  # Scientific notation for 0.000123
print(f"Basic floats: {a}, {b}, {scientific}")  # 3.14, -0.5, 0.000123

# Float precision and representation
print("\nFloat precision:")
print(f"Float representation of 0.1: {0.1}")  # 0.1
print(f"Actual stored value: {format(0.1, '.20f')}")  # 0.10000000000000000555

# Precision issues with floating point math
print("\nPrecision issues:")
result = 0.1 + 0.2
print(f"0.1 + 0.2 = {result}")  # 0.30000000000000004
print(f"0.1 + 0.2 == 0.3: {result == 0.3}")  # False

# Handling precision issues
from decimal import Decimal
print("\nUsing Decimal for precision:")
d1 = Decimal('0.1')
d2 = Decimal('0.2')
print(f"Decimal('0.1') + Decimal('0.2') = {d1 + d2}")  # 0.3
print(f"Is equal to Decimal('0.3')? {d1 + d2 == Decimal('0.3')}")  # True

# Float operations
print("\nFloat operations:")
x = 10.5
y = 2.5
print(f"Addition: {x + y}")       # 13.0
print(f"Subtraction: {x - y}")    # 8.0
print(f"Multiplication: {x * y}") # 26.25
print(f"Division: {x / y}")       # 4.2
print(f"Floor division: {x // y}")  # 4.0 (notice this is still a float)
print(f"Modulus: {x % y}")        # 0.5
print(f"Power: {x ** 2}")         # 110.25

# Rounding floats
print("\nRounding:")
value = 3.14159
print(f"round(3.14159, 2): {round(value, 2)}")  # 3.14
print(f"round(3.5): {round(3.5)}")  # 4
print(f"round(4.5): {round(4.5)}")  # 4 (banker's rounding to nearest even)

# Math library functions
import math
print("\nMath functions:")
print(f"math.floor(3.7): {math.floor(3.7)}")  # 3
print(f"math.ceil(3.2): {math.ceil(3.2)}")    # 4
print(f"math.trunc(3.7): {math.trunc(3.7)}")  # 3 (truncates toward zero)
print(f"math.sin(math.pi/2): {math.sin(math.pi/2)}")  # 1.0
print(f"math.log(100, 10): {math.log(100, 10)}")  # 2.0
print(f"math.sqrt(16): {math.sqrt(16)}")  # 4.0
print(f"math.pow(2, 3): {math.pow(2, 3)}")  # 8.0

# Constants in math module
print("\nMath constants:")
print(f"pi: {math.pi}")  # 3.141592653589793
print(f"e: {math.e}")    # 2.718281828459045
print(f"tau: {math.tau}")  # 6.283185307179586 (2π)
print(f"infinity: {math.inf}")  # inf
print(f"nan: {math.nan}")  # nan

# Special float values
print("\nSpecial float values:")
print(f"Positive infinity: {float('inf')}")
print(f"Negative infinity: {float('-inf')}")
print(f"Not a Number: {float('nan')}")

# Testing for special values
x = float('inf')
y = float('nan')
print(f"\nIs inf infinite? {math.isinf(x)}")  # True
print(f"Is nan a number? {math.isnan(y)}")   # True
print(f"Is inf equal to inf? {x == float('inf')}")  # True
print(f"Is nan equal to nan? {y == float('nan')}")  # False (NaN is never equal to anything)

# Converting to and from floats
print("\nConversions:")
print(f"int to float: {float(42)}")  # 42.0
print(f"string to float: {float('3.14')}")  # 3.14
print(f"float to int: {int(3.99)}")  # 3 (truncates, doesn't round)
print(f"float to string: {str(3.14)}")  # '3.14'

# Float formatting
value = 123.456789
print("\nFloat formatting:")
print(f"Default: {value}")  # 123.456789
print(f"Two decimal places: {value:.2f}")  # 123.46
print(f"With padding: {value:10.2f}")  # '    123.46' (width 10, 2 decimal places)
print(f"Scientific notation: {value:.2e}")  # 1.23e+02
print(f"Percentage: {value:.2%}")  # 12345.68%

# Handling precision in calculations
from decimal import Decimal, getcontext
print("\nDecimal precision control:")
getcontext().prec = 6  # Set precision to 6 digits
d1 = Decimal('1') / Decimal('7')
print(f"1/7 with precision 6: {d1}")  # 0.142857

getcontext().prec = 28  # Set precision to 28 digits
d2 = Decimal('1') / Decimal('7')
print(f"1/7 with precision 28: {d2}")  # 0.1428571428571428571428571429

# Comparing floats safely
print("\nComparing floats safely:")
a = 0.1 + 0.2
b = 0.3
print(f"Simple comparison: {a == b}")  # False

# Method 1: Using round
print(f"Using round: {round(a, 10) == round(b, 10)}")  # True

# Method 2: Using math.isclose (Python 3.5+)
print(f"Using math.isclose: {math.isclose(a, b)}")  # True

# Method 3: Using absolute difference
tolerance = 1e-9
print(f"Using abs diff: {abs(a - b) < tolerance}")  # True