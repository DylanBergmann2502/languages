IO.puts("hellö")

# You can concatenate two strings with the <>/2 operator:
IO.puts("hello " <> "world!")

########################################################
## String interpolation
string = "world"
IO.puts("hello #{string}!")
IO.puts("hello world!")

# Any Elixir expression is valid inside the interpolation.
# If a string is given, the string is interpolated as is.
# If any other value is given, Elixir will attempt to convert it to a string.
IO.puts("Elixir can convert booleans to strings: #{true}") # => "Elixir can convert booleans to strings: true"
IO.puts("And #{["lists", ", ", "too!"]}")                  # => "And lists, too!"
# IO.puts("But not functions: #{fn x -> x end}")           # => Error !

########################################################
## Heredocs
docs = """
1
2
3
"""
IO.puts(docs)

########################################################
## String functions
IO.puts(String.length("hellö")) # 5

IO.puts(String.upcase("hellö")) # "HELLÖ"
IO.puts(String.downcase("AB 123 XPTO")) # "ab 123 xpto"
IO.puts(String.capitalize("ABCD")) # "Abcd"

IO.puts(String.duplicate("abc", 0)) # ""
IO.puts(String.duplicate("abc", 2)) # "abcabc"

IO.puts(String.contains?("elixir of life", "of")) # true
IO.puts(String.ends_with?("language", "age"))
IO.puts(String.starts_with?("elixir", "eli"))

IO.puts(String.first("elixir")) # e
IO.puts(String.last("elixir")) # r
IO.puts(String.reverse("abcd")) # "dcba"

IO.puts(String.replace("a,b,c", ",", "-")) # "a-b-c"
IO.puts(String.split("a,b,c", ",")) # ["a", "b", "c"]
