# When writing Elixir functions, we can make use of an assertive style with pattern matching:
def read_file() do
  {:ok, contents} = File.read("hello.txt")
  contents
end

# Pattern matching is explicitly performed using the match operator, =/2.
{:ok, number, _} = {:ok, 5, [4.5, 6.3]}
IO.puts number # => 5 is bound to this variable

# The pin operator ^ can be used to prevent
# rebounding a variable and instead pattern match
# against its existing value.
number = 10
{:ok, ^number, _} = {:ok, 5, [4.5, 6.3]}
# => ** (MatchError) no match of right hand side value: {:ok, 5, [4.5, 6.3]}

{a, b, c} = {:hello, "world", 42}
a # :hello
b # "world"

{a, b, c} = {:hello, "world"}     # ** (MatchError) no match of right hand side value: {:hello, "world"}
{a, b, c} = [:hello, "world", 42] # ** (MatchError) no match of right hand side value: [:hello, "world", 42]

[head | tail] = [1, 2, 3] # [1, 2, 3]
head # 1
tail # [2, 3]
