# Advanced String module topics beyond the basics in strings.exs.

################################################################
# graphemes vs codepoints vs bytes - they are DIFFERENT

# A grapheme is what a human sees as one character (may be multiple codepoints).
# A codepoint is a Unicode scalar value.
# A byte is a single 8-bit unit.

# Example with a combining character: "é" can be ONE codepoint or TWO
# Precomposed: U+00E9 (é as one codepoint)
precomposed = "é"
# Decomposed: U+0065 (e) + U+0301 (combining accent)
decomposed = "é"

IO.inspect(precomposed)                    # "é"
IO.inspect(decomposed)                     # "é" (looks the same!)
IO.inspect(precomposed == decomposed)      # false! different bytes

IO.inspect(String.length(precomposed))     # 1
IO.inspect(String.length(decomposed))      # 1 (grapheme-aware)

IO.inspect(byte_size(precomposed))         # 2 (é = 2 UTF-8 bytes)
IO.inspect(byte_size(decomposed))          # 3 (e + combining = 1 + 2 bytes)

IO.inspect(String.graphemes(precomposed))  # ["é"]
IO.inspect(String.graphemes(decomposed))   # ["é"] (treats e+accent as one grapheme)

IO.inspect(String.codepoints(precomposed)) # ["é"]          (1 codepoint)
IO.inspect(String.codepoints(decomposed))  # ["e", "́"] (2 codepoints)

# String.graphemes is the right way to get individual graphemes
IO.inspect(String.graphemes("café"))       # ["c", "a", "f", "é"]
# Note: String.split("café", "") adds empty strings at the edges - use graphemes instead
IO.inspect(String.split("café", "", trim: true)) # ["c", "a", "f", "é"] - same as graphemes

################################################################
# String.jaro_distance/2 - fuzzy string similarity

# Returns a float 0.0 (no similarity) to 1.0 (identical)
IO.inspect(String.jaro_distance("martha", "marhta"))   # ~0.944 (transposition)
IO.inspect(String.jaro_distance("jellyfish", "smellyfish")) # ~0.896
IO.inspect(String.jaro_distance("hello", "hello"))     # 1.0
IO.inspect(String.jaro_distance("hello", "world"))     # ~0.467
IO.inspect(String.jaro_distance("foo", ""))            # 0.0

# Useful for spell-checking, name matching, deduplication
defmodule FuzzySearch do
  def closest(query, candidates, threshold \\ 0.8) do
    candidates
    |> Enum.map(fn c -> {c, String.jaro_distance(query, c)} end)
    |> Enum.filter(fn {_, score} -> score >= threshold end)
    |> Enum.sort_by(fn {_, score} -> score end, :desc)
    |> Enum.map(fn {candidate, _} -> candidate end)
  end
end

cities = ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix"]
IO.inspect(FuzzySearch.closest("Chcago", cities, 0.85))  # ["Chicago"]
IO.inspect(FuzzySearch.closest("New Yrok", cities, 0.85)) # ["New York"]

################################################################
# Binary pattern matching on strings

# Since strings are binaries, you can pattern match at the byte level.

# Match a fixed prefix
<<first_byte, rest::binary>> = "hello"
IO.puts(first_byte) # 104 (h)
IO.inspect(rest)    # "ello"

# Check if a string starts with "http"
starts_with_http = fn
  <<"http", _::binary>> -> true
  _ -> false
end
IO.inspect(starts_with_http.("https://example.com")) # true
IO.inspect(starts_with_http.("ftp://example.com"))   # false

# Parse a simple CSV line at the binary level
defmodule BinaryCSV do
  def parse_first_field(<<char, rest::binary>>, acc) when char != ?, do
    parse_first_field(rest, <<acc::binary, char>>)
  end
  def parse_first_field(<<?,, rest::binary>>, acc), do: {acc, rest}
  def parse_first_field("", acc), do: {acc, ""}

  def first_field(line) do
    {field, _} = parse_first_field(line, "")
    field
  end
end

IO.inspect(BinaryCSV.first_field("alice,30,admin")) # "alice"
IO.inspect(BinaryCSV.first_field("bob,25,user"))    # "bob"

################################################################
# String.normalize/2 - Unicode normalization

# NFC: canonical decomposition then canonical composition (precomposed form)
# NFD: canonical decomposition (fully decomposed)
nfc = String.normalize(decomposed, :nfc)
nfd = String.normalize(precomposed, :nfd)

IO.inspect(nfc == precomposed)             # true - now they're equal
IO.inspect(String.codepoints(nfc))         # ["é"]  (1 codepoint)
IO.inspect(String.codepoints(nfd))         # ["e", "́"] (2 codepoints)

# When comparing user input: normalize first
defmodule TextMatcher do
  def equal?(a, b) do
    String.normalize(a, :nfc) == String.normalize(b, :nfc)
  end
end

IO.inspect(TextMatcher.equal?(precomposed, decomposed)) # true (after normalization)

################################################################
# String.bag_distance/2 (Elixir 1.14+)
# Another string similarity metric (faster than jaro, less accurate)

IO.inspect(String.bag_distance("hello", "hell"))   # 0.8
IO.inspect(String.bag_distance("hello", "hello"))  # 1.0
IO.inspect(String.bag_distance("hello", "world"))  # 0.4

################################################################
# Efficient string building

# Bad: repeated concatenation = O(n^2) copies
# bad = Enum.reduce(1..100, "", fn i, acc -> acc <> "#{i}" end)

# Good: iodata list, flattened once at the end
parts = Enum.map(1..10, fn i -> to_string(i) end)
IO.inspect(IO.iodata_to_binary(parts)) # "12345678910"

# Or just Enum.join
IO.inspect(Enum.join(1..10)) # "12345678910"

################################################################
# String.chunk/2 (Elixir 1.15+)
# Split into groups of consecutive characters sharing a Unicode property.
# :valid     - groups valid vs invalid UTF-8 bytes
# :printable - groups printable vs non-printable codepoints

IO.inspect(String.chunk("hello\0world", :printable))
# ["hello", "\0", "world"]  - separates non-printable \0

# Note: "abc123def456" is all :valid UTF-8 so it comes back as one chunk
IO.inspect(String.chunk("abc123def456", :valid))
# ["abc123def456"] - all valid, so one group

################################################################
# String.Myers.difference not directly available, but
# String.jaro_distance is complemented by these helpers:

# levenshtein (edit distance) via a simple implementation
defmodule Levenshtein do
  def distance(a, b) do
    a_chars = String.graphemes(a)
    b_chars = String.graphemes(b)
    do_distance(a_chars, b_chars)
  end

  defp do_distance([], b), do: length(b)
  defp do_distance(a, []), do: length(a)
  defp do_distance([h | t_a], [h | t_b]), do: do_distance(t_a, t_b)
  defp do_distance([_ | t_a] = a, [_ | t_b] = b) do
    1 + Enum.min([
      do_distance(t_a, b),
      do_distance(a, t_b),
      do_distance(t_a, t_b)
    ])
  end
end

IO.inspect(Levenshtein.distance("kitten", "sitting")) # 3
IO.inspect(Levenshtein.distance("hello", "hello"))    # 0
IO.inspect(Levenshtein.distance("abc", ""))           # 3
