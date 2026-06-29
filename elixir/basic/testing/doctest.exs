# ExUnit.DocTest automatically runs code examples in @doc strings as tests.
# Any line starting with "iex>" in a @doc block becomes a test.
# This keeps documentation and behaviour in sync.
#
# IMPORTANT: DocTest requires compiled .beam files and a Mix project.
# In a .exs script, `doctest MyModule` raises an error because there are
# no .beam files available. This file demonstrates the SYNTAX and CONCEPTS.
# The runnable test at the bottom uses regular ExUnit tests to verify the
# same module's behaviour.
#
# In a real Mix project:
#   1. Put module in lib/my_app/math_helper.ex
#   2. Put test in test/my_app/math_helper_test.exs
#   3. Run: mix test

ExUnit.start()

################################################################
# Writing doctestable functions
# The iex> examples in @doc strings become tests when you call `doctest`.

defmodule MathHelper do
  @moduledoc """
  Basic math utilities.

  ## Examples

      iex> MathHelper.add(1, 2)
      3

  """

  @doc """
  Adds two numbers together.

  ## Examples

      iex> MathHelper.add(2, 3)
      5

      iex> MathHelper.add(-1, 1)
      0

      iex> MathHelper.add(0, 0)
      0

  """
  def add(a, b), do: a + b

  @doc """
  Divides a by b. Returns {:error, :division_by_zero} when b is 0.

  ## Examples

      iex> MathHelper.divide(10, 2)
      {:ok, 5.0}

      iex> MathHelper.divide(10, 0)
      {:error, :division_by_zero}

  """
  def divide(_a, 0), do: {:error, :division_by_zero}
  def divide(a, b),  do: {:ok, a / b}

  @doc """
  Checks if a number is prime.

  ## Examples

      iex> MathHelper.prime?(2)
      true

      iex> MathHelper.prime?(4)
      false

      iex> MathHelper.prime?(17)
      true

      iex> MathHelper.prime?(1)
      false

  """
  def prime?(n) when n < 2, do: false
  def prime?(2), do: true
  def prime?(n) when rem(n, 2) == 0, do: false
  def prime?(n) do
    limit = trunc(:math.sqrt(n))
    Enum.all?(3..limit//2, fn i -> rem(n, i) != 0 end)
  end
end

defmodule StringHelper do
  @doc """
  Reverses words in a sentence.

  ## Examples

      iex> StringHelper.reverse_words("hello world")
      "world hello"

      iex> StringHelper.reverse_words("one")
      "one"

      iex> StringHelper.reverse_words("a b c") |> String.split()
      ["c", "b", "a"]

  """
  def reverse_words(sentence) do
    sentence
    |> String.split()
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  @doc """
  Truncates text to max_len characters, adding "..." if truncated.

  ## Examples

      iex> StringHelper.truncate("hello world", 8)
      "hello..."

      iex> StringHelper.truncate("hi", 10)
      "hi"

  """
  def truncate(text, max_len) when byte_size(text) <= max_len, do: text
  def truncate(text, max_len) do
    String.slice(text, 0, max_len - 3) <> "..."
  end
end

defmodule BangHelper do
  @doc """
  Fetches a value from a map or raises KeyError.

  ## Examples

      iex> BangHelper.fetch!(%{a: 1}, :a)
      1

      iex> BangHelper.fetch!(%{}, :missing)
      ** (KeyError) key :missing not found in: %{}

  """
  def fetch!(map, key) do
    Map.fetch!(map, key)
  end
end

################################################################
# In a Mix project, you'd write this in test/:

defmodule DocTestEquivalentTest do
  use ExUnit.Case

  # In a real Mix project with compiled modules, you'd write:
  #   doctest MathHelper
  #   doctest StringHelper
  #   doctest BangHelper
  # and ExUnit automatically extracts and runs all iex> examples.

  # Since we're in a .exs script (no .beam files), we run equivalent
  # manual tests that mirror every example from the @doc strings above:

  # --- MathHelper.add/2 ---
  test "add: 2 + 3 = 5" do
    assert MathHelper.add(2, 3) == 5
  end

  test "add: -1 + 1 = 0" do
    assert MathHelper.add(-1, 1) == 0
  end

  test "add: 0 + 0 = 0" do
    assert MathHelper.add(0, 0) == 0
  end

  # --- MathHelper.divide/2 ---
  test "divide: 10/2 = {:ok, 5.0}" do
    assert MathHelper.divide(10, 2) == {:ok, 5.0}
  end

  test "divide: 10/0 = {:error, :division_by_zero}" do
    assert MathHelper.divide(10, 0) == {:error, :division_by_zero}
  end

  # --- MathHelper.prime?/1 ---
  test "prime?: 2 is prime" do
    assert MathHelper.prime?(2) == true
  end

  test "prime?: 4 is not prime" do
    assert MathHelper.prime?(4) == false
  end

  test "prime?: 17 is prime" do
    assert MathHelper.prime?(17) == true
  end

  test "prime?: 1 is not prime" do
    assert MathHelper.prime?(1) == false
  end

  # --- StringHelper ---
  test "reverse_words: hello world -> world hello" do
    assert StringHelper.reverse_words("hello world") == "world hello"
  end

  test "reverse_words: single word unchanged" do
    assert StringHelper.reverse_words("one") == "one"
  end

  test "truncate: truncates long strings" do
    assert StringHelper.truncate("hello world", 8) == "hello..."
  end

  test "truncate: leaves short strings unchanged" do
    assert StringHelper.truncate("hi", 10) == "hi"
  end

  # --- BangHelper ---
  test "fetch!: found key returns value" do
    assert BangHelper.fetch!(%{a: 1}, :a) == 1
  end

  test "fetch!: missing key raises KeyError" do
    assert_raise KeyError, fn -> BangHelper.fetch!(%{}, :missing) end
  end
end

################################################################
IO.puts("""
DocTest tips:
  - Keep examples short and obvious
  - Test happy path AND error path
  - Document exceptions with **:
      iex> Map.fetch!(%{}, :key)
      ** (KeyError) key :key not found in: %{}
  - Multi-line results: just put them on the next line
  - Variables persist across iex> lines in the same example block:
      iex> x = 1 + 1
      2
      iex> x * 3
      6
  - In a Mix project, use: doctest MyModule
    in your test file to automatically run all iex> examples
""")
