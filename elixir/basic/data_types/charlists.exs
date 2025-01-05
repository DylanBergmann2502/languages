# Charlists are created using the ~c Sigil.
IO.puts ~c"hello"

########################################################################
# A charlist is a list of integers.
# The integers represent the Unicode values of a given character — also known as code points.
# If a list of integers contains only integers
# that are code points of printable character,
# it will be displayed as a charlist. Even if it was defined using the [] syntax.
IO.puts [65, 66, 67] # ABC
IO.inspect [65, 66, 67] # ~c"ABC"

# If a list of integers contains even one code point
# of an unprintable character (e.g. 0-6, 14-26, 28-31),
# it will be displayed as a list. Even if it was defined using the~c"" syntax.
IO.inspect ~c"ABC\0" # [65, 66, 67, 0]
IO.inspect [65, 66, 67, 0] # [65, 66, 67, 0]

# Printability can be checked with List.ascii_printable?.
List.ascii_printable?([65, 66, 67]) # true
List.ascii_printable?([65, 66, 67, 0]) # false

# They are strictly equal
IO.puts ~c"ABC" === [65, 66, 67] # true

# When printing a list with IO.inspect,
# you can use the :charlists option to control how lists are printed.
IO.inspect(~c"ABC", charlists: :as_charlists) # ~c"ABC"
IO.inspect(~c"ABC", charlists: :as_lists) # [65, 66, 67]

################################################################
# Charlists are lists
IO.puts ~c"" === [] # true
IO.puts is_list(~c"hello") # true

# Because charlist are lists,
# you can work with them just like with any other list
# Like: using recursion and pattern matching, or using the List module.
[first_letter | _] = ~c"cat"
IO.puts first_letter # 99
IO.puts List.first(~c"hello") # 104

# <> is for strings, ++ is for lists
concat_value = ~c"hi" ++ ~c"!"
IO.puts concat_value

# You can prepend a character with ? to get its code point.
IO.puts ?A

# Charlists and strings
# consisting of the same characters are not considered equal.
are_equal = ~c"hello" == "hello"
IO.puts are_equal # false

# Charlists can be converted to strings with to_string.
IO.puts to_string(~c"hello") # "hello"
