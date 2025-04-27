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
IO.puts List.ascii_printable?([65, 66, 67]) # true
IO.puts List.ascii_printable?([65, 66, 67, 0]) # false

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
IO.puts ?A # 65

# Charlists and strings
# consisting of the same characters are not considered equal.
are_equal = ~c"hello" == "hello"
IO.puts are_equal # false

# Charlists can be converted to strings with to_string.
IO.puts to_string(~c"hello") # "hello"

################################################################
# Converting between charlists and strings
string = "hello"
charlist = to_charlist(string)
IO.inspect charlist # ~c"hello"

# String to charlist conversion is reversible
IO.puts string == to_string(charlist) # true

################################################################
# Working with charlists using Enum functions
IO.puts Enum.at(~c"hello", 0) # 104 (code point for 'h')
IO.puts Enum.count(~c"hello") # 5
IO.inspect Enum.map(~c"ABC", fn x -> x + 1 end) # [66, 67, 68] (shifted by 1)
IO.puts to_string(Enum.map(~c"ABC", fn x -> x + 1 end)) # "BCD"

################################################################
# Character operations
# Checking if a code point is letter, number, etc.
IO.puts ?a >= ?a and ?a <= ?z # true (is lowercase letter)
IO.puts ?A >= ?A and ?A <= ?Z # true (is uppercase letter)
IO.puts ?0 >= ?0 and ?0 <= ?9 # true (is digit)

# Case conversion on code points
upcase = fn char when char >= ?a and char <= ?z -> char - 32; char -> char end
IO.puts to_string(Enum.map(~c"Hello", upcase)) # "HELLO"

################################################################
# Common use cases for charlists
# 1. Interfacing with Erlang functions that expect charlists
# 2. Pattern matching with recursion on character sequences
# 3. Low-level character manipulation

# Example: A simple pattern matching function that works with charlists
defmodule CharlistDemo do
  def count_vowels(chars) do
    count_vowels(chars, 0)
  end

  defp count_vowels([], acc), do: acc
  defp count_vowels([char | rest], acc) when char in [?a, ?e, ?i, ?o, ?u, ?A, ?E, ?I, ?O, ?U] do
    count_vowels(rest, acc + 1)
  end
  defp count_vowels([_char | rest], acc) do
    count_vowels(rest, acc)
  end
end

IO.puts CharlistDemo.count_vowels(~c"hello") # 2
