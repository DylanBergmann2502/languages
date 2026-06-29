# Elixir strings are UTF-8 encoded binaries.
# A binary is a sequence of bits divisible by 8.
# A bitstring is the more general form - any sequence of bits.

################################################################
# Bitstrings
# The <<>> syntax constructs bitstrings.
# Each segment defaults to 8 bits (one byte).
bits = <<1, 2, 3>>
IO.inspect(bits)           # <<1, 2, 3>>
IO.inspect(byte_size(bits)) # 3
IO.inspect(bit_size(bits))  # 24

# Segments can specify their size in bits explicitly.
# This is a 4-bit value followed by a 4-bit value - together one byte.
nibbles = <<0::4, 7::4>>
IO.inspect(nibbles)           # <<7>>
IO.inspect(bit_size(nibbles)) # 8

# A bitstring that is NOT byte-aligned is not a binary.
odd_bits = <<1::1, 0::1, 1::1>>
IO.inspect(is_bitstring(odd_bits)) # true
IO.inspect(is_binary(odd_bits))    # false - not byte-aligned

################################################################
# Binaries
# A binary is a bitstring where bit_size is divisible by 8.
bin = <<72, 101, 108, 108, 111>>  # "Hello" in ASCII
IO.inspect(bin)          # "Hello" - Elixir prints printable binaries as strings
IO.inspect(is_binary(bin)) # true

# Elixir strings ARE binaries
str = "hello"
IO.inspect(is_binary(str))  # true
IO.inspect(byte_size(str))  # 5

# Unicode characters take more than one byte
IO.inspect(byte_size("hellö"))   # 6  - ö is 2 bytes in UTF-8
IO.inspect(String.length("hellö")) # 5 - but 5 characters

################################################################
# Binary pattern matching - one of Elixir's most powerful features

# Match specific bytes
<<first, second, rest::binary>> = "hello"
IO.puts(first)   # 104 (code point for 'h')
IO.puts(second)  # 101 (code point for 'e')
IO.inspect(rest) # "llo"

# The ::binary type matches zero or more bytes (must be last)
<<head::binary-size(3), tail::binary>> = "hello"
IO.inspect(head) # "hel"
IO.inspect(tail) # "lo"

################################################################
# Segment types
# integer (default), float, binary, bitstring, utf8, utf16, utf32

# Float segments: 32-bit or 64-bit
<<value::float-32>> = <<64, 72, 0, 0>>
IO.inspect(value) # 3.125

# Encode a 32-bit float
encoded = <<3.125::float-32>>
IO.inspect(encoded) # <<64, 72, 0, 0>>

# UTF-8 codepoint extraction
<<codepoint::utf8, _rest::binary>> = "élixir"
IO.puts(codepoint)          # 233 (é's Unicode codepoint)
IO.puts(<<codepoint::utf8>>) # "é"

################################################################
# Practical example: parsing a binary protocol
# Imagine a simple packet: <<version::8, length::16, payload::binary>>

defmodule Packet do
  def encode(payload) when is_binary(payload) do
    len = byte_size(payload)
    <<1::8, len::16, payload::binary>>
  end

  def decode(<<version::8, len::16, payload::binary-size(len), _rest::binary>>) do
    {:ok, version, payload}
  end
  def decode(_), do: {:error, :invalid_packet}
end

packet = Packet.encode("hello")
IO.inspect(packet) # <<1, 0, 5, 104, 101, 108, 108, 111>>

{:ok, version, payload} = Packet.decode(packet)
IO.puts("Version: #{version}, Payload: #{payload}") # Version: 1, Payload: hello

################################################################
# Binary concatenation and splitting

# <> concatenates binaries
full = "hello" <> " " <> "world"
IO.inspect(full) # "hello world"

# Binary.part/3 - extract a segment (zero-indexed)
IO.inspect(binary_part("hello world", 6, 5)) # "world"

# :binary Erlang module - efficient binary operations
IO.inspect(:binary.split("a,b,c", ","))            # ["a", "b,c"]
IO.inspect(:binary.split("a,b,c", ",", [:global]))  # ["a", "b", "c"]
IO.inspect(:binary.replace("hello world", "world", "elixir")) # "hello elixir"

# Match position of a pattern
IO.inspect(:binary.match("hello world", "world"))   # {6, 5} = {start, length}
IO.inspect(:binary.match("hello world", "missing")) # :nomatch

################################################################
# Inspecting binary internals

# Convert binary to list of bytes
IO.inspect(:binary.bin_to_list("ABC")) # [65, 66, 67]

# Convert list of bytes to binary
IO.inspect(:binary.list_to_bin([65, 66, 67])) # "ABC"

# Count occurrences of a substring (using :binary.matches which returns all positions)
matches = :binary.matches("banana", "a")
IO.inspect(length(matches)) # 3 (number of "a" occurrences)
