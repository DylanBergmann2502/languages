# 1. String.Chars - Most commonly implemented protocol
# Used when you want your type to work with to_string/1 or "#{interpolation}"

defmodule Temperature do
  defstruct [:degrees, :scale]

  defimpl String.Chars do
    def to_string(%Temperature{degrees: degrees, scale: scale}) do
      "#{degrees}°#{scale}"
    end
  end

  def run do
    temp = %Temperature{degrees: 25, scale: "C"}
    IO.puts("Current temperature is #{temp}")  # Current temperature is 25°C
    IO.inspect(temp)  # #Temperature<25°C>
  end
end

# 2. Inspect - For developer-friendly string representation
# Used with IO.inspect and IEx

defimpl Inspect, for: Temperature do
  def inspect(%Temperature{degrees: degrees, scale: scale}, _opts) do
    "#Temperature<#{degrees}°#{scale}>"
  end
end

Temperature.run()

# 3. Enumerable - To make your type work with Enum functions
defmodule NumberRange do
  defstruct [:start, :end]

  defimpl Enumerable do
    def count(%NumberRange{start: start, end: end_val}) do
      {:ok, end_val - start + 1}
    end

    def member?(%NumberRange{start: start, end: end_val}, value) do
      {:ok, value >= start && value <= end_val}
    end

    def slice(%NumberRange{start: start, end: end_val}) do
      size = end_val - start + 1
      {:ok, size, &slice_fun(start, &1, &2)}
    end

    defp slice_fun(start, offset, length) do
      Enum.to_list((start + offset)..(start + offset + length - 1))
    end

    def reduce(%NumberRange{start: start, end: end_val}, acc, fun) do
      Enumerable.reduce(start..end_val, acc, fun)
    end
  end

  def run do
    range = %NumberRange{start: 1, end: 5}
    IO.inspect Enum.to_list(range)  # [1, 2, 3, 4, 5]
  end
end

NumberRange.run()

# 4. Collectable - For collecting elements into your type
# Used with Enum.into and for comprehensions

defmodule Queue do
  defstruct items: []

  def new(), do: %Queue{}

  defimpl Collectable do
    def into(queue) do
      collector_fn = fn
        # On :cont, add the element to the queue
        acc, {:cont, elem} ->
          %Queue{items: acc.items ++ [elem]}

        # On :halt, just return the accumulated queue
        acc, :halt ->
          acc

        # On :done, return the final queue
        acc, :done ->
          acc
      end

      {queue, collector_fn}
    end
  end

  def run do
    # Using Enum.into to collect elements into our Queue
    queue = Enum.into(1..3, Queue.new())
    IO.inspect queue  # %Queue{items: [1, 2, 3]}

    # Using for comprehension which uses Collectable under the hood
    queue2 = for x <- 1..3, into: Queue.new(), do: x * 2
    IO.inspect queue2  # %Queue{items: [2, 4, 6]}
  end
end

Queue.run()
