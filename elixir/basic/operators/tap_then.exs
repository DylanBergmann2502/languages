# Kernel.tap/2 and Kernel.then/2 - pipeline helpers added in Elixir 1.12.

################################################################
# Kernel.then/2 - pipe into a function when the function doesn't take the value as first arg

# The |> operator always passes the value as the FIRST argument.
# But sometimes the function you want takes it elsewhere - then/2 solves that.

# Problem: you want to pipe a value into the second argument of a function.
# Without then:
result = Enum.member?([1, 2, 3], 2)
IO.inspect(result) # true

# With then - put the list anywhere in the call:
result2 = [1, 2, 3]
  |> then(fn list -> Enum.member?(list, 2) end)
IO.inspect(result2) # true

# More natural example: piping into a map transformation
user_params = %{"name" => "Alice", "age" => "30"}

normalized = user_params
  |> Map.update("age", 0, &String.to_integer/1)
  |> then(fn params -> %{name: params["name"], age: params["age"]} end)
IO.inspect(normalized) # %{name: "Alice", age: 30}

# then/2 is cleaner than wrapping with an anonymous fn at the pipe end:
# Old style:
"hello" |> String.upcase() |> (fn s -> s <> "!" end).()
# New style:
"hello" |> String.upcase() |> then(fn s -> s <> "!" end)
IO.inspect("hello" |> String.upcase() |> then(fn s -> s <> "!" end)) # "HELLO!"

# Pipe into a function with multiple extra args:
IO.inspect(
  "hello world"
  |> String.split()
  |> then(&Enum.join(&1, "-"))
) # "hello-world"

################################################################
# Kernel.tap/2 - run a side effect in a pipeline without changing the value

# tap/2 applies a function for its side effects but returns the ORIGINAL value.
# Perfect for debugging pipelines without breaking them.

result3 = [1, 2, 3, 4, 5]
  |> tap(fn list -> IO.inspect(list, label: "input") end)
  |> Enum.filter(&rem(&1, 2) == 0)
  |> tap(fn list -> IO.inspect(list, label: "after filter") end)
  |> Enum.map(&(&1 * 10))
  |> tap(fn list -> IO.inspect(list, label: "after map") end)

IO.inspect(result3) # [20, 40] - the actual result

# tap is like IO.inspect(label:) but more composable
# and doesn't change the type (unlike IO.inspect in some edge cases)

################################################################
# Practical: logging in a pipeline

defmodule Pipeline do
  require Logger

  def process(data) do
    data
    |> validate()
    |> tap(&Logger.debug("After validation: #{inspect(&1)}"))
    |> transform()
    |> tap(&Logger.debug("After transform: #{inspect(&1)}"))
    |> save()
  end

  defp validate(x), do: {:ok, x}
  defp transform({:ok, x}), do: {:ok, x * 2}
  defp save({:ok, x}), do: {:saved, x}
end

IO.inspect(Pipeline.process(21)) # {:saved, 42}

################################################################
# then/2 for conditional branching in pipelines

result4 = 42
  |> then(fn n ->
    if n > 40, do: n * 2, else: n
  end)
IO.inspect(result4) # 84

# Or with case:
result5 = {:ok, 10}
  |> then(fn
    {:ok, n}  -> n * 2
    {:error, _} -> 0
  end)
IO.inspect(result5) # 20

################################################################
# Comparison: tap vs IO.inspect in pipelines

# IO.inspect works but always prints in the inspect format:
"hello"
|> String.upcase()
|> IO.inspect()  # "HELLO" (prints and passes through)
|> String.reverse()
|> IO.inspect()  # "OLLEH"

# tap lets you format the output however you want:
"hello"
|> String.upcase()
|> tap(fn s -> IO.puts("Uppercased: #{s}") end)
|> String.reverse()
|> tap(fn s -> IO.puts("Reversed: #{s}") end)

################################################################
# Summary
IO.puts("""
then/2  - transforms the value (changes what flows through the pipe)
tap/2   - side effects only (original value continues unchanged)

Use then/2 when: the next function doesn't take value as first arg
Use tap/2 when:  you want to log/debug without interrupting the pipe
""")
