IO.puts("hellö")

# You can concatenate two strings with the <>/2 operator:
IO.puts("hello " <> "world!")

# String interpolation
string = "world"
IO.puts("hello #{string}!")
IO.puts("hello world!")

IO.puts(String.length("hellö")) # 5
IO.puts(String.upcase("hellö")) # "HELLÖ"
