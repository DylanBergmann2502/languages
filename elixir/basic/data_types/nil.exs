# nil is an atom, but it is usually written as nil, not :nil.
# The boolean values true and false are atoms too.

IO.puts nil === :nil # => true

IO.puts true === :true # => true

# is_nil guard
IO.puts is_nil(nil) # => true

IO.puts is_nil(true) # => false
