# An Agent is like a simple state container that runs as a separate process
# It's used to maintain mutable state in an immutable language
# You can read from and update the state through the Agent process

# Start an Agent with initial state of 0
{:ok, counter} = Agent.start_link(fn -> 0 end)

# Get the current value
current = Agent.get(counter, fn state -> state end)
IO.inspect(current)  # 0

# Update the value
Agent.update(counter, fn state -> state + 1 end)
new_value = Agent.get(counter, fn state -> state end)
IO.inspect(new_value)  # 1

# You can also use Agent.get_and_update to perform both operations
old_value = Agent.get_and_update(counter, fn state ->
  {state, state + 1}
end)
IO.inspect(old_value)  # 1

# Check the final state
final = Agent.get(counter, fn state -> state end)
IO.inspect(final)  # 2

################################################################
# Start an Agent with an empty map
{:ok, store} = Agent.start_link(fn -> %{} end)

# Add some key-value pairs
Agent.update(store, fn map -> Map.put(map, :name, "Alice") end)
Agent.update(store, fn map -> Map.put(map, :age, 30) end)

# Get a value
name = Agent.get(store, fn map -> Map.get(map, :name) end)
IO.inspect(name)  # "Alice"

# Get the entire store
state = Agent.get(store, fn map -> map end)
IO.inspect(state)  # %{name: "Alice", age: 30}
