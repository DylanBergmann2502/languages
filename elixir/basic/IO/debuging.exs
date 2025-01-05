# IO.inspect(item, opts \\ []) returns the item argument passed to it
# without affecting the behavior of the original code
[1, 2, 3]
|> IO.inspect(label: "Before map")
|> Enum.map(&(&1 * 2))
|> IO.inspect(label: "After map")

################################################################
# dbg/2 is similar to IO.inspect/2 but specifically tailored for debugging.
# Basic dbg
x = 42
dbg(x)
# [debuging.exs:12: (file)]
# x #=> 42

# dbg in a pipeline
[1, 2, 3]
|> dbg()
|> Enum.map(&(&1 * 2))
|> dbg()
# [debuging.exs:16: (file)]
# value #=> [1, 2, 3]

# [debuging.exs:18: (file)]
# [1, 2, 3] #=> [1, 2, 3]
# |> dbg() #=> [1, 2, 3]
# |> Enum.map(&(&1 * 2)) #=> [2, 4, 6]

# dbg with expressions
user = %{name: "John", age: 30}
dbg(user.name)
# [debuging.exs:22: (file)]
# user.name #=> "John"

################################################################
# Using binding() to see all variables in current scope
x = 1
y = "hello"
IO.inspect(binding())  # [user: %{name: "John", age: 30}, x: 1, y: "hello"]

defmodule MyModule do
  # Combining binding() with inspect
  def example do
    a = 42
    b = "world"

    # See all variables in current scope
    IO.inspect(binding(), label: "Current variables")
  end
end

MyModule.example() # Current variables: [a: 42, b: "world"]
