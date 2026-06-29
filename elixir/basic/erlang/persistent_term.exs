# :persistent_term is an Erlang module (OTP 22+) for application-wide,
# read-heavy, write-rarely global constants.

# Key properties vs alternatives:
#   :persistent_term - fastest reads (no process hop, no ETS lookup), slow writes
#   ETS              - fast reads (microseconds), fast writes, concurrent
#   Agent            - slowest reads (process message-passing), easy API

# The "trick": persistent_term values are stored in a global literal pool.
# When you read one, it's a direct memory reference - NO copying.
# When you write one, ALL processes must update their instruction cache
# (expensive GC-like sweep of all processes). Hence: read-heavy only.

################################################################
# Basic usage

# Put a value - O(n) where n is the number of live processes
:persistent_term.put(:app_config, %{
  db_url: "postgres://localhost/prod",
  max_connections: 10,
  debug: false
})

# Get a value - O(1), very fast, no process boundary
config = :persistent_term.get(:app_config)
IO.inspect(config)

# Get with default (Erlang term or default if missing)
IO.inspect(:persistent_term.get(:missing_key, :not_found)) # :not_found

# Erase a value - also triggers the costly GC sweep
:persistent_term.erase(:app_config)
IO.inspect(:persistent_term.get(:app_config, :gone)) # :gone

################################################################
# Typical use cases

# 1. Application config loaded at startup
:persistent_term.put({MyApp, :config}, %{
  env: :prod,
  secret_key: "s3cr3t",
  feature_flags: %{new_ui: true, dark_mode: false}
})

# Fast access anywhere in the app - no ETS table, no Agent
config2 = :persistent_term.get({MyApp, :config})
IO.inspect(config2.env) # :prod

# 2. Compiled regex patterns (compiled once, used everywhere)
:persistent_term.put({MyApp, :email_regex}, ~r/^[^\s@]+@[^\s@]+\.[^\s@]+$/)
email_re = :persistent_term.get({MyApp, :email_regex})
IO.inspect(Regex.match?(email_re, "user@example.com")) # true
IO.inspect(Regex.match?(email_re, "not-an-email"))     # false

# 3. Module lookup tables / routing tables
:persistent_term.put({MyApp, :handlers}, %{
  "/api/users" => UserHandler,
  "/api/posts" => PostHandler
})

################################################################
# List all stored terms
all = :persistent_term.get()
IO.puts("Stored persistent terms: #{length(all)}")
# Returns a list of {key, value} tuples

################################################################
# Info about memory usage
info = :persistent_term.info()
IO.inspect(info)
# %{count: N, memory: bytes}

################################################################
# Comparing the three options

defmodule BenchmarkConcepts do
  def read_comparison do
    IO.puts("""
    Read performance (fastest to slowest):

    1. :persistent_term  - direct literal, no copy, ~1ns
       :persistent_term.get(key)

    2. ETS               - hash table lookup, may copy, ~1-5µs
       :ets.lookup(table, key)

    3. Agent             - inter-process message, ~10-50µs
       Agent.get(agent, & &1)

    Write performance (fastest to slowest):

    1. ETS               - hash table insert, ~1-5µs
       :ets.insert(table, {key, value})

    2. Agent             - single process serialized, ~10-50µs
       Agent.update(agent, fn _ -> new_value end)

    3. :persistent_term  - GC sweep of ALL processes, ms to seconds
       :persistent_term.put(key, value)

    Rule of thumb:
      Use :persistent_term for things that NEVER change after app startup.
      Use ETS for things that change but are read frequently.
      Use Agent for simple mutable state with low contention.
    """)
  end
end

BenchmarkConcepts.read_comparison()

################################################################
# Cleanup
:persistent_term.erase({MyApp, :config})
:persistent_term.erase({MyApp, :email_regex})
:persistent_term.erase({MyApp, :handlers})
