# Module attributes may be used like "constants"
# which are evaluated at compile-time.
# However, they don't strictly behave like constants
# because they can be overwritten by redefining them in the module:

defmodule OverwriteDemo do
  @standard_message "Hello, World!"
  @standard_message "Overwritten!"

  def message(), do: @standard_message
end

IO.puts OverwriteDemo.message() # "Overwritten!"

################################################################
## Module attributes in Elixir serve three purposes:
# 1. as module and function annotations

defmodule Math do
  @moduledoc """
  Provides math-related functions.

  ## Examples

      iex> Math.sum(1, 2)
      3

  """

  @doc """
  Calculates the sum of two numbers.
  """
  def sum(a, b), do: a + b
end

# 2. as temporary module storage to be used during compilation

defmodule MyServer do
  # Do not add a newline between the attribute and its value,
  # otherwise Elixir will assume you are reading the value, rather than setting it.
  @service URI.parse("https://example.com")
  IO.inspect @service
end

# This code shows how @service is inlined at compile time:
#
#   defmodule MyApp.Status do
#     @service URI.parse("https://example.com")
#     def status(_email) do
#       SomeHttpClient.get(@service)  # @service is evaluated at compile time...
#     end
#   end
#
# ...and compiles down to:
#
#   defmodule MyApp.Status do
#     def status(_email) do
#       SomeHttpClient.get(%URI{host: "example.com", port: 443, scheme: "https", ...})
#     end
#   end

# instead of reading the attribute directly, do this
defmodule Example do
  @example "hello"

  def some_function, do: String.upcase(example())
  def another_function, do: String.reverse(example())
  defp example, do: @example

  # Instead of this
  # def some_function, do: String.upcase(@example)
  # def another_function, do: String.reverse(@example)
end

IO.puts Example.some_function()    # "HELLO"
IO.puts Example.another_function() # "olleh"

# 3. as compile-time constants
# but don't use them that way, use functions instead
defmodule AppConfig do
  # Instead of this, use functions instead
  # @hours_in_a_day 24

  def hours_in_a_day(), do: 24
  def system_config(), do: %{timezone: "Etc/UTC", locale: "pt-BR"}
end

IO.puts AppConfig.hours_in_a_day()      # 24
IO.inspect AppConfig.system_config()    # %{locale: "pt-BR", timezone: "Etc/UTC"}
