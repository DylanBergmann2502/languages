defmodule LearnKhepri do
  @moduledoc """
  Khepri v0.18 — tree-structured distributed database built on Ra (Raft).

  Khepri is a pre-1.0 RabbitMQ project: a replicated, persistent tree store
  for configuration and metadata. Think ZooKeeper, but Erlang-native and
  built on Ra (Raft consensus) instead of ZAB.

  Key concepts:
    - Tree of nodes (like a filesystem path)
    - Each node has data (any Erlang term) and optional child nodes
    - Paths: [atom, <<"binary">>] or "/:atom/:binary" strings
    - Transactions: run inside a callback (no IO allowed inside!)
    - Conditions: path patterns with guards (exists?, compare, etc.)

  Khepri is Erlang — use :khepri atoms and charlist paths.

  Setup in mix.exs:
    {:khepri, "~> 0.18"}

  In application/0:
    extra_applications: [:khepri]

  WARNING: Khepri 0.18 is pre-1.0. APIs may change before 1.0 release.
  """

  require Logger

  def run do
    IO.puts("\n=== Khepri: Distributed Tree Store ===\n")

    setup()
    basic_operations()
    path_syntax()
    queries_and_conditions()
    transactions()
    tree_traversal()
    teardown()
  end

  # -----------------------------------------------------------------------
  # Setup
  # -----------------------------------------------------------------------
  defp setup do
    IO.puts("--- Setup ---")

    # Start Khepri (starts a local single-node store by default)
    # In production: :khepri.start("data_dir", ClusterName)
    {:ok, store_id} = :khepri.start()
    Process.put(:store_id, store_id)
    IO.puts("Khepri started, store_id: #{inspect(store_id)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 1. Basic CRUD
  # -----------------------------------------------------------------------
  defp basic_operations do
    IO.puts("--- Basic Operations ---")
    store = Process.get(:store_id)

    # put/3 — create or replace a node with data
    # Path is a list of atoms/binaries
    :ok = :khepri.put(store, [:config, :database, :host], "localhost")
    :ok = :khepri.put(store, [:config, :database, :port], 5432)
    :ok = :khepri.put(store, [:config, :app, :name],     "my_app")

    # get/2 — fetch a node's data
    {:ok, host} = :khepri.get(store, [:config, :database, :host])
    IO.puts("DB host: #{host}")

    # get_or/3 — with default
    port = :khepri.get_or(store, [:config, :database, :port], 3306)
    IO.puts("DB port: #{port}")

    # exists?/2 — check node existence
    IO.puts("config/database exists? #{:khepri.exists?(store, [:config, :database])}")
    IO.puts("config/redis exists?    #{:khepri.exists?(store, [:config, :redis])}")

    # delete/2 — remove a node (and its children!)
    :ok = :khepri.put(store, [:tmp, :scratch], "temporary")
    :ok = :khepri.delete(store, [:tmp])
    IO.puts("tmp exists after delete? #{:khepri.exists?(store, [:tmp])}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Path syntax
  # -----------------------------------------------------------------------
  defp path_syntax do
    IO.puts("--- Path Syntax ---")
    store = Process.get(:store_id)

    IO.puts("""
    # Paths are lists of atoms or binaries (NOT Elixir strings):

    # Good paths:
    [:config, :database, :host]                   # list of atoms
    [:users, <<"user_42">>]                        # binary key
    [:apps, :my_app, :settings]

    # String path syntax (converted internally):
    # "/:config/:database/:host"

    # Wildcards:
    # :khepri_path.wildcard()   — matches any single node
    # :khepri_path.star()       — matches any node at any depth
    """)

    # Demonstrate with binary keys
    :ok = :khepri.put(store, [:users, <<"user_1">>], %{name: "Alice", role: :admin})
    :ok = :khepri.put(store, [:users, <<"user_2">>], %{name: "Bob",   role: :user})
    :ok = :khepri.put(store, [:users, <<"user_3">>], %{name: "Carol", role: :user})

    {:ok, alice} = :khepri.get(store, [:users, <<"user_1">>])
    IO.puts("User 1: #{inspect(alice)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Queries and conditions
  # -----------------------------------------------------------------------
  defp queries_and_conditions do
    IO.puts("--- Queries & Conditions ---")
    store = Process.get(:store_id)

    # get_many/2 — get all descendants matching a path pattern
    # Use :khepri_path.wildcard() to match any child
    {:ok, users} = :khepri.get_many(store, [:users, :khepri_path.wildcard()])
    IO.puts("All users (#{map_size(users)}):")
    Enum.each(users, fn {path, data} ->
      IO.puts("  #{inspect(path)} → #{inspect(data)}")
    end)

    # count/2 — count matching nodes
    {:ok, count} = :khepri.count(store, [:users, :khepri_path.wildcard()])
    IO.puts("User count: #{count}")

    # list/2 — list child node names
    {:ok, child_names} = :khepri.list(store, [:config])
    IO.puts("Config children: #{inspect(Map.keys(child_names))}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Transactions
  # -----------------------------------------------------------------------
  defp transactions do
    IO.puts("--- Transactions ---")
    store = Process.get(:store_id)

    IO.puts("""
    # Transactions run inside a callback — NO IO, no side-effects allowed!
    # Use khepri_tx:* functions inside the callback.
    # The callback may run multiple times during recovery.
    """)

    # transaction/2 — atomic read-modify-write
    result = :khepri.transaction(store, fn ->
      # Inside here: ONLY khepri_tx functions, pattern matching, pure code
      current = case :khepri_tx.get([:config, :database, :port]) do
        {:ok, port} -> port
        _           -> 5432
      end

      :ok = :khepri_tx.put([:config, :database, :port], current + 1)
      :ok = :khepri_tx.put([:config, :database, :updated], true)

      {:ok, current + 1}
    end)

    case result do
      {:ok, new_port} -> IO.puts("Transaction OK, new port: #{new_port}")
      {:error, reason} -> IO.puts("Transaction failed: #{inspect(reason)}")
    end

    # Verify the write
    {:ok, port} = :khepri.get(store, [:config, :database, :port])
    IO.puts("Port after transaction: #{port}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Tree traversal
  # -----------------------------------------------------------------------
  defp tree_traversal do
    IO.puts("--- Tree Traversal ---")
    store = Process.get(:store_id)

    IO.puts("""
    # Khepri's real power: hierarchical config/metadata storage.
    # Typical use case: service discovery, feature flags, distributed config.
    """)

    # Build a richer tree
    :khepri.put(store, [:services, :api,      :host], "api.example.com")
    :khepri.put(store, [:services, :api,      :port], 443)
    :khepri.put(store, [:services, :api,      :healthy], true)
    :khepri.put(store, [:services, :database, :host], "db.example.com")
    :khepri.put(store, [:services, :database, :port], 5432)
    :khepri.put(store, [:services, :database, :healthy], true)
    :khepri.put(store, [:services, :cache,    :host], "redis.example.com")
    :khepri.put(store, [:services, :cache,    :port], 6379)
    :khepri.put(store, [:services, :cache,    :healthy], false)

    # Get all services and their config
    {:ok, all_services} = :khepri.get_many(store, [:services, :khepri_path.wildcard()])
    IO.puts("Service namespaces: #{all_services |> Map.keys() |> inspect()}")

    # Deep wildcard — get EVERYTHING under :services
    {:ok, all_deep} = :khepri.get_many(store, [:services | :khepri_path.star()])
    healthy = Enum.filter(all_deep, fn {_path, val} -> val == true end)
    IO.puts("Healthy flags set to true: #{length(healthy)}")

    IO.puts("""

    Production patterns:
      # Feature flags:
      :khepri.put(store, [:features, :dark_mode], true)
      {:ok, enabled?} = :khepri.get(store, [:features, :dark_mode])

      # Service registry (like a distributed ETS):
      :khepri.put(store, [:nodes, node(), :status], :up)
      :khepri.put(store, [:nodes, node(), :load],   cpu_load())

      # Watch for changes (like inotify for the tree):
      :khepri.register_trigger(store, [:features, :_], MyApp.FeatureWatcher)
    """)

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # Teardown
  # -----------------------------------------------------------------------
  defp teardown do
    store = Process.get(:store_id)
    :khepri.stop(store)
    IO.puts("Khepri stopped.")
  end
end
