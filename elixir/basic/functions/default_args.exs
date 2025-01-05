# When compiling the above example, Elixir creates a function definition for number/0 (no arguments), and number/1 (one argument).
# If more than one argument has default values, the default values will be applied to the function from left to right to fill in for missing arguments.
# If the function has multiple clauses, it is required to write a function header for the default arguments.
# Any expression can serve as the default value.
# Anonymous functions cannot have default arguments.

defmodule Guessing do
  def guess(number \\ 5)
  def guess(number) when number != 5, do: false
  def guess(number) when number == 5, do: true
end

IO.puts Guessing.guess() # => true

# If a function with default values has multiple clauses,
# it is required to create a function head
# (a function definition without a body) for declaring defaults:
defmodule Concat do
  # A function head declaring defaults
  def join(a, b \\ nil, sep \\ " ")

  def join(a, b, _sep) when is_nil(b) do
    a
  end

  def join(a, b, sep) do
    a <> sep <> b
  end
end

IO.puts Concat.join("Hello", "world")      #=> Hello world
IO.puts Concat.join("Hello", "world", "_") #=> Hello_world
IO.puts Concat.join("Hello")               #=> Hello

def DoSomething do
  # In order to specify a default value for these functions,
  # we don't put the default value in both function clauses,
  # but rather we create a new function clause that just
  # has the default values and no function body. These default
  # values will then apply to the other function clauses of the same arity.
  def do_something(param1, param2 \\ 3)

  def do_something(param1, param2) when is_integer(param1) do
    {param1 * 10, param2}
  end

  def do_something(param1, param2) when is_float(param1) do
    {param1 * 100, param2}
  end
end
