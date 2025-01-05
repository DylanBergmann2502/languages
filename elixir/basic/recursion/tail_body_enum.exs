# Tail call recursion is better when you are
# returning only one value at the end
# while body call recursion is better for returning collections
# because you will need to reverse it
# at the very end which makes it less performant

################################################################
# The Enum version is the most readable and maintainable
# Body recursion maintains natural order but uses more stack space
# Tail recursion is stack-efficient but needs a reverse operation at the end

defmodule ListProcessor do
  # Enum chain version
  def process_enum(list) do
    list
    |> Enum.filter(&(rem(&1, 2) == 0))
    |> Enum.map(&(&1 * 2))
  end

  # Body recursion version (natural order, no reversing needed)
  def process_body([]), do: []
  def process_body([head | tail]) do
    if rem(head, 2) == 0 do
      [head * 2 | process_body(tail)]
    else
      process_body(tail)
    end
  end

  # Tail recursion version (needs reverse at end)
  def process_tail(list), do: do_process_tail(list, [])

  defp do_process_tail([], acc), do: Enum.reverse(acc)
  defp do_process_tail([head | tail], acc) do
    if rem(head, 2) == 0 do
      do_process_tail(tail, [head * 2 | acc])
    else
      do_process_tail(tail, acc)
    end
  end
end

# Let's test them all
list = [1, 2, 3, 4, 5, 6, 7, 8]

IO.puts("Enum chain version:")
IO.inspect(ListProcessor.process_enum(list))    # [4, 8, 12, 16]

IO.puts("\nBody recursion version:")
IO.inspect(ListProcessor.process_body(list))    # [4, 8, 12, 16]

IO.puts("\nTail recursion version:")
IO.inspect(ListProcessor.process_tail(list))    # [4, 8, 12, 16]

IO.puts "#{String.duplicate("#", 75)}"

########################################################################
# We're accumulating a single value, not building a collection
# No reverse operation is needed
# Stack space is constant
# The calculation flows naturally with an accumulator

defmodule Summer do
  # Enum version
  def sum_enum(list) do
    list
    |> Enum.filter(&(rem(&1, 2) == 0))
    |> Enum.sum()
  end

  # Body recursion (less efficient here)
  def sum_body([]), do: 0
  def sum_body([head | tail]) do
    if rem(head, 2) == 0 do
      head + sum_body(tail)
    else
      sum_body(tail)
    end
  end

  # Tail recursion (most efficient for this case)
  def sum_tail(list), do: do_sum_tail(list, 0)

  defp do_sum_tail([], acc), do: acc
  defp do_sum_tail([head | tail], acc) do
    if rem(head, 2) == 0 do
      do_sum_tail(tail, acc + head)
    else
      do_sum_tail(tail, acc)
    end
  end
end

list = [1, 2, 3, 4, 5, 6, 7, 8]

IO.puts("Sum using Enum:")
IO.inspect(Summer.sum_enum(list))    # 20

IO.puts("\nSum using body recursion:")
IO.inspect(Summer.sum_body(list))    # 20

IO.puts("\nSum using tail recursion:")
IO.inspect(Summer.sum_tail(list))    # 20
