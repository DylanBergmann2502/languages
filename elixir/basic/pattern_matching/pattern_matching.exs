# When writing Elixir functions, we can make use of an assertive style with pattern matching:
defmodule FileReader do
  def read_file(path) do
    {:ok, contents} = File.read(path)
    contents
  end
end

# Pattern matching is explicitly performed using the match operator, =/2.
{:ok, number, _} = {:ok, 5, [4.5, 6.3]}
IO.puts number # => 5 is bound to this variable

# The pin operator ^ can be used to prevent
# rebounding a variable and instead pattern match
# against its existing value.
number = 10
# {:ok, ^number, _} = {:ok, 5, [4.5, 6.3]}
# => ** (MatchError) no match of right hand side value: {:ok, 5, [4.5, 6.3]}

# We demonstrate it with try/rescue to avoid crashing:
try do
  {:ok, ^number, _} = {:ok, 5, [4.5, 6.3]}
rescue
  e in MatchError -> IO.puts("Caught: no match for #{inspect(e.term)}")
end

{a, b, c} = {:hello, "world", 42}
IO.inspect(a) # :hello
IO.inspect(b) # "world"
IO.inspect(c) # 42

# Mismatched shapes raise MatchError:
try do
  {_a, _b, _c} = {:hello, "world"}
rescue
  e in MatchError -> IO.puts("Shape mismatch: #{inspect(e.term)}")
end

try do
  {_a, _b, _c} = [:hello, "world", 42]
rescue
  e in MatchError -> IO.puts("Type mismatch: #{inspect(e.term)}")
end

[head | tail] = [1, 2, 3] # [1, 2, 3]
IO.inspect(head) # 1
IO.inspect(tail) # [2, 3]
