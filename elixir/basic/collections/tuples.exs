# Tuples in Elixir
# ----------------
# Tuples are ordered collections that store elements contiguously in memory.
# They are immutable - every operation returns a new tuple.
# Tuples are good for pattern matching and returning multiple values.

# Basic tuple creation
empty_tuple = {}
simple_tuple = {:ok, "hello"}
nested_tuple = {:user, "John", 28, {:address, "New York"}}

IO.puts("Empty tuple: #{inspect(empty_tuple)}")
IO.puts("Simple tuple: #{inspect(simple_tuple)}")
IO.puts("Nested tuple: #{inspect(nested_tuple)}")

# Accessing elements with elem/2
# elem/2 is a zero-indexed function to access tuple elements
first_element = elem(simple_tuple, 0)  # :ok
second_element = elem(simple_tuple, 1) # "hello"

IO.puts("\nAccessing elements:")
IO.puts("First element: #{inspect(first_element)}")
IO.puts("Second element: #{inspect(second_element)}")

# Getting tuple size
size = tuple_size(simple_tuple) # 2
IO.puts("\nTuple size: #{size}")

# Modifying tuples with put_elem/3
# Remember: this creates a new tuple, doesn't modify the original
modified_tuple = put_elem(simple_tuple, 1, "world") # {:ok, "world"}
IO.puts("\nOriginal tuple: #{inspect(simple_tuple)}")
IO.puts("Modified tuple: #{inspect(modified_tuple)}")

# Pattern matching with tuples
{status, message} = {:ok, "Operation completed"}
IO.puts("\nPattern matching:")
IO.puts("Status: #{status}, Message: #{message}")

# Pattern matching in function clauses
handle_result = fn
  {:ok, value} -> "Success: #{value}"
  {:error, reason} -> "Error: #{reason}"
end

success = handle_result.({:ok, "Data saved"})
error = handle_result.({:error, "Connection failed"})

IO.puts("\nPattern matching in functions:")
IO.puts(success)
IO.puts(error)

# Tuple module functions
tuple = {:foo, :bar, :baz, :qux}

# Convert tuple to list
list = Tuple.to_list(tuple)
IO.puts("\nTuple.to_list/1:")
IO.puts("Tuple: #{inspect(tuple)}")
IO.puts("List: #{inspect(list)}")

# Insert an element at a specific position
# This creates a new tuple with the element inserted at the given index
new_tuple = Tuple.insert_at(tuple, 2, :inserted)
IO.puts("\nTuple.insert_at/3:")
IO.puts("Original: #{inspect(tuple)}")
IO.puts("After insertion: #{inspect(new_tuple)}")

# Delete an element at a specific position
deleted_tuple = Tuple.delete_at(tuple, 1)
IO.puts("\nTuple.delete_at/2:")
IO.puts("Original: #{inspect(tuple)}")
IO.puts("After deletion: #{inspect(deleted_tuple)}")

# Duplicate a value to create a tuple
repeated_tuple = Tuple.duplicate(:value, 5)
IO.puts("\nTuple.duplicate/2:")
IO.puts("#{inspect(repeated_tuple)}")

# Append to a tuple
appended_tuple = Tuple.append(tuple, :appended)
IO.puts("\nTuple.append/2:")
IO.puts("Original: #{inspect(tuple)}")
IO.puts("After append: #{inspect(appended_tuple)}")

# Performance characteristics
IO.puts("\nPerformance characteristics:")
IO.puts("- Fast random access (constant time)")
IO.puts("- Fast size lookup (constant time)")
IO.puts("- Expensive modifications (linear time)")
IO.puts("- Memory efficient for small, fixed-size collections")

# Common use cases
IO.puts("\nCommon use cases:")
IO.puts("1. Return values with status (e.g., {:ok, result} or {:error, reason})")
IO.puts("2. Fixed-size collections where position has meaning")
IO.puts("3. Pattern matching when structure is known")
IO.puts("4. Small data structures with heterogeneous types")

# When NOT to use tuples
IO.puts("\nWhen NOT to use tuples:")
IO.puts("1. When you need to add/remove elements frequently")
IO.puts("2. When you need to iterate through all elements")
IO.puts("3. When size is dynamic or large")
IO.puts("4. When you need to check if an element exists")
