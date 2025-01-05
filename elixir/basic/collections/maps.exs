# Keys can be of any type, but must be unique.
# Values can be of any type, they do not have to be unique.
# Maps are unordered

################################################################
# Declare a map

# An empty map
IO.inspect %{}

# A map with the atom key :a associated to the integer value 1
IO.inspect %{a: 1}

# A map with the string key "a" associated to the float value 2.0
IO.inspect %{"a" => 2.0}

# A map with the map key %{} with the list value [1 ,2, 3]
IO.inspect %{%{} => [1, 2, 3]}

# A map with keys of different types
IO.inspect %{:a => 1, "b" => 2}

# Maps can also be instantiated using Map.new
IO.inspect Map.new

kw_list = [a: 1, b: 2]
IO.inspect Map.new(kw_list)

################################################################
# Accessing map values

# When the key in a key-value pair is an atom,
# the key: value shorthand syntax can be used (as in many other special forms):
my_map = %{key: "value"}

# If you want to mix the shorthand syntax with =>, the shorthand syntax must come at the end:
my_mixed_map = %{"hello" => "world", a: 1, b: 2}

# with a dot if the key is an atom
my_map.key # => "value"

# my_map.keyy # ** (KeyError) key :keyy not found in: %{key: "value"}

# with [], a syntax provided by the Access behaviour
my_map[:key] # => "value"

# with pattern matching
%{key: x} = my_map
x # => "value"

# with Map.get/2
Map.get(my_map, :key) # => "value"

my_map2 = %{"key" => 2}
IO.puts Map.get(my_map2, "key")

Map.get(%{:a => 1, 2 => :b}, :a) # 1

Map.put(%{:a => 1, 2 => :b}, :c, 3) # %{2 => :b, :a => 1, :c => 3}

Map.to_list(%{:a => 1, 2 => :b}) # [{2, :b}, {:a, 1}]

# There is also syntax for updating keys,
# which also raises if the key has not yet been defined:
map = %{name: "John", age: 23}
%{map | name: "Mary"} # %{name: "Mary", age: 23}
# %{map | agee: 27} # ** (KeyError) key :agee not found in: %{name: "John", age: 23}

################################################################
# Pattern matching

%{:a => a} = %{:a => 1, 2 => :b}
IO.puts a           # 1

# ** (MatchError) no match of right hand side value: %{2 => :b, :a => 1}
# %{:c => c} = %{:a => 1, 2 => :b}


################################################################
# Nested data structure
users = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]

users[:john].age # 27

users = put_in users[:john].age, 31
"""
[
  john: %{age: 31, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
  mary: %{age: 29, languages: ["Elixir", "F#", "Clojure"], name: "Mary"}
]
"""

# The update_in/2 macro is similar
# but allows us to pass a function
# that controls how the value changes.
users = update_in users[:mary].languages, fn languages -> List.delete(languages, "Clojure") end
"""
[
  john: %{age: 31, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
  mary: %{age: 29, languages: ["Elixir", "F#"], name: "Mary"}
]
"""
