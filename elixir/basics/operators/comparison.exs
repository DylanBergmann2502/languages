# Elixir also provides ==, !=, <=, >=, < and > as comparison operators.
IO.puts(1 == 1) # true
IO.puts(1 != 2) # true
IO.puts(1 < 2) # true

IO.puts("foo" == "foo") # true
IO.puts("foo" == "bar") # false

# Integers and Floats are loosely compared
IO.puts(1 == 1.0) # true
IO.puts(1 == 2.0) # false

# the strict comparison operator === and !==
# if you want to distinguish between integers and floats
# (that's the only difference between these operators)

IO.puts(1 === 1.0) # false

# An important feature of Elixir is that any two types can be compared;
# this is particularly useful in sorting.
# number < atom < reference < function < port < pid < tuple < map < list < bitstring
IO.puts(:hello > 999) # true
IO.puts({:hello, :world} > [1, 2, 3]) # false
