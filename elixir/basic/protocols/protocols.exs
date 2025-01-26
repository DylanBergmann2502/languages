# Define a protocol named Size
defprotocol Size do
  # The Size.t() type is automatically created and represents any type that
  @spec size(Size.t()) :: non_neg_integer()
  def size(data)
end

# Implement for List
defimpl Size, for: List do
  @spec size(list()) :: non_neg_integer()
  def size(list), do: length(list)
end

# Implement for Map
defimpl Size, for: Map do
  @spec size(map()) :: non_neg_integer()
  def size(map), do: map_size(map)
end

# Let's test it
IO.inspect Size.size([1, 2, 3])      # 3
IO.inspect Size.size(%{a: 1, b: 2})  # 2

################################################################
# Define a struct
defmodule User1 do
  defstruct [:name, :age]

  def run() do
    # Test it
    user = %User1{name: "John", age: 30}
    IO.inspect Size.size(user)  # 2
  end
end

# Implement Size protocol for User1 struct
defimpl Size, for: User1 do
  @spec size(User1.t()) :: non_neg_integer()
  def size(%User1{} = user) do
    Map.from_struct(user) |> map_size()
  end
end

defmodule User2 do
  defstruct [:name, :age, :job]

  # When implementing a protocol for a struct,
  # the :for option can be omitted if the defimpl/3 call
  # is inside the module that defines the struct:
  defimpl Size do
    @spec size(User2.t()) :: non_neg_integer()
    def size(%User2{} = user) do
      Map.from_struct(user) |> map_size()
    end
  end

  def run() do
    # Test it
    user = %User2{name: "John", age: 30, job: "Tech guy"}
    IO.inspect Size.size(user)  # 3
  end
end

User1.run()
User2.run()

###################################################################
# Protocols can also be implemented for multiple types at once:
defprotocol Reversible do
  def reverse(term)
end

defimpl Reversible, for: [Map, List] do
  def reverse(term), do: Enum.reverse(term)
end
