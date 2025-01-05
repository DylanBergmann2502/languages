# Elixir is a dynamically typed language, which means it doesn't provide compile-time type checks.
# Still, type specifications can be useful because they:
# - Serve as documentation.
# - Can be used by static analysis tools like `Dialyzer` to find possible bugs.

@spec longer_than?(String.t(), non_neg_integer()) :: boolean()
def longer_than?(string, length), do: String.length(string) > length

type ::
      # Basic Types
      any()                     # the top type, the set of all terms
      | none()                  # the bottom type, contains no terms
      | atom()
      | map()                   # any map
      | pid()                   # process identifier
      | port()                  # port identifier
      | reference()
      | tuple()                 # tuple of any size

                                ## Numbers
      | float()
      | integer()
      | neg_integer()           # ..., -3, -2, -1
      | non_neg_integer()       # 0, 1, 2, 3, ...
      | pos_integer()           # 1, 2, 3, ...

                                                                      ## Lists
      | list(type)                                                    # proper list ([]-terminated)
      | nonempty_list(type)                                           # non-empty proper list
      | maybe_improper_list(content_type, termination_type)           # proper or improper list
      | nonempty_improper_list(content_type, termination_type)        # improper list
      | nonempty_maybe_improper_list(content_type, termination_type)  # non-empty proper or improper list

      # Literals
                                      ## Atoms
      | :atom                         # atoms: :foo, :bar, ...
      | true | false | nil            # special atom literals

                                      ## (Anonymous) Functions
      | (-> type)                     # zero-arity, returns type
      | (type1, type2 -> type)        # two-arity, returns type
      | (... -> type)                 # any arity, returns type

                                      ## Integers
      | 1                             # integer
      | 1..10                         # integer from 1 to 10

                                      ## Lists
      | [type]                        # list with any number of type elements
      | []                            # empty list
      | [...]                         # shorthand for nonempty_list(any())
      | [type, ...]                   # shorthand for nonempty_list(type)
      | [key: value_type]             # keyword list with optional key :key of value_type

                                              ## Maps
      | %{}                                   # empty map
      | %{key: value_type}                    # map with required key :key of value_type
      | %{key_type => value_type}             # map with required pairs of key_type and value_type
      | %{required(key_type) => value_type}   # map with required pairs of key_type and value_type
      | %{optional(key_type) => value_type}   # map with optional pairs of key_type and value_type
      | %SomeStruct{}                         # struct with all fields of any type
      | %SomeStruct{key: value_type}          # struct with required key :key of value_type

                                      ## Tuples
      | {}                            # empty tuple
      | {:ok, type}                   # two-element tuple with an atom and any type

      # Built-in Types
      | boolean()
      | charlist()
      | binary()
      | function()
      | iodata()
      | iolist()
      | keyword()
      | map()
      | pid()
      | port()
      | reference()
      | term()
      | tuple()
      | number()
      | struct()

      # Remote Types
      | String.t()
      | Enum.t()
      | Range.t()
      | Map.t()
      | List.t()
      | Tuple.t()

################################################################
## Composing a spec/custom type
# @type - defines a public type
# @typep - defines a private type
# @opaque - defines a public type whose structure is private

@type option :: {:name, String.t} | {:max, pos_integer} | {:min, pos_integer}
@type options :: [option()]

@type color :: {hue :: integer, saturation :: integer, lightness :: integer}
@spec to_hex(color()) :: String.t()


##############################################################
## String.t() vs binary() vs string()
# String.t() is the correct type to use for Elixir strings, which are UTF-8 encoded binaries.
# Technically, String.t() and binary() are equivalent, but String.t() is more descriptive
# While string() is of Erlang strings, i.e. Elixir charlist(), avoid using string()
