# Basic integer representation
# Integers in Elixir can be written in decimal, hex, octal or binary
a = 1_000_000       # => 1000000 (underscores can be used for readability)
hex_value = 0xCAFE  # => 51966 (hexadecimal)
octal_value = 0o777 # => 511 (octal)
binary_value = 0b10101 # => 21 (binary)
IO.puts("Decimal: #{a}, Hex: #{hex_value}, Octal: #{octal_value}, Binary: #{binary_value}")

# Integer predicates - checking properties
IO.puts Integer.is_even(10) # true
IO.puts Integer.is_odd(5)   # true

# Converting integers to a list of digits
IO.inspect Integer.digits(123)     # => [1, 2, 3]
IO.inspect Integer.digits(123, 2)  # => [1, 1, 1, 1, 0, 1, 1] (binary representation)
IO.inspect Integer.digits(123, 16) # => [7, 11] (hex representation)

# Converting a list of digits back to an integer
IO.puts Integer.undigits([1, 2, 3])     # => 123
IO.puts Integer.undigits([7, 11], 16)   # => 123 (from hex)

# Math operations
IO.puts Integer.floor_div(5, 2) # 2 (integer division with floor)
IO.puts Integer.div(5, 2)       # 2 (integer division)
IO.puts Integer.mod(5, 2)       # 1 (remainder)
IO.puts Integer.pow(2, 10)      # 1024 (exponentiation)
IO.puts Integer.gcd(12, 8)      # 4 (greatest common divisor)

# Converting integers to other formats
IO.puts Integer.to_charlist(123)  # '123' (list of character codes)
IO.puts Integer.to_string(123)    # "123" (string)
IO.puts Integer.to_string(+456)   # "456" (positive sign ignored)
IO.puts Integer.to_string(-789)   # "-789" (negative sign preserved)
IO.puts Integer.to_string(0123)   # "123" (leading zeros ignored)

# Parse strings as integers
IO.puts Integer.parse("123")      # {123, ""} (returns tuple with parsed integer and remainder)
{value, _} = Integer.parse("123") # pattern match to get just the integer
IO.puts value                     # 123

# Parse integers from different bases
IO.puts elem(Integer.parse("FF", 16), 0)  # 255 (parsing hex)
IO.puts elem(Integer.parse("777", 8), 0)  # 511 (parsing octal)
IO.puts elem(Integer.parse("101101", 2), 0) # 45 (parsing binary)

# Handling potential errors with parse functions
case Integer.parse("not_a_number") do
  {value, _} -> IO.puts("Parsed: #{value}")
  :error -> IO.puts("Could not parse as integer")
end # "Could not parse as integer"

# Safe parsing with String.to_integer/1
try do
  value = String.to_integer("123")
  IO.puts("Parsed: #{value}")  # "Parsed: 123"
rescue
  ArgumentError -> IO.puts("Invalid integer format")
end
