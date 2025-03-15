defmodule LearnFlow do
  @moduledoc """
  Learning Flow - a computational flow library for Elixir based on GenStage
  """

  def run do
    # Basic flow example
    basic_flow()

    # Partitioning example
    partitioning_example()

    # Flow reduction example
    reduction_example()

    # More complex pipeline
    advanced_example()
  end

  def basic_flow do
    IO.puts("\n--- Basic Flow Example ---")

    # Create a simple flow from a range
    result = 1..10
    |> Flow.from_enumerable()
    |> Flow.map(fn x -> x * 2 end)
    |> Flow.filter(fn x -> rem(x, 4) == 0 end)
    |> Enum.to_list()

    IO.inspect(result, label: "Doubled and filtered to multiples of 4")
    # Doubled and filtered to multiples of 4: [4, 8, 12, 16, 20]
  end

  def partitioning_example do
    IO.puts("\n--- Partitioning Example ---")

    # Create a flow with partitioning based on remainder when divided by 3
    result = 1..20
    |> Flow.from_enumerable()
    |> Flow.partition(key: fn x -> rem(x, 3) end)
    |> Flow.reduce(fn -> %{} end, fn element, acc ->
      remainder = rem(element, 3)
      Map.update(acc, remainder, [element], fn list -> [element | list] end)
    end)
    |> Enum.to_list()

    IO.inspect(result, label: "Partitioned by remainder mod 3")
    # Partitioned by remainder mod 3: [
    #   {0, [18, 15, 12, 9, 6, 3]},
    #   {1, [19, 16, 13, 10, 7, 4, 1]},
    #   {2, [20, 17, 14, 11, 8, 5, 2]}
    # ]
  end

  def reduction_example do
    IO.puts("\n--- Flow Reduction Example ---")

    # Using reduce to process batches of data
    result = 1..100
    |> Flow.from_enumerable(max_demand: 10) # Process in chunks of 10
    |> Flow.partition()
    |> Flow.reduce(fn -> [] end, fn element, acc ->
      [element | acc]
    end)
    |> Flow.on_trigger(fn acc ->
      sum = Enum.sum(acc)
      count = length(acc)
      {[{count, sum, sum / count}], []}  # Return tuple with events and new state
    end)
    |> Enum.to_list()

    IO.inspect(result, label: "Batch processing statistics")
    # Batch processing statistics: [
    #   {2, 172, 86.0},
    #   {4, 243, 60.75},
    #   {3, 202, 67.33333333333333},
    #   {5, 328, 65.6},
    #   {4, 178, 44.5},
    #   {5, 297, 59.4},
    #   {3, 198, 66.0},
    #   {5, 208, 41.6},
    #   {6, 431, 71.83333333333333},
    #   {6, 239, 39.833333333333336},
    #   {5, 113, 22.6},
    #   {5, 175, 35.0},
    #   {2, 75, 37.5},
    #   {4, 223, 55.75},
    #   {2, 130, 65.0},
    #   {4, 153, 38.25},
    #   {4, 101, 25.25},
    #   {8, 469, 58.625},
    #   {6, 234, 39.0},
    #   {4, 252, 63.0},
    #   {6, 228, 38.0},
    #   {7, 401, 57.285714285714285}
    # ]
  end

  def advanced_example do
    IO.puts("\n--- Advanced Flow Example ---")

    # Simulate a more complex data processing pipeline
    words = ["hello", "flow", "elixir", "processing", "data", "pipeline",
             "concurrent", "stream", "functional", "programming"]

    # Create a simple word processing pipeline
    result = words
    |> Stream.cycle() # Creates an infinite stream
    |> Stream.take(1000) # Take only 1000 words
    |> Flow.from_enumerable(max_demand: 50)
    |> Flow.partition()
    |> Flow.map(fn word ->
      # Simulate some work
      Process.sleep(5)
      {word, String.length(word)}
    end)
    |> Flow.reduce(fn -> %{} end, fn {word, length}, acc ->
      key = cond do
        length < 5 -> :short
        length < 8 -> :medium
        true -> :long
      end

      # Group by length category
      Map.update(acc, key, [{word, length}], fn existing ->
        [{word, length} | existing]
      end)
    end)
    |> Flow.on_trigger(fn acc ->
      results = Enum.map(acc, fn {key, items} ->
        word_count = length(items)
        lengths = Enum.map(items, fn {_, len} -> len end)
        sum_lengths = Enum.sum(lengths)
        avg_length = sum_lengths / word_count
        {key, word_count, Float.round(avg_length, 2)}
      end)
      {results, %{}}  # Return tuple with events and new state
    end)
    |> Enum.to_list()
    |> List.flatten()

    IO.inspect(result, label: "Word statistics by length category")
    # Word statistics by length category: [
    #   {:long, 100, 10.0},
    #   {:long, 100, 8.0},
    #   {:medium, 100, 5.0},
    #   {:medium, 100, 6.0},
    #   {:long, 100, 10.0},
    #   {:short, 100, 4.0},
    #   {:short, 100, 4.0},
    #   {:medium, 100, 6.0},
    #   {:long, 200, 10.5}
    # ]
  end
end
