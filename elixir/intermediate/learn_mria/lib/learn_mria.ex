defmodule LearnMria do
  @moduledoc """
  Mria v0.9 — Mnesia replication layer from EMQX.

  Mria adds a scalable replication topology on top of Mnesia:
    - Core nodes:      full Mnesia cluster, all participate in consensus
    - Replicant nodes: read-replica nodes, sync from cores, NO write quorum
                       (can have thousands — scales horizontally)

  Why Mria over raw Mnesia?
    - Mnesia's full-mesh replication doesn't scale past ~5 nodes.
    - Mria's core/replicant model lets you add read-replicas freely.
    - Used in production by EMQX (handles millions of MQTT connections).

  Mria is Erlang-based: use :mria atoms.

  Key API differences from raw Mnesia:
    - Use :mria.transaction/2 instead of :mnesia.transaction/1
    - Use :mria_rlog instead of :mnesia for replicant-aware operations
    - Tables are declared with :mria.create_table/2

  Setup in mix.exs:
    {:mria, "~> 0.9"}

  In application/0:
    extra_applications: [:mnesia, :mria]
  """

  def run do
    IO.puts("\n=== Mria: Scalable Mnesia Replication ===\n")

    topology_overview()
    setup_and_tables()
    mria_transactions()
    dirty_operations()
    ro_transactions()
    cluster_operations()
  end

  # -----------------------------------------------------------------------
  # 1. Topology overview
  # -----------------------------------------------------------------------
  defp topology_overview do
    IO.puts("--- Core/Replicant Topology ---")

    IO.puts("""
    Mria introduces two node roles:

    ┌────────────────────────────────────────────────────────────────┐
    │                   CORE CLUSTER (3-5 nodes)                     │
    │   Full Mnesia consensus — all participate in write quorum       │
    │   node1@host ←──► node2@host ←──► node3@host                  │
    └─────────────────────────┬──────────────────────────────────────┘
                              │  Async streaming replication
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
    ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
    │  REPLICANT      │  │  REPLICANT      │  │  REPLICANT      │
    │  (read replica) │  │  (read replica) │  │  (read replica) │
    │  node4@host     │  │  node5@host     │  │  node6@host     │
    └─────────────────┘  └─────────────────┘  └─────────────────┘

    Core nodes:      Full Mnesia, participate in writes, max ~5 nodes
    Replicant nodes: Subscribe to core's write-ahead log, read-only in Mnesia
                     Can scale to hundreds/thousands

    Node role is set in config:
      config :mria, node_role: :core       # or :replicant
      config :mria, core_nodes: [:"core1@host", :"core2@host"]
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Setup and table creation
  # -----------------------------------------------------------------------
  defp setup_and_tables do
    IO.puts("--- Setup & Table Creation ---")

    # Start Mnesia first (Mria wraps it)
    :mnesia.start()
    :mria.start()

    IO.puts("Mria started. Role: #{inspect(:mria_config.whoami())}")

    # Create tables via :mria.create_table/2
    # Same as :mnesia.create_table but Mria-aware
    result = :mria.create_table(:sessions, [
      attributes: [:token, :user_id, :created_at, :data],
      type: :set,
      # For replication-aware tables:
      # storage: :ram_copies (default for local) or :disc_copies
      rlog_shard: :session_shard  # group tables into shards for replication
    ])
    IO.puts("Create sessions table: #{inspect(result)}")

    result2 = :mria.create_table(:counters, [
      attributes: [:name, :value],
      type: :set
    ])
    IO.puts("Create counters table: #{inspect(result2)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Mria transactions
  # -----------------------------------------------------------------------
  defp mria_transactions do
    IO.puts("--- Mria Transactions ---")

    # :mria.transaction/2 — transactional write
    # On core nodes: runs a real Mnesia transaction
    # On replicant nodes: proxies to a core node
    # Shard allows Mria to route to the right core sub-cluster
    result = :mria.transaction(:session_shard, fn ->
      :mnesia.write({:sessions, "tok_abc", 1, DateTime.utc_now(), %{ip: "127.0.0.1"}})
      :mnesia.write({:sessions, "tok_xyz", 2, DateTime.utc_now(), %{ip: "10.0.0.1"}})
      length(:mnesia.match_object({:sessions, :_, :_, :_, :_}))
    end)

    case result do
      {:atomic, count} -> IO.puts("Transaction committed #{count} sessions")
      {:aborted, reason} -> IO.puts("Transaction aborted: #{inspect(reason)}")
    end

    # Read inside transaction (same as mnesia)
    {:atomic, session} = :mria.transaction(:session_shard, fn ->
      :mnesia.read(:sessions, "tok_abc")
    end)
    IO.puts("Session tok_abc: #{inspect(session)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Dirty operations (no transaction overhead)
  # -----------------------------------------------------------------------
  defp dirty_operations do
    IO.puts("--- Dirty Operations (fast reads) ---")

    # dirty_write / dirty_read — bypass transaction, fastest option
    :mnesia.dirty_write({:counters, :requests, 0})

    # Atomic counter increment (works without full transaction)
    :mnesia.dirty_update_counter(:counters, :requests, 1)
    :mnesia.dirty_update_counter(:counters, :requests, 1)
    :mnesia.dirty_update_counter(:counters, :requests, 1)

    [{:counters, :requests, count}] = :mnesia.dirty_read(:counters, :requests)
    IO.puts("Request counter (dirty): #{count}")

    # On replicant nodes: dirty_read reads LOCAL state (may be slightly behind)
    # This is fine for metrics and approximate counts
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Read-only transactions (RO — optimized for replicants)
  # -----------------------------------------------------------------------
  defp ro_transactions do
    IO.puts("--- RO Transactions (replicant-optimized) ---")

    IO.puts("""
    # On replicant nodes, use :mria.ro_transaction/2 for reads.
    # RO transactions run LOCALLY on the replicant — no round-trip to core.
    # They're eventually consistent (may see slightly stale data).

    # When to use:
    #   :mria.transaction/2         — writes or linearizable reads
    #   :mria.ro_transaction/2      — reads from replicants (cheaper)
    #   :mnesia.dirty_read/2        — cheapest, no consistency guarantee

    result = :mria.ro_transaction(:session_shard, fn ->
      all = :mnesia.match_object({:sessions, :_, :_, :_, :_})
      length(all)
    end)
    IO.puts("Session count (RO): \#{elem(result, 1)}")
    """)

    # Actual RO transaction
    result = :mria.ro_transaction(:session_shard, fn ->
      :mnesia.match_object({:sessions, :_, :_, :_, :_})
    end)
    IO.puts("RO transaction result: #{inspect(result)}")
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 6. Cluster operations
  # -----------------------------------------------------------------------
  defp cluster_operations do
    IO.puts("--- Cluster Operations ---")

    IO.puts("""
    # Join a Mria cluster:
    :mria.join(:"core1@host")   # current node joins core1's cluster

    # Leave the cluster:
    :mria.leave()

    # Get cluster topology:
    :mria.info()
    # Returns: %{core_nodes: [...], replicant_nodes: [...], ...}

    # Check replication status:
    :mria_rlog.status()
    # :up        — in sync with core
    # :down      — not connected to core
    # :bootstrap — initial sync in progress

    # Config (config.exs):
    config :mria,
      node_role: :core,                    # or :replicant
      core_nodes: [:"core1@host", :"core2@host", :"core3@host"],
      rlog_rpc_module: :mria_rpc           # or :gen_rpc for cross-DC

    # Shard definition (group related tables together):
    config :mria,
      rlog_config: %{
        session_shard: %{tables: [:sessions, :session_meta]},
        device_shard:  %{tables: [:devices, :device_state]}
      }
    """)

    IO.puts("Current role: #{inspect(:mria_config.whoami())}")
    :mria.stop()
    :mnesia.stop()
    IO.puts("Mria stopped.")
  end
end
