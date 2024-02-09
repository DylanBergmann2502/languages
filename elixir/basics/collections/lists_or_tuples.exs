# Lists are stored in memory as linked lists,
# meaning that each element in a list holds its value and points to
# the following element until the end of the list is reached.
# This means accessing the length of a list is a linear operation:
# we need to traverse the whole list in order to figure out its size.
list = [1, 2, 3]
[1, 2, 3]

# This is fast as we only need to traverse `[0]` to prepend to `list`
[0] ++ list
[0, 1, 2, 3]

# This is slow as we need to traverse `list` to append 4
list ++ [4]
[1, 2, 3, 4]


#########################################################################
# Tuples, on the other hand, are stored contiguously in memory.
# This means getting the tuple size or accessing an element by index is fast.
# On the other hand, updating or adding elements to tuples
# is expensive because it requires creating a new tuple in memory:
tuple = {:a, :b, :c, :d}

put_elem(tuple, 2, :e) # {:a, :b, :e, :d}


#########################################################################
# The String.split/2 function breaks a string into
# a list of strings on every whitespace character.
# Since the amount of elements returned depends on the input, we use a list.
String.split("hello world") # ["hello", "world"]

# On the other hand, String.split_at/2 splits a string
# in two parts at a given position. Since it always returns two entries,
# regardless of the input size, it returns tuples:
String.split_at("hello world", 3) # {"hel", "lo world"}


#########################################################################
# It is also very common to use tuples and atoms
# to create "tagged tuples", which is a handy return value
# when an operation may succeed or fail.
File.read("path/to/existing/file") # {:ok, "... contents ..."}
File.read("path/to/unknown/file")  # {:error, :enoent}


#########################################################################
# Key-value pairs
# 2-element tuples
a = { :name, "Miguel Palhas" }
b = { :email, "miguel@example.com" }

# Key-word lists
list1 = [ name: "Miguel Palhas", email: "miguel@example.com" ]

# As it turns out, this is just syntactic sugar for a list, where each value is a 2-element tuple.
list2 = [
  { :name, "Miguel Palhas"},
  { :email, "miguel@example.com" }
]

Enum.at(list1, 0) # {:name, "Miguel Palhas"}
