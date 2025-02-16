defmodule LearnJason do
  # Define a custom struct with Jason.Encoder implementation
  defmodule User do
    @derive Jason.Encoder
    defstruct [:name, :email]
  end

  def run do
    # Basic encoding
    map = %{name: "John", age: 30, hobbies: ["reading", "coding"]}
    encoded = Jason.encode!(map)
    IO.puts("Encoded JSON:")
    IO.inspect(encoded)  # {"name":"John","age":30,"hobbies":["reading","coding"]}

    # Basic decoding
    decoded = Jason.decode!(encoded)
    IO.puts("\nDecoded JSON:")
    IO.inspect(decoded)  # %{"name" => "John", "age" => 30, "hobbies" => ["reading", "coding"]}

    # Working with atoms
    atom_keys = Jason.decode!(encoded, keys: :atoms)
    IO.puts("\nDecoded with atom keys:")
    IO.inspect(atom_keys)  # %{name: "John", age: 30, hobbies: ["reading", "coding"]}

    # Pretty printing
    pretty = Jason.encode!(map, pretty: true)
    IO.puts("\nPretty printed JSON:")
    IO.puts(pretty)
    # {
    #   "name": "John",
    #   "age": 30,
    #   "hobbies": [
    #   "hobbies": [
    #     "reading",
    #     "coding"
    #   ]
    # }

    # Handling custom structs
    user = %User{name: "Alice", email: "alice@example.com"}
    encoded_user = Jason.encode!(user)
    IO.puts("\nEncoded struct:")
    IO.inspect(encoded_user)  # {"name":"Alice","email":"alice@example.com"}
  end
end
