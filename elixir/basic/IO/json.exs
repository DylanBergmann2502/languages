## Encoding
# Elixir integers/floats → JSON numbers
# true/false → JSON booleans
# nil → JSON null
# binaries/atoms → JSON strings
# lists → JSON arrays
# maps → JSON objects

## Decoding
# JSON numbers → Elixir integers or floats
# JSON strings → Elixir binaries (not atoms)
# JSON objects → Elixir maps with binary keys
# JSON null → Elixir nil

# Basic encoding example
data = %{name: "John", age: 30, languages: ["Elixir", "Python"]}
encoded = JSON.encode!(data)
IO.inspect(encoded)  # "{\"name\":\"John\",\"age\":30,\"languages\":[\"Elixir\",\"Python\"]}"

# Basic decoding example
decoded = JSON.decode!(encoded)
IO.inspect(decoded)  # %{"name" => "John", "age" => 30, "languages" => ["Elixir", "Python"]}

# Safe decoding with pattern matching
case JSON.decode("[1, 2, 3]") do
  {:ok, result} -> IO.inspect(result)      # [1, 2, 3]
  {:error, reason} -> IO.inspect(reason)
end

# Working with iodata (more efficient for I/O operations)
iodata = JSON.encode_to_iodata!([1, 2, 3])
IO.inspect(IO.iodata_to_binary(iodata))  # "[1,2,3]"

# Invalid JSON handling
case JSON.decode("invalid json") do
  {:ok, _} -> IO.puts("Valid JSON")
  {:error, reason} -> IO.inspect(reason)  # Will show the error reason
end

defmodule User do
  defstruct name: "", age: 0

  # Structs aren't automatically encoded,
  # you can make your structs encodable by
  # implementing the JSON.Encoder protocol.
  defimpl JSON.Encoder do
    def encode(%User{name: name, age: age}, _encoder) do
      # Convert struct to map first
      encoded = %{name: name, age: age}
      # Then encode the map
      JSON.encode!(encoded)
    end
  end

  def run do
    # Let's try it
    user = %User{name: "Alice", age: 25}
    encoded = JSON.encode!(user)
    IO.inspect(encoded)  # "{\"name\":\"Alice\",\"age\":25}"
  end
end

User.run()
