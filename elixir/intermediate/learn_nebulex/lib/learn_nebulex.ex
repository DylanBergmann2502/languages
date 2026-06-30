defmodule LearnNebulex do
  @moduledoc """
  Nebulex v3.0 — multi-level distributed caching toolkit for Elixir.

  Nebulex abstracts over multiple cache backends with a single unified API.
  The headline feature: multi-level caches — L1 local (in-process ETS) +
  L2 distributed (partitioned across nodes) — all behind one module.

  Nebulex vs Cachex:
    Cachex   — single-node ETS cache, feature-rich, simple
    Nebulex  — multi-node, multi-level, adapter-based, production clustering

  Adapters (built-in + community):
    Nebulex.Adapters.Local       — generational ETS (nebulex_local package)
    Nebulex.Adapters.Partitioned — hash-partitioned across cluster nodes
    Nebulex.Adapters.Replicated  — push-replicated to all nodes
    Nebulex.Adapters.Coherent    — local cache + distributed invalidation
    Nebulex.Adapters.Multilevel  — L1 + L2 + ... hierarchy
    Nebulex.Adapters.Nil         — disables caching (useful in tests)

  deps:
    {:nebulex,       "~> 3.0"}
    {:nebulex_local, "~> 3.0"}   # for Local adapter
    {:decorator,     "~> 1.4"}   # optional: declarative caching macros
    {:telemetry,     "~> 1.0"}   # optional: stats
  """

  def run do
    IO.puts("\n=== Nebulex: Multi-Level Distributed Cache ===\n")

    start_caches()
    basic_crud()
    ttl_operations()
    read_through()
    bulk_operations()
    transactions()
    stream_and_count()
    decorators_pattern()
    multilevel_concept()
    stats_demo()
  end

  # -----------------------------------------------------------------------
  # 1. Start caches
  # -----------------------------------------------------------------------
  defp start_caches do
    IO.puts("--- Starting Caches ---")

    # Simplest: start a local cache directly (no supervision tree needed for demo)
    {:ok, _} = LearnNebulex.LocalCache.start_link()
    IO.puts("LocalCache started")

    # In production — define in your app module and add to supervision tree:
    # children = [LearnNebulex.LocalCache]
    # Supervisor.start_link(children, strategy: :one_for_one)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Basic CRUD
  # -----------------------------------------------------------------------
  defp basic_crud do
    IO.puts("--- Basic CRUD ---")

    alias LearnNebulex.LocalCache, as: Cache

    # put/3 — unconditional write
    {:ok, true} = Cache.put("user:1", %{name: "Alice", age: 30})
    IO.puts("put: ok")

    # get/2 — returns {:ok, value} or {:ok, nil} on miss
    {:ok, user} = Cache.get("user:1")
    IO.puts("get: #{inspect(user)}")

    # get/3 — with default value on miss
    {:ok, val} = Cache.get("missing", "default_value")
    IO.puts("get (miss): #{inspect(val)}")

    # fetch/2 — returns {:ok, value} or {:error, %Nebulex.KeyError{}} on miss
    case Cache.fetch("user:1") do
      {:ok, v}    -> IO.puts("fetch hit: #{inspect(v)}")
      {:error, _} -> IO.puts("fetch miss")
    end

    # has_key?/2
    {:ok, exists} = Cache.has_key?("user:1")
    IO.puts("has_key?: #{exists}")

    # put_new/3 — only if key doesn't exist
    {:ok, inserted} = Cache.put_new("user:1", %{name: "Bob"})
    IO.puts("put_new (key exists): inserted=#{inserted}")

    {:ok, inserted2} = Cache.put_new("user:2", %{name: "Bob"})
    IO.puts("put_new (new key):    inserted=#{inserted2}")

    # replace/3 — only if key exists
    {:ok, replaced} = Cache.replace("user:2", %{name: "Bob Updated"})
    IO.puts("replace: replaced=#{replaced}")

    # take/2 — fetch and delete atomically
    {:ok, taken} = Cache.take("user:2")
    IO.puts("take: #{inspect(taken)}")
    {:ok, after_take} = Cache.get("user:2")
    IO.puts("after take: #{inspect(after_take)}")

    # delete/2
    {:ok, _} = Cache.put("temp", "value")
    {:ok, true} = Cache.delete("temp")
    IO.puts("delete: ok")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. TTL operations
  # -----------------------------------------------------------------------
  defp ttl_operations do
    IO.puts("--- TTL Operations ---")

    alias LearnNebulex.LocalCache, as: Cache

    # put with TTL (milliseconds)
    {:ok, true} = Cache.put("session:abc", %{user_id: 1},
      ttl: :timer.seconds(60))
    IO.puts("put with TTL: 60s")

    # ttl/2 — remaining TTL in milliseconds
    {:ok, remaining} = Cache.ttl("session:abc")
    IO.puts("ttl remaining: ~#{div(remaining, 1000)}s")

    # expire/3 — set/update TTL on existing key
    {:ok, updated} = Cache.expire("session:abc", :timer.seconds(120))
    IO.puts("expire updated: #{updated}")

    {:ok, new_remaining} = Cache.ttl("session:abc")
    IO.puts("new ttl: ~#{div(new_remaining, 1000)}s")

    # touch/2 — reset TTL to the entry's original TTL (LRU-style)
    {:ok, touched} = Cache.touch("session:abc")
    IO.puts("touch: #{touched}")

    # Key with no TTL returns :infinity
    {:ok, _} = Cache.put("permanent", "value")
    {:ok, inf} = Cache.ttl("permanent")
    IO.puts("ttl of permanent key: #{inspect(inf)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Read-through: get_or_store / fetch_or_store
  # -----------------------------------------------------------------------
  defp read_through do
    IO.puts("--- Read-Through (get_or_store / fetch_or_store) ---")

    alias LearnNebulex.LocalCache, as: Cache

    call_count = :counters.new(1, [])

    loader = fn ->
      :counters.add(call_count, 1, 1)
      IO.puts("  [loader] fetching from DB...")
      %{id: 42, name: "Alice", email: "alice@example.com"}
    end

    # get_or_store/3 — caches ANY return value (even nil/errors)
    {:ok, user1} = Cache.get_or_store("user:42", loader)
    IO.puts("First call:  #{inspect(user1["name"] || user1.name)}")

    {:ok, user2} = Cache.get_or_store("user:42", loader)
    IO.puts("Second call: #{inspect(user2["name"] || user2.name)} (loader not called again)")
    IO.puts("Loader called #{:counters.get(call_count, 1)} time(s)")

    # fetch_or_store/3 — only caches {:ok, value}, not errors
    # Use when your loader can fail and you don't want to cache failures
    {:ok, result} = Cache.fetch_or_store("computed:99", fn ->
      {:ok, 42 * 99}
    end)
    IO.puts("fetch_or_store: #{inspect(result)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Bulk operations
  # -----------------------------------------------------------------------
  defp bulk_operations do
    IO.puts("--- Bulk Operations ---")

    alias LearnNebulex.LocalCache, as: Cache

    # put_all/2 — write multiple entries in one call
    entries = %{
      "product:1" => %{name: "Widget", price: 9.99},
      "product:2" => %{name: "Gadget", price: 19.99},
      "product:3" => %{name: "Doohickey", price: 4.99}
    }
    {:ok, true} = Cache.put_all(entries)
    IO.puts("put_all: #{map_size(entries)} entries")

    # put_new_all/2 — atomic: inserts ALL or NONE (if any key exists)
    new_entries = %{"product:4" => %{name: "Thingamajig", price: 2.99}}
    {:ok, all_inserted} = Cache.put_new_all(new_entries)
    IO.puts("put_new_all: inserted=#{all_inserted}")

    # get_all/1 — fetch all matching entries
    {:ok, all} = Cache.get_all()
    IO.puts("get_all count: #{map_size(all)}")

    # get_all with key filter
    {:ok, products} = Cache.get_all(in: Map.keys(entries))
    IO.puts("get_all by keys: #{map_size(products)}")

    # count_all/1
    {:ok, count} = Cache.count_all()
    IO.puts("count_all: #{count}")

    # delete_all/1
    {:ok, deleted} = Cache.delete_all(in: ["product:1", "product:2"])
    IO.puts("delete_all (2 keys): #{deleted}")

    {:ok, count2} = Cache.count_all()
    IO.puts("count after delete: #{count2}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Transactions
  # -----------------------------------------------------------------------
  defp transactions do
    IO.puts("--- Transactions ---")

    alias LearnNebulex.LocalCache, as: Cache

    {:ok, _} = Cache.put("balance:alice", 1000)
    {:ok, _} = Cache.put("balance:bob",   500)

    # transaction/2 — atomic read-modify-write
    {:ok, result} = Cache.transaction(fn ->
      {:ok, alice} = Cache.get("balance:alice")
      {:ok, bob}   = Cache.get("balance:bob")

      amount = 200
      Cache.put("balance:alice", alice - amount)
      Cache.put("balance:bob",   bob + amount)

      {:transferred, amount}
    end, keys: ["balance:alice", "balance:bob"])

    IO.puts("Transaction result: #{inspect(result)}")

    {:ok, alice} = Cache.get("balance:alice")
    {:ok, bob}   = Cache.get("balance:bob")
    IO.puts("Alice: #{alice}, Bob: #{bob}")

    # in_transaction?/0
    Cache.transaction(fn ->
      {:ok, in_tx} = Cache.in_transaction?()
      IO.puts("in_transaction?: #{in_tx}")
    end)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 7. Stream and count
  # -----------------------------------------------------------------------
  defp stream_and_count do
    IO.puts("--- Stream ---")

    alias LearnNebulex.LocalCache, as: Cache

    # Put some entries with a known prefix
    for i <- 1..5 do
      Cache.put("item:#{i}", i * 10)
    end

    # stream/1 — lazy enumerable over all entries
    {:ok, stream} = Cache.stream()
    entries = Enum.to_list(stream)
    IO.puts("stream total entries: #{length(entries)}")

    # stream with select: :key
    {:ok, key_stream} = Cache.stream(select: :key)
    keys = Enum.take(key_stream, 3)
    IO.puts("stream keys (first 3): #{inspect(keys)}")

    # stream with select: :value
    {:ok, val_stream} = Cache.stream(select: :value)
    vals = Enum.filter(val_stream, &is_integer/1) |> Enum.sort()
    IO.puts("stream integer values: #{inspect(vals)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 8. Decorators — declarative caching via @decorate
  # -----------------------------------------------------------------------
  defp decorators_pattern do
    IO.puts("--- Decorators Pattern ---")

    # Decorators let you add caching to functions without changing their body.
    # Requires: use Nebulex.Caching in your module + {:decorator, "~> 1.4"} dep

    result = WeatherService.get_temperature("London")
    IO.puts("First call:  #{result}")

    result2 = WeatherService.get_temperature("London")
    IO.puts("Second call: #{result2} (cached — loader not called again)")

    # Evict
    WeatherService.clear_temperature("London")
    result3 = WeatherService.get_temperature("London")
    IO.puts("After evict: #{result3} (loader called again)")

    IO.puts("""

  Decorator reference:
    @decorate cacheable(cache: MyCache, key: id, opts: [ttl: :timer.hours(1)])
    def get_user(id), do: DB.fetch_user(id)

    @decorate cache_put(cache: MyCache, key: user.id)
    def update_user(%User{} = user), do: DB.update(user)

    @decorate cache_evict(cache: MyCache, key: user.id)
    def delete_user(%User{} = user), do: DB.delete(user)

    @decorate cache_evict(cache: MyCache, all_entries: true, before_invocation: true)
    def purge_all(), do: :ok
    """)
  end

  # -----------------------------------------------------------------------
  # 9. Multi-level cache concept
  # -----------------------------------------------------------------------
  defp multilevel_concept do
    IO.puts("--- Multi-Level Cache Concept ---")

    # Multi-level caches compose L1 (local) + L2 (distributed)
    # L1 hit: <1ms  — in-process ETS, no network
    # L2 hit: ~1ms  — same node, partitioned ETS
    # Miss:   DB    — actual data source

    IO.puts("""
  How it works:
    get("key")
      → check L1 (local ETS)   → hit: return immediately (<1ms)
      → check L2 (distributed) → hit: populate L1, return (~1ms)
      → miss: load from DB, populate L1+L2, return

    Topology config:
      defmodule MyApp.Cache do
        use Nebulex.Cache,
          otp_app: :my_app,
          adapter: Nebulex.Adapters.Multilevel

        defmodule L1 do
          use Nebulex.Cache,
            otp_app: :my_app,
            adapter: Nebulex.Adapters.Local
        end

        defmodule L2 do
          use Nebulex.Cache,
            otp_app: :my_app,
            adapter: Nebulex.Adapters.Partitioned
        end
      end

      # config/config.exs
      config :my_app, MyApp.Cache,
        levels: [
          {MyApp.Cache.L1, [gc_interval: :timer.hours(12), max_size: 100_000]},
          {MyApp.Cache.L2, [partitions: 8]}
        ]
    """)
  end

  # -----------------------------------------------------------------------
  # 10. Stats via info/1
  # -----------------------------------------------------------------------
  defp stats_demo do
    IO.puts("--- Stats ---")

    alias LearnNebulex.LocalCache, as: Cache

    # info/1 — query cache metadata
    {:ok, stats} = Cache.info(:stats)
    IO.puts("Stats: #{inspect(stats)}")

    {:ok, memory} = Cache.info(:memory)
    IO.puts("Memory: #{inspect(memory)}")

    # Full info
    {:ok, all} = Cache.info(:all)
    IO.puts("Info keys: #{inspect(Map.keys(all))}")

    IO.puts("")
  end
end

# ============================================================
# Cache module — Local adapter (single-node ETS)
# ============================================================
defmodule LearnNebulex.LocalCache do
  use Nebulex.Cache,
    otp_app: :learn_nebulex,
    adapter: Nebulex.Adapters.Local
end

# ============================================================
# WeatherService — demonstrates @cacheable / @cache_evict decorators
# ============================================================
defmodule WeatherService do
  use Nebulex.Caching, cache: LearnNebulex.LocalCache

  @decorate cacheable(key: city, opts: [ttl: :timer.minutes(5)])
  def get_temperature(city) do
    IO.puts("  [WeatherService] fetching temp for #{city}...")
    # Simulate API call
    "#{:rand.uniform(30)}°C"
  end

  @decorate cache_evict(key: city)
  def clear_temperature(city) do
    IO.puts("  [WeatherService] evicting #{city} from cache")
    :ok
  end
end
