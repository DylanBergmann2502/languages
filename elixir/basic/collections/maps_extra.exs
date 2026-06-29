# Map module functions beyond the basics covered in maps.exs.

################################################################
# Map.merge/3 - merge with a resolver function for conflicts

map1 = %{a: 1, b: 2, c: 3}
map2 = %{b: 20, c: 30, d: 40}

# Without resolver: map2 values win on conflict
IO.inspect(Map.merge(map1, map2))
# %{a: 1, b: 20, c: 30, d: 40}

# With resolver function: you decide what to do with conflicts
# The function receives (key, value_from_map1, value_from_map2)
merged = Map.merge(map1, map2, fn _key, v1, v2 -> v1 + v2 end)
IO.inspect(merged)
# %{a: 1, b: 22, c: 33, d: 40}

# Sum conflicting values only if both are integers
merged2 = Map.merge(map1, map2, fn _k, v1, v2 when is_integer(v1) and is_integer(v2) ->
  v1 + v2
end)
IO.inspect(merged2) # %{a: 1, b: 22, c: 33, d: 40}

################################################################
# Map.intersect/2 and Map.intersect/3 (Elixir 1.15+)
# Returns only the keys present in BOTH maps.

a = %{a: 1, b: 2, c: 3}
b = %{b: 20, c: 30, d: 40}

# Without resolver: second map's values win
IO.inspect(Map.intersect(a, b))
# %{b: 20, c: 30}

# With resolver: combine the values
IO.inspect(Map.intersect(a, b, fn _k, v1, v2 -> v1 + v2 end))
# %{b: 22, c: 33}

################################################################
# Map.filter/2 (Elixir 1.13+)
# Keep only key-value pairs where the function returns true.

scores = %{alice: 85, bob: 42, carol: 91, dave: 55}

passing = Map.filter(scores, fn {_name, score} -> score >= 60 end)
IO.inspect(passing) # %{alice: 85, carol: 91}

################################################################
# Map.reject/2 (Elixir 1.13+)
# Opposite of Map.filter - keep pairs where function returns false.

failing = Map.reject(scores, fn {_name, score} -> score >= 60 end)
IO.inspect(failing) # %{bob: 42, dave: 55}

################################################################
# Map.from_keys/2 (Elixir 1.14+)
# Build a map from a list of keys with a default value.

keys = [:a, :b, :c]
IO.inspect(Map.from_keys(keys, 0))  # %{a: 0, b: 0, c: 0}
IO.inspect(Map.from_keys(keys, nil)) # %{a: nil, b: nil, c: nil}

# Useful for initializing counters or flags
letters = String.graphemes("hello")
IO.inspect(Map.from_keys(letters, 0))
# %{"e" => 0, "h" => 0, "l" => 0, "o" => 0}

################################################################
# Map.split_with/2 (Elixir 1.15+)
# Like Enum.split_with but returns two maps.

{pass, fail} = Map.split_with(scores, fn {_k, v} -> v >= 60 end)
IO.inspect(pass) # %{alice: 85, carol: 91}
IO.inspect(fail) # %{bob: 42, dave: 55}

################################################################
# Map.new/2 - transform a map's values while keeping keys
# (Map.map/2 was introduced in 1.17 but deprecated in 1.20 in favour of Map.new/2)

doubled = Map.new(scores, fn {k, v} -> {k, v * 2} end)
IO.inspect(doubled) # %{alice: 170, bob: 84, carol: 182, dave: 110}

# Compare with Enum.map which gives a list of tuples:
IO.inspect(Enum.map(scores, fn {k, v} -> {k, v * 2} end))
# [alice: 170, bob: 84, ...] - a keyword list, not a map

################################################################
# Map.equal?/2
# Structural equality (same as ==, but explicit intent)

IO.inspect(Map.equal?(%{a: 1}, %{a: 1})) # true
IO.inspect(Map.equal?(%{a: 1}, %{a: 2})) # false

################################################################
# Map.split/2 - split into two maps by key list

{taken, rest} = Map.split(%{a: 1, b: 2, c: 3}, [:a, :c])
IO.inspect(taken) # %{a: 1, c: 3}
IO.inspect(rest)  # %{b: 2}

# Missing keys are silently ignored
{taken2, rest2} = Map.split(%{a: 1, b: 2}, [:a, :z])
IO.inspect(taken2) # %{a: 1}
IO.inspect(rest2)  # %{b: 2}

################################################################
# Map.take/2 vs Map.split/2

# Map.take just returns the matching keys (no remainder)
IO.inspect(Map.take(%{a: 1, b: 2, c: 3}, [:a, :b])) # %{a: 1, b: 2}

# Map.drop/2 - remove specific keys
IO.inspect(Map.drop(%{a: 1, b: 2, c: 3}, [:a, :b])) # %{c: 3}

################################################################
# Practical: deep merge two nested maps

defmodule DeepMerge do
  def merge(m1, m2) do
    Map.merge(m1, m2, fn
      _key, v1, v2 when is_map(v1) and is_map(v2) -> merge(v1, v2)
      _key, _v1, v2 -> v2
    end)
  end
end

config1 = %{db: %{host: "localhost", port: 5432}, log: :info}
config2 = %{db: %{port: 5433, name: "prod"}, timeout: 30}

IO.inspect(DeepMerge.merge(config1, config2))
# %{db: %{host: "localhost", port: 5433, name: "prod"}, log: :info, timeout: 30}
