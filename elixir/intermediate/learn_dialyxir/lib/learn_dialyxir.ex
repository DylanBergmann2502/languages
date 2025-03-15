defmodule LearnDialyxir do
  @moduledoc """
  A module to learn about Dialyxir and Dialyzer for static analysis.
  """

  @typedoc "A user structure with name and age"
  @type user :: %{name: String.t(), age: non_neg_integer()}

  @spec run() :: :ok
  def run do
    IO.puts("Learning Dialyxir - Type Checking in Elixir")

    # Example with correct type
    good_user = create_user("Alice", 30)
    IO.inspect(good_user, label: "Good user")

    # Example with wrong type - this would be caught by Dialyzer
    # Dialyzer would warn that this doesn't match the expected return type
    bad_result = add_function("not a number", 5)
    IO.inspect(bad_result, label: "Bad calculation result")

    # Example of incorrect function usage - this would be caught by Dialyzer
    # The following would cause a dialyzer warning because the argument types don't match
    problematic_user = create_user(123, "wrong type")
    IO.inspect(problematic_user, label: "Problematic user")

    :ok
  end

  @spec create_user(String.t(), non_neg_integer()) :: user()
  def create_user(name, age) when is_binary(name) and is_integer(age) and age >= 0 do
    %{name: name, age: age}
  end

  @spec add_function(integer(), integer()) :: integer()
  def add_function(a, b) when is_integer(a) and is_integer(b) do
    a + b
  end

  @spec greet(user()) :: String.t()
  def greet(%{name: name, age: age}) do
    "Hello, #{name}! You are #{age} years old."
  end
end
