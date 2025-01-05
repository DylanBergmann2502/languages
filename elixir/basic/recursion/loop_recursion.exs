# Using for loop
numbers = [1, 2, 3, 4, 5]

for number <- numbers do
  IO.puts(number)
end

################################################################
# Using recursion
defmodule RecursionExample do
  def print_list([]), do: :ok

  def print_list([head | tail]) do
    IO.puts(head)
    print_list(tail)
  end
end

numbers = [1, 2, 3, 4, 5]
RecursionExample.print_list(numbers)
