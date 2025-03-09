defmodule Sigils do
  # Custom sigil example
  defmodule MySigils do
    # Custom sigils can be defined by creating a function named `sigil_<sigil name>`
    # Define a custom sigil that reverses text
    def sigil_u(string, modifiers) do
      result = String.reverse(string)

      # Process the result based on modifiers
      cond do
        ?u in modifiers -> String.upcase(result)
        ?l in modifiers -> String.downcase(result)
        ?t in modifiers -> String.capitalize(result)
        true -> result
      end
    end
  end

  def run do
    # Sigils in Elixir are a special syntax for working with textual representations.
    # They're a powerful feature of Elixir that makes certain types of
    # text processing and data creation more readable and expressive.

    # A sigil in Elixir starts with a tilde (~) followed by a letter
    # that indicates what kind of data you're creating, and then
    # the content between delimiters.
    # The delimiters can be various pairs like: (), [], {}, <>, "", '', or //.

    # The commonly used built-in sigils are:
    # ~s - String with interpolation
    # ~S - Raw string without interpolation
    # ~c - Character list with interpolation
    # ~C - Raw character list
    # ~r - Regular expression
    # ~w - Word list
    # ~D - Date
    # ~T - Time
    # ~N - Naive datetime

    # You can also add modifiers at the end of sigils. For example, with ~w:
    # ~w(words)a - Creates a list of atoms
    # ~w(words)c - Creates a list of character lists
    # ~w(words)s - Creates a list of strings (default)

    # Basic sigil examples
    string_sigil = ~s(This is a string sigil)
    IO.puts(string_sigil) # This is a string sigil

    # String sigil with interpolation
    name = "Elixir"
    interpolated = ~s(Hello #{name}!)
    IO.puts(interpolated) # Hello Elixir!

    # String sigil without interpolation (notice the uppercase S)
    raw_string = ~S(No interpolation for #{name})
    IO.puts(raw_string) # No interpolation for #{name}

    # Character list sigil
    char_list = ~c(abc)
    IO.inspect(char_list) # 'abc'

    # Regular expression sigil
    regex = ~r/hello/i  # with 'i' modifier for case insensitive
    IO.puts("HELLO" =~ regex) # true

    # Word list sigil
    words = ~w(elixir erlang beam)
    IO.inspect(words) # ["elixir", "erlang", "beam"]

    # Word list with atom conversion
    atoms = ~w(elixir erlang beam)a
    IO.inspect(atoms) # [:elixir, :erlang, :beam]

    # Date sigil (requires Date module)
    date = ~D[2024-03-09]
    IO.inspect(date) # ~D[2024-03-09]

    # Time sigil
    time = ~T[14:30:00]
    IO.inspect(time) # ~T[14:30:00]

    #######################################################################
    # Use the custom sigil with modifiers
    import MySigils

    reversed = ~u(Hello World)
    IO.puts(reversed) # dlroW olleH

    # With uppercase modifier
    uppercase_reversed = ~u(Hello World)u
    IO.puts(uppercase_reversed) # DLROW OLLEH

    # With lowercase modifier
    lowercase_reversed = ~u(Hello World)l
    IO.puts(lowercase_reversed) # dlrow olleh

    # With title case modifier
    titlecase_reversed = ~u(Hello World)t
    IO.puts(titlecase_reversed) # Dlrow olleh

    # Multiple modifiers (only the first applicable one is used in our implementation)
    mixed_modifiers = ~u(Hello World)ul
    IO.puts(mixed_modifiers) # DLROW OLLEH
  end
end

Sigils.run()
