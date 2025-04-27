# Basic boolean checks
a = is_boolean(true) # true
IO.puts("is_boolean(true): #{a}")

###################################################################
# Elixir also provides three boolean operators: or/2, and/2, and not/1.
# These operators are strict in the sense that they expect
# something that evaluates to a boolean (true or false) as their first argument:
IO.puts(true and true) # true

IO.puts(false or is_boolean(true)) # true

# IO.puts(1 and true) # ** (BadBooleanError) expected a boolean on left-side of "and", got: 1

###################################################################
# or and and are short-circuit operators.
IO.puts(false and raise("This error will never be raised")) # false

IO.puts(true or raise("This error will never be raised")) # true

###################################################################
# Elixir also provides the concept of nil, to indicate the absence of a value,
# and a set of logical operators that also manipulate nil: ||/2, &&/2, and !/1.
# For these operators, false and nil are considered "falsy", all other values are considered "truthy":
IO.puts(1 || true) # 1
IO.puts(false || 11) # 11

IO.puts(nil && 13) # nil
IO.puts(true && 17) # 17

IO.puts(!true) # false
IO.puts(!1) # false
IO.puts(!nil) # true

###################################################################
# When writing a function that returns a boolean value,
# it is idiomatic to end the function name with a ?.
# The same convention can be used for variables that
# store boolean values.
def either_true?(a?, b?) do
  a? or b?
end

###################################################################
# Demonstrating nil equality
IO.puts(nil == nil) # true
IO.puts(nil === nil) # true

# nil is an atom but has special syntax
IO.puts(nil == :nil) # true
IO.puts(is_atom(nil)) # true

###################################################################
# Common patterns with nil handling
name = nil
# Using || for default values
IO.puts(name || "Anonymous") # "Anonymous"

# Using function with nil handling
safe_div = fn
  _, 0 -> nil
  a, b -> a / b
end

IO.puts(safe_div.(10, 2)) # 5.0
IO.puts(safe_div.(10, 0) || "Cannot divide by zero") # "Cannot divide by zero"

###################################################################
# Pattern matching with nil
case nil do
  nil -> IO.puts("It's nil!")
  _ -> IO.puts("It's something else")
end

###################################################################
# Using the maybe pattern (handling nil values)
user = %{name: "John", address: nil}

with {:ok, name} <- {:ok, user.name},
     {:ok, address} <- if(user.address, do: {:ok, user.address}, else: :error) do
  IO.puts("User #{name} lives at #{address}")
else
  :error -> IO.puts("User has no address")
end # "User has no address"
