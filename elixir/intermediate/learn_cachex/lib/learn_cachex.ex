defmodule LearnCachex do
  @moduledoc """
  Cachex v4.0 — ETS-backed in-process cache for Elixir.

  Cachex sits on top of ETS (Erlang Term Storage) and adds:
    - TTL / expiration (lazy + interval cleanup)
    - Read-through fetching (fetch/3)
    - Atomic get-and-update, incr/decr
    - Cache warming on startup
    - Stats, transactions, streaming

  It lives in a single OS process — no network, no serialization.
  For multi-node shared caching, combine with Nebulex or a Redis adapter.

  Setup in mix.exs:
    {:cachex, "~> 4.0"}
  """

  import Cachex.Spec

  def run do
    IO.puts("\n=== Cachex: ETS-backed In-Process Cache ===\n")

    start_cache()
    basic_crud()
    ttl_and_expiration()
    read_through()
    atomic_operations()
    bulk_operations()
    streaming()
    stats_demo()
    warming_pattern()
    transactions_demo()
  end

  # -----------------------------------------------------------------------
  # 1. Starting a cache
  # -----------------------------------------------------------------------
  defp start_cache do
    IO.puts("--- Starting a Cache ---")

    # Simplest: named cache, no options
    {:ok, _} = Cachex.start_link(:simple_cache)

    # With expiration: entries expire after 60s by default,
    # cleanup runs every 30s
    {:ok, _} = Cachex.start_link(:timed_cache,
      expiration: expiration(
        default:  :timer.seconds(60),  # default TTL for all keys
        interval: :timer.seconds(30),  # cleanup interval
        lazy:     true                 # also expire on read (default: true)
      )
    )

    # With stats enabled
    {:ok, _} = Cachex.start_link(:stats_cache,
      hooks: [hook(module: Cachex.Stats)]
    )

    # In production — add to your supervision tree:
    IO.puts("""
    defmodule MyApp.Application do
      def start(_type, _args) do
        children = [
          {Cachex, name: :my_cache,
            expiration: expiration(default: :timer.minutes(5), interval: :timer.minutes(1))},
          # ...
        ]
        Supervisor.start_link(children, strategy: :one_for_one)
      end
    end
    """)

    IO.puts("Caches started: :simple_cache, :timed_cache, :stats_cache")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Basic CRUD
  # -----------------------------------------------------------------------
  defp basic_crud do
    IO.puts("--- Basic CRUD ---")

    # put/3,4 — insert or replace
    Cachex.put(:simple_cache, "name", "Alice")
    Cachex.put(:simple_cache, "age",  30)
    Cachex.put(:simple_cache, "data", %{role: :admin, active: true})

    # get/2,3 — returns value or nil
    IO.puts("name: #{inspect Cachex.get(:simple_cache, "name")}")
    IO.puts("missing key: #{inspect Cachex.get(:simple_cache, "missing")}")
    IO.puts("with default: #{inspect Cachex.get(:simple_cache, "missing", "fallback")}")

    # exists?/2 — check without fetching
    IO.puts("exists? name:    #{Cachex.exists?(:simple_cache, "name")}")
    IO.puts("exists? missing: #{Cachex.exists?(:simple_cache, "missing")}")

    # update/3 — overwrite ONLY if key exists (returns false if missing)
    IO.puts("update name: #{Cachex.update(:simple_cache, "name", "Bob")}")
    IO.puts("update missing: #{Cachex.update(:simple_cache, "missing", "x")}")
    IO.puts("name after update: #{inspect Cachex.get(:simple_cache, "name")}")

    # take/2 — get AND delete atomically
    Cachex.put(:simple_cache, "temp", "gone")
    IO.puts("take: #{inspect Cachex.take(:simple_cache, "temp")}")
    IO.puts("after take: #{inspect Cachex.get(:simple_cache, "temp")}")

    # del/2 — delete (always :ok)
    Cachex.del(:simple_cache, "age")
    IO.puts("after del: #{inspect Cachex.get(:simple_cache, "age")}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. TTL and expiration
  # -----------------------------------------------------------------------
  defp ttl_and_expiration do
    IO.puts("--- TTL & Expiration ---")

    # put with per-key TTL (milliseconds)
    Cachex.put(:simple_cache, "session", "tok_abc", expire: :timer.seconds(5))
    Cachex.put(:simple_cache, "token",   "jwt_xyz", expire: :timer.minutes(1))

    # ttl/2 — remaining TTL in milliseconds
    IO.puts("session TTL: ~#{div(Cachex.ttl(:simple_cache, "session") || 0, 1000)}s remaining")
    IO.puts("name TTL (no expiry): #{inspect Cachex.ttl(:simple_cache, "name")}")

    # expire/3 — set or update TTL on existing key
    Cachex.put(:simple_cache, "ephemeral", "value")
    Cachex.expire(:simple_cache, "ephemeral", :timer.seconds(2))
    IO.puts("ephemeral TTL set: #{Cachex.ttl(:simple_cache, "ephemeral")}ms")

    # expire with nil — remove TTL (make permanent)
    Cachex.expire(:simple_cache, "session", nil)
    IO.puts("session TTL after nil expire: #{inspect Cachex.ttl(:simple_cache, "session")}")

    # persist/2 — alias for expire(cache, key, nil)
    Cachex.persist(:simple_cache, "token")
    IO.puts("token TTL after persist: #{inspect Cachex.ttl(:simple_cache, "token")}")

    # refresh/2 — reset TTL to the key's original expiry
    # (useful for sliding-window expiration)
    Cachex.put(:simple_cache, "sliding", "val", expire: :timer.seconds(10))
    Cachex.refresh(:simple_cache, "sliding")
    IO.puts("sliding TTL refreshed to ~#{div(Cachex.ttl(:simple_cache, "sliding") || 0, 1000)}s")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Read-through with fetch/3
  # -----------------------------------------------------------------------
  defp read_through do
    IO.puts("--- Read-Through with fetch/3 ---")

    # fetch/3 — cache miss? run fallback, store result, return it
    # The fallback returns {:commit, value} to cache or {:ignore, value} to skip
    user_loader = fn user_id ->
      IO.puts("  [DB] Loading user #{user_id}...")
      # Simulate a DB call
      {:commit, %{id: user_id, name: "User #{user_id}", loaded_at: System.monotonic_time()}}
    end

    # First call — cache miss, runs loader
    result1 = Cachex.fetch(:simple_cache, "user:1", user_loader)
    IO.puts("First fetch: #{inspect(result1)}")

    # Second call — cache hit, loader NOT called
    result2 = Cachex.fetch(:simple_cache, "user:1", user_loader)
    IO.puts("Second fetch (from cache): same loaded_at? #{elem(result1, 1).loaded_at == elem(result2, 1).loaded_at}")

    # fetch with TTL on commit
    Cachex.fetch(:simple_cache, "config:timeout", fn _key ->
      {:commit, 5000, expire: :timer.minutes(10)}
    end)
    IO.puts("Config fetched and cached for 10m")

    # {:ignore, value} — return value but don't cache it
    Cachex.fetch(:simple_cache, "volatile", fn _key ->
      {:ignore, "computed but not stored"}
    end)
    IO.puts("Volatile exists after ignore? #{Cachex.exists?(:simple_cache, "volatile")}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Atomic operations
  # -----------------------------------------------------------------------
  defp atomic_operations do
    IO.puts("--- Atomic Operations ---")

    # incr/decr — atomic numeric increment/decrement
    Cachex.put(:simple_cache, "visits", 0)
    Cachex.incr(:simple_cache, "visits")        # → 1
    Cachex.incr(:simple_cache, "visits")        # → 2
    Cachex.incr(:simple_cache, "visits", 5)     # → 7
    IO.puts("visits after incr: #{Cachex.get(:simple_cache, "visits")}")

    Cachex.decr(:simple_cache, "visits", 3)     # → 4
    IO.puts("visits after decr: #{Cachex.get(:simple_cache, "visits")}")

    # incr on missing key (uses default)
    Cachex.incr(:simple_cache, "new_counter", 1, default: 100)
    IO.puts("new_counter (started at 100): #{Cachex.get(:simple_cache, "new_counter")}")

    # get_and_update/3 — atomic read-modify-write
    Cachex.put(:simple_cache, "tags", ["elixir"])
    result = Cachex.get_and_update(:simple_cache, "tags", fn tags ->
      {:commit, ["otp" | tags]}
    end)
    IO.puts("get_and_update result: #{inspect result}")
    IO.puts("tags now: #{inspect Cachex.get(:simple_cache, "tags")}")

    # {:ignore, value} — read but don't write
    Cachex.get_and_update(:simple_cache, "tags", fn tags ->
      {:ignore, Enum.sort(tags)}  # returns sorted but doesn't store
    end)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Bulk operations
  # -----------------------------------------------------------------------
  defp bulk_operations do
    IO.puts("--- Bulk Operations ---")

    # put_many/2 — batch insert
    Cachex.put_many(:simple_cache, [
      {"city:1", "New York"},
      {"city:2", "London"},
      {"city:3", "Tokyo"}
    ])

    # put_many with TTL for all entries
    Cachex.put_many(:simple_cache, [
      {"tmp:a", 1},
      {"tmp:b", 2}
    ], expire: :timer.seconds(30))

    IO.puts("size after put_many: #{Cachex.size(:simple_cache)}")

    # size/1 — total entries (including expired, not yet cleaned up)
    # size/1 with expired: false — only live entries
    IO.puts("size (live only): #{Cachex.size(:simple_cache, expired: false)}")

    # keys/1 — all keys as a list
    all_keys = Cachex.keys(:simple_cache)
    IO.puts("key count: #{length(all_keys)}")

    # empty?/1
    IO.puts("empty? #{Cachex.empty?(:simple_cache)}")

    # purge/1 — remove all expired entries immediately
    purged = Cachex.purge(:simple_cache)
    IO.puts("purged #{purged} expired entries")

    # clear/1 — remove ALL entries, returns count
    count = Cachex.clear(:simple_cache)
    IO.puts("cleared #{count} entries")
    IO.puts("empty after clear? #{Cachex.empty?(:simple_cache)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 7. Streaming and querying
  # -----------------------------------------------------------------------
  defp streaming do
    IO.puts("--- Streaming & Querying ---")

    # Re-populate
    Enum.each(1..5, fn i ->
      Cachex.put(:simple_cache, "item:#{i}", %{id: i, val: i * 10})
    end)

    # stream/1 — lazy stream of all entries
    # Each element: {:entry, key, touched_at, ttl, value}
    all = :simple_cache |> Cachex.stream() |> Enum.to_list()
    IO.puts("stream entry count: #{length(all)}")
    IO.puts("first entry structure: #{all |> hd() |> elem(0)}")

    # stream with key-only output
    keys_query = Cachex.Query.build(output: :key)
    keys = :simple_cache |> Cachex.stream(keys_query) |> Enum.to_list()
    IO.puts("keys via stream: #{inspect Enum.sort(keys)}")

    # stream with {key, value} tuples
    kv_query = Cachex.Query.build(output: {:key, :value})
    pairs = :simple_cache |> Cachex.stream(kv_query) |> Enum.to_list()
    IO.puts("kv pairs count: #{length(pairs)}")

    # Use stream with Enum for filtering
    high_vals =
      :simple_cache
      |> Cachex.stream(kv_query)
      |> Stream.filter(fn {_k, v} -> v.val >= 30 end)
      |> Enum.to_list()
    IO.puts("items with val >= 30: #{length(high_vals)}")

    Cachex.clear(:simple_cache)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 8. Stats
  # -----------------------------------------------------------------------
  defp stats_demo do
    IO.puts("--- Stats ---")

    Cachex.put(:stats_cache, "a", 1)
    Cachex.put(:stats_cache, "b", 2)
    Cachex.get(:stats_cache, "a")      # hit
    Cachex.get(:stats_cache, "a")      # hit
    Cachex.get(:stats_cache, "miss")   # miss
    Cachex.del(:stats_cache, "b")

    stats = Cachex.stats(:stats_cache)
    IO.puts("hits:      #{stats.hits}")
    IO.puts("misses:    #{stats.misses}")
    IO.puts("hit_rate:  #{stats.hit_rate}%")
    IO.puts("writes:    #{stats.writes}")
    IO.puts("evictions: #{stats.evictions}")

    # Without the stats hook:
    IO.puts("no-stats cache: #{inspect Cachex.stats(:simple_cache)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 9. Cache warming
  # -----------------------------------------------------------------------
  defp warming_pattern do
    IO.puts("--- Cache Warming ---")

    IO.puts("""
    # A warmer pre-populates the cache on startup and on a schedule.
    # Implement the Cachex.Warmer behaviour:

    defmodule MyApp.ProductWarmer do
      use Cachex.Warmer

      @impl true
      def execute(_state) do
        products = MyApp.Repo.all(MyApp.Product)

        pairs = Enum.map(products, fn p ->
          {"product:\#{p.id}", p}
        end)

        # {:ok, pairs}              — cache all, no TTL
        # {:ok, pairs, expire: ms}  — cache all, with TTL
        # :ignore                   — skip this cycle
        {:ok, pairs, expire: :timer.minutes(5)}
      end
    end

    # Attach at startup:
    {Cachex, name: :products,
      warmers: [
        warmer(
          module:   MyApp.ProductWarmer,
          required: true,             # block startup until warm
          interval: :timer.minutes(5) # re-warm every 5 minutes
        )
      ]
    }

    # Manually trigger warming:
    Cachex.warm(:products)              # async
    Cachex.warm(:products, wait: true)  # block until done
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 10. Transactions
  # -----------------------------------------------------------------------
  defp transactions_demo do
    IO.puts("--- Transactions ---")

    # Re-populate
    Cachex.put(:simple_cache, "balance:alice", 1000)
    Cachex.put(:simple_cache, "balance:bob",   500)

    # transaction/3 — acquire row locks, execute atomically
    result = Cachex.transaction(:simple_cache, ["balance:alice", "balance:bob"], fn worker ->
      alice = Cachex.get(worker, "balance:alice")
      bob   = Cachex.get(worker, "balance:bob")

      amount = 200
      Cachex.put(worker, "balance:alice", alice - amount)
      Cachex.put(worker, "balance:bob",   bob + amount)

      {alice - amount, bob + amount}
    end)

    IO.puts("Transfer result: #{inspect result}")
    IO.puts("Alice: #{Cachex.get(:simple_cache, "balance:alice")}")
    IO.puts("Bob:   #{Cachex.get(:simple_cache, "balance:bob")}")

    # execute/2 — like transaction but without locking (cheaper, non-atomic)
    Cachex.execute(:simple_cache, fn worker ->
      Cachex.get(worker, "balance:alice")
    end)

    IO.puts("")
  end
end
