# The Registry module in Elixir provides a way to create
# a key-value store that can be accessed across processes.
# It's especially useful for name registration
# and process discovery in distributed systems.

# The Registry module supports two modes:
# :unique - each key can only be registered once (shown above)
# :duplicate - allows multiple processes to be registered under the same key

####################################################################
## Unique registry
{:ok, _} = Registry.start_link(keys: :unique, name: UniqueRegistry)

# Register a process under a key
Registry.register(UniqueRegistry, "process_1", "some_value")

# Look up a process by key
result = Registry.lookup(UniqueRegistry, "process_1")
IO.inspect(result) # [{#PID<0.94.0>, "some_value"}]

# Count entries
count = Registry.count(UniqueRegistry)
IO.inspect(count) # 1

# Match on specific keys
matches = Registry.match(UniqueRegistry, "process_1", :_)
IO.inspect(matches) # [{#PID<0.94.0>, "some_value"}]

# Unregister a process
Registry.unregister(UniqueRegistry, "process_1")
after_unregister = Registry.lookup(UniqueRegistry, "process_1")
IO.inspect(after_unregister) # []

#################################################################
## Duplicate registry
{:ok, _} = Registry.start_link(keys: :duplicate, name: DuplicateRegistry)

# Register multiple processes under the same key
Registry.register(DuplicateRegistry, "shared_key", "value_1")
spawn(fn -> Registry.register(DuplicateRegistry, "shared_key", "value_2") end)

# Wait briefly for the spawn to complete
Process.sleep(100)

# Look up all processes under a key
lookup_result = Registry.lookup(DuplicateRegistry, "shared_key")
IO.inspect(lookup_result) # Returns list of {pid, value} tuples for all registered processes
