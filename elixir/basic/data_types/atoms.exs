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
