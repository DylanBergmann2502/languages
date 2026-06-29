# ETS table types beyond :set (which you covered in ets.exs).
# There are four table types:
#   :set          - unique keys, unordered (covered in ets.exs)
#   :ordered_set  - unique keys, ordered by key (Erlang term order)
#   :bag          - duplicate key-value pairs allowed, but not identical tuples
#   :duplicate_bag - truly identical tuples allowed

################################################################
# :ordered_set - keys are kept in sorted order

table = :ets.new(:ordered, [:ordered_set, :public, :named_table])

:ets.insert(:ordered, {5, "five"})
:ets.insert(:ordered, {1, "one"})
:ets.insert(:ordered, {3, "three"})
:ets.insert(:ordered, {2, "two"})
:ets.insert(:ordered, {4, "four"})

# :first and :last give the smallest/largest key
IO.inspect(:ets.first(:ordered))  # 1
IO.inspect(:ets.last(:ordered))   # 5

# :next/:prev for ordered traversal
IO.inspect(:ets.next(:ordered, 2)) # 3
IO.inspect(:ets.prev(:ordered, 4)) # 3

# Iterate in order
defmodule ETSIterator do
  def to_list(table) do
    to_list(table, :ets.first(table), [])
  end

  defp to_list(_table, :"$end_of_table", acc), do: Enum.reverse(acc)
  defp to_list(table, key, acc) do
    [{^key, value}] = :ets.lookup(table, key)
    to_list(table, :ets.next(table, key), [{key, value} | acc])
  end
end

IO.inspect(ETSIterator.to_list(:ordered))
# [{1, "one"}, {2, "two"}, {3, "three"}, {4, "four"}, {5, "five"}]

# Range query: get entries with keys between 2 and 4
entries = :ets.select(:ordered, [{{:"$1", :"$2"}, [{:>=, :"$1", 2}, {:"=<", :"$1", 4}], [{{:"$1", :"$2"}}]}])
IO.inspect(entries) # [{2, "two"}, {3, "three"}, {4, "four"}]

:ets.delete(:ordered)

################################################################
# :bag - multiple values per key, but identical tuples are deduplicated

bag = :ets.new(:bag_table, [:bag, :public, :named_table])

:ets.insert(:bag_table, {"alice", :admin})
:ets.insert(:bag_table, {"alice", :user})
:ets.insert(:bag_table, {"alice", :admin})  # duplicate tuple - ignored
:ets.insert(:bag_table, {"bob",   :user})

# Both alice roles are stored (but not the duplicate :admin)
IO.inspect(:ets.lookup(:bag_table, "alice"))
# [{"alice", :admin}, {"alice", :user}]

IO.inspect(:ets.lookup(:bag_table, "bob"))
# [{"bob", :user}]

IO.inspect(:ets.select(:bag_table, [{{:"$1", :"$2"}, [], [{{:"$1", :"$2"}}]}]))
# [{"alice", :admin}, {"alice", :user}, {"bob", :user}]

:ets.delete(:bag_table)

################################################################
# :duplicate_bag - truly allows identical tuples

dup_bag = :ets.new(:dup_bag_table, [:duplicate_bag, :public, :named_table])

:ets.insert(:dup_bag_table, {"event", :click})
:ets.insert(:dup_bag_table, {"event", :click})  # allowed - identical tuple stored twice
:ets.insert(:dup_bag_table, {"event", :hover})

IO.inspect(:ets.lookup(:dup_bag_table, "event"))
# [{"event", :click}, {"event", :click}, {"event", :hover}]

:ets.delete(:dup_bag_table)

################################################################
# Concurrency: ETS access modes

# :public    - any process can read and write
# :protected - any process can read, only owner can write (default)
# :private   - only the owner process can read or write

protected_table = :ets.new(:prot, [:set, :protected, :named_table])
:ets.insert(:prot, {:key, :value})

# Reads work from any process
task = Task.async(fn ->
  :ets.lookup(:prot, :key)
end)
IO.inspect(Task.await(task)) # [{:key, :value}]

# Writes from another process would raise:
# task2 = Task.async(fn -> :ets.insert(:prot, {:other, :val}) end)
# Task.await(task2)  # => ** (ArgumentError) argument error

:ets.delete(:prot)

################################################################
# ETS as a cache: read-heavy, write-rarely

defmodule Cache do
  @table :cache

  def start do
    :ets.new(@table, [:set, :public, :named_table, read_concurrency: true])
  end

  def get(key), do: :ets.lookup_element(@table, key, 2, nil)

  def put(key, value, ttl_ms) do
    expires_at = System.monotonic_time(:millisecond) + ttl_ms
    :ets.insert(@table, {key, value, expires_at})
  end

  def get_with_ttl(key) do
    case :ets.lookup(@table, key) do
      [{_key, value, expires_at}] ->
        if System.monotonic_time(:millisecond) < expires_at do
          {:ok, value}
        else
          :ets.delete(@table, key)
          :miss
        end
      [] -> :miss
    end
  end
end

Cache.start()
Cache.put(:user_1, %{name: "Alice"}, 5000)
IO.inspect(Cache.get_with_ttl(:user_1))  # {:ok, %{name: "Alice"}}
IO.inspect(Cache.get_with_ttl(:missing)) # :miss
:ets.delete(:cache)

################################################################
# :ets table options summary

IO.puts("""
Table types:
  :set          - unique keys, O(1) lookup, unordered
  :ordered_set  - unique keys, O(log n) lookup, sorted by key
  :bag          - duplicate key allowed, but not identical tuples
  :duplicate_bag - identical tuples allowed

Access modes:
  :public    - any process reads and writes
  :protected - any process reads, only owner writes (default)
  :private   - only owner reads and writes

Concurrency hints:
  read_concurrency: true   - optimise for concurrent reads
  write_concurrency: true  - optimise for concurrent writes (auto: true for auto)
""")
