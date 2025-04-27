# An atom is a constant whose value is its own name.
# Some other languages call these symbols.
# They are often useful to enumerate over distinct values, such as:
IO.puts(:apple) # :apple
IO.puts(:orange) # :orange
IO.puts(:watermelon) # :watermelon

# Atoms are equal if their names are equal.
IO.puts(:apple == :apple) # true
IO.puts(:apple == :orange) # false

# Often they are used to express the state of an operation, by using values such as :ok and :error.
# The booleans true and false are also atoms.
# Elixir allows you to skip the leading : for the atoms false, true and nil.
IO.puts(true == :true) # true
IO.puts(is_atom(false)) # true
IO.puts(is_boolean(:false)) # true

# Names of modules in Elixir are also atoms.
# MyApp.MyModule is a valid atom,
# even if no such module has been declared yet.
IO.puts(is_atom(MyApp.MyModule)) # true

# The Atom module provides utility functions for working with atoms
atom_string = Atom.to_string(:hello) # "hello"
IO.puts(atom_string)

# Converting between atoms and strings
string_value = "dynamic_value"
dynamic_atom = String.to_atom(string_value)
IO.puts(dynamic_atom) # :dynamic_value

# CAUTION: Creating atoms dynamically can lead to atom table overflow
# Safer conversion with String.to_existing_atom/1
# Only converts to atoms that already exist in the VM
try do
 String.to_existing_atom("this_atom_doesnt_exist_yet")
catch
 :error, _ -> IO.puts("Error: Atom doesn't exist")
end

# Common built-in atoms
# nil, true, and false are built-in atoms
IO.puts(nil == :nil) # true

# Module names are atoms
IO.puts(is_atom(String)) # true
IO.puts(is_atom(List)) # true
IO.puts(is_atom(Map)) # true

# Creating atoms from module references
defmodule Test.User do
end
IO.puts(Test.User == :"Elixir.Test.User") # true

# Memory considerations:
# Atoms are stored in an atom table which has a default limit
# Current atom count in the system
atom_count = :erlang.system_info(:atom_count)
IO.puts("Current atom count: #{atom_count}")

# Special atom literals with spaces or special characters
IO.puts(:"atom with spaces") # :atom with spaces
IO.puts(:"atoms@with.special!chars") # :atoms@with.special!chars

# Common pattern in Elixir - using atoms in tuples for return values
success = {:ok, "operation succeeded"}
error = {:error, "something went wrong"}

# We can match on these tuples in function heads or case statements
case success do
 {:ok, message} -> IO.puts("Success: #{message}")
 {:error, reason} -> IO.puts("Failed: #{reason}")
end
