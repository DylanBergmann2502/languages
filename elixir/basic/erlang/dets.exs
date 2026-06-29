# DETS = Disk Erlang Term Storage
# Same API as ETS but persists to disk.
# Trade-off: slower than ETS (disk I/O) but survives process/node restarts.
# Tables are files on disk, not in-memory.

# Important limitations vs ETS:
#   - Only :set and :bag (no :ordered_set, no :duplicate_bag)
#   - No :private access mode
#   - Slower: disk I/O vs memory
#   - Max file size is 2GB by default (configurable)
#   - You must close the table explicitly or changes may be lost

################################################################
# Opening and closing a DETS table

# DETS tables are identified by atoms, like ETS, but backed by a file.
dets_file = ~c"dets_example.dets"  # file path as charlist

{:ok, ref} = :dets.open_file(:my_dets, [{:file, dets_file}, {:type, :set}])
IO.inspect(ref)  # :my_dets

################################################################
# Basic CRUD - same API as ETS

:dets.insert(:my_dets, {:user1, "Alice", 30})
:dets.insert(:my_dets, {:user2, "Bob",   25})

IO.inspect(:dets.lookup(:my_dets, :user1))  # [{:user1, "Alice", 30}]
IO.inspect(:dets.lookup(:my_dets, :missing)) # []

# Update by reinserting (overwrites in :set mode)
:dets.insert(:my_dets, {:user1, "Alice", 31})
IO.inspect(:dets.lookup(:my_dets, :user1))  # [{:user1, "Alice", 31}]

# Delete a record
:dets.delete(:my_dets, :user2)
IO.inspect(:dets.lookup(:my_dets, :user2))  # []

################################################################
# Iterating over all records

IO.puts("All records:")
:dets.traverse(:my_dets, fn record ->
  IO.inspect(record)
  :continue
end)

# Or fold over all records
total = :dets.foldl(fn {_k, _name, age}, acc -> acc + age end, 0, :my_dets)
IO.inspect(total) # 31

################################################################
# :dets.match and :dets.select - same patterns as ETS

:dets.insert(:my_dets, {:user3, "Carol", 28})
:dets.insert(:my_dets, {:user4, "Dave",  35})

# Match all names
names = :dets.match(:my_dets, {:"$1", :"$2", :_})
IO.inspect(names) # [[:user1, "Alice"], [:user3, "Carol"], [:user4, "Dave"]]

# Select adults over 30
over_30 = :dets.select(:my_dets, [
  {{:"$1", :"$2", :"$3"}, [{:>, :"$3", 30}], [{{:"$1", :"$2"}}]}
])
IO.inspect(over_30) # [user1: "Alice", user4: "Dave"]  (order not guaranteed)

################################################################
# Info about the table

info = :dets.info(:my_dets)
IO.puts("File: #{info[:filename]}")
IO.puts("Size: #{info[:size]} records")
IO.puts("Type: #{info[:type]}")

################################################################
# Syncing and closing

# Sync writes outstanding changes to disk (without closing)
:dets.sync(:my_dets)

# Must close explicitly - if you crash without closing, DETS repairs on next open
:dets.close(:my_dets)
IO.puts("Table closed")

################################################################
# Reopening shows persisted data

{:ok, _} = :dets.open_file(:my_dets, [{:file, dets_file}, {:type, :set}])
IO.inspect(:dets.lookup(:my_dets, :user3)) # [{:user3, "Carol", 28}] - still there!
:dets.close(:my_dets)

################################################################
# Cleanup the file
File.rm(List.to_string(dets_file))
IO.puts("DETS file deleted")

################################################################
# ETS vs DETS decision guide

IO.puts("""
ETS vs DETS:
  ETS:
    - In-memory only (lost on process/node crash)
    - Very fast (microsecond lookups)
    - No size limit except RAM
    - Good for: caches, session state, rate limiters

  DETS:
    - Persists to disk (survives restarts)
    - Slower (disk I/O on writes)
    - Max ~2GB per table
    - Good for: small persistent datasets, config, counters across restarts

  In practice, production Elixir apps rarely use DETS directly.
  They use Mnesia (built on DETS), or an external DB (Postgres, Redis).
""")
