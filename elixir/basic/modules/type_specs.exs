# Elixir is a dynamically typed language, which means it doesn't provide compile-time type checks.
# Still, type specifications can be useful because they:
# - Serve as documentation.
# - Can be used by static analysis tools like `Dialyzer` to find possible bugs.

defmodule SpecExample do
  @spec longer_than?(String.t(), non_neg_integer()) :: boolean()
  def longer_than?(string, length), do: String.length(string) > length
end

IO.puts SpecExample.longer_than?("hello", 3) # true
IO.puts SpecExample.longer_than?("hi", 3)    # false

# Type reference (pseudo-code comments showing available types — not executable Elixir):
# type ::
#       # Basic Types
#       any()                     # the top type, the set of all terms
#       | none()                  # the bottom type, contains no terms
#       | atom()
#       | map()                   # any map
#       | pid()                   # process identifier
#       | port()                  # port identifier
#       | reference()
#       | tuple()                 # tuple of any size
#
#                                 ## Numbers
#       | float()
#       | integer()
#       | neg_integer()           # ..., -3, -2, -1
#       | non_neg_integer()       # 0, 1, 2, 3, ...
#       | pos_integer()           # 1, 2, 3, ...
#
#                                 ## Lists
#       | list(type)                                                    # proper list
#       | nonempty_list(type)                                           # non-empty proper list
#       | maybe_improper_list(content_type, termination_type)
#
#       # Literals
#       | :atom                         # atoms: :foo, :bar, ...
#       | true | false | nil            # special atom literals
#       | (-> type)                     # zero-arity, returns type
#       | (type1, type2 -> type)        # two-arity, returns type
#       | 1                             # integer literal
#       | 1..10                         # integer range
#       | [type]                        # list with any number of type elements
#       | %{}                           # empty map
#       | %{key: value_type}            # map with required key :key
#       | %SomeStruct{}                 # struct with all fields of any type
#       | {}                            # empty tuple
#       | {:ok, type}                   # two-element tuple

################################################################
## Composing a spec/custom type
# @type - defines a public type
# @typep - defines a private type
# @opaque - defines a public type whose structure is private

defmodule Colors do
  @type hsl :: {hue :: integer, saturation :: integer, lightness :: integer}

  @spec to_hex(hsl()) :: String.t()
  def to_hex({h, s, l}) do
    "hsl(#{h}, #{s}%, #{l}%)"
  end
end

IO.puts Colors.to_hex({120, 100, 50}) # "hsl(120, 100%, 50%)"

##############################################################
## String.t() vs binary() vs string()
# String.t() is the correct type to use for Elixir strings, which are UTF-8 encoded binaries.
# Technically, String.t() and binary() are equivalent, but String.t() is more descriptive.
# While string() is of Erlang strings, i.e. Elixir charlist(), avoid using string().
