# Basic float operations
# Floats in Elixir are 64-bit double precision numbers
pi = 3.14159
e = 2.71828
IO.puts("Pi: #{pi}, e: #{e}")

# Converting fractions to Float.ratio format
# For simple fractions, we can get the exact ratio back
IO.inspect Float.ratio(0.75) # => {3, 4}

# But for non-terminating decimals, we get an approximation
IO.inspect Float.ratio(0.6)  # => {5404319552844595, 9007199254740992}

# Integer and float arithmetic
# When performing operations with integers and floats,
# the result is always a float if one of the operands is a float
IO.puts(2 * 3)   # => 6   (integer)
IO.puts(2 * 3.0) # => 6.0 (float)
IO.puts(6 / 3)   # => 2.0 (division always gives float)

# Float module functions
IO.puts Float.round(3.56, 1)  # => 3.6 (round to 1 decimal place)
IO.puts Float.ceil(3.1)       # => 4.0 (ceiling)
IO.puts Float.floor(3.9)      # => 3.0 (floor)
IO.puts Float.pow(2.0, 10)    # => 1024.0 (exponentiation)

# Converting floats to other formats
IO.puts Float.to_charlist(7.0) # '7.0' (charlist)
IO.puts Float.to_string(7.0)   # "7.0" (string)

# Parsing strings as floats
{value, _} = Float.parse("123.45")
IO.puts(value) # 123.45

# Float precision and representation issues
# Be aware of floating point precision limitations
IO.puts(0.1 + 0.2)  # => 0.30000000000000004 (not exactly 0.3)
IO.puts(0.1 + 0.2 == 0.3)  # => false

# Comparing floats with tolerance
tolerance = 1.0e-15
IO.puts abs((0.1 + 0.2) - 0.3) < tolerance  # => true

# Scientific notation
sci_notation = 1.0e10  # 10 billion
IO.puts sci_notation  # => 10000000000.0

# Float rounding behavior
IO.puts Float.round(5.5)  # => 6.0 (rounds to nearest even)
IO.puts Float.round(4.5)  # => 4.0 (rounds to nearest even)

# Float infinity and NaN
IO.puts(1.0 / 0.0)  # => :infinity
IO.puts(-1.0 / 0.0)  # => -:infinity
IO.puts(0.0 / 0.0)  # => :nan (not a number)
