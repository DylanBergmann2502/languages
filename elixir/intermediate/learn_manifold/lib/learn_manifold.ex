defmodule LearnManifold do
  @moduledoc """
  Manifold v1.6 — efficient message fan-out across a cluster.

  Created by Discord to solve a specific BEAM bottleneck:
  `send/2` costs ~70µs per call on their hardware. When a single
  GenServer broadcasts to 100,000 pids across 10 nodes, that's
  7 seconds of pure send overhead per broadcast cycle.

  Manifold's fix: group pids by node, then send once per node.
  The Partitioner on each node distributes to local pids.
  Result: N sends → M sends (where M = number of nodes).

  How it works internally:
    1. Group pids by remote node
    2. For local pids: hash to a worker partition (consistent hashing)
    3. For remote pids: send the group to the remote node's Partitioner
    4. Each remote Partitioner distributes to its local pids

  Setup in mix.exs:
    {:manifold, "~> 1.0"}

  Add Manifold to your supervision tree:
    children = [Manifold, ...]
  """

  def run do
    IO.puts("\n=== Manifold: Efficient Message Fan-Out ===\n")

    the_problem()
    basic_usage()
    pack_and_send_modes()
    configuration()
    real_world_pattern()
  end

  # -----------------------------------------------------------------------
  # 1. The problem Manifold solves
  # -----------------------------------------------------------------------
  defp the_problem do
    IO.puts("--- The Problem: send/2 Bottleneck ---")

    IO.puts("""
    # On a busy BEAM node, send/2 has overhead (~70µs at Discord's scale).
    # Broadcasting to N pids requires N send/2 calls from ONE process.
    #
    # Naive fan-out (what everyone writes first):
    def broadcast(pids, message) do
      Enum.each(pids, &send(&1, message))
      # 100,000 pids × 70µs = 7 seconds of CPU time, just for sends
      # Meanwhile the GenServer's message queue grows and falls behind
    end
    #
    # The real bottleneck is that send/2 acquires an internal lock on
    # the SENDER's process — it doesn't parallelize.
    #
    # Manifold's fix:
    #   1. Group pids by node (10 groups for 10 nodes)
    #   2. Send once to each remote node's Partitioner (10 sends total)
    #   3. Each Partitioner fans out locally using a worker pool
    #   4. Workers run in parallel — no lock contention on the sender
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Basic usage
  # -----------------------------------------------------------------------
  defp basic_usage do
    IO.puts("--- Basic Usage ---")

    # Start Manifold (normally in your supervision tree)
    {:ok, _} = Manifold.start_link([])

    # Single pid — same as send/2 but routed through Manifold
    Manifold.send(self(), :hello)
    receive do :hello -> IO.puts("Received single: :hello") end

    # Multiple pids — the real use case
    pids = for _ <- 1..5 do
      spawn(fn ->
        receive do
          {:work, n} -> IO.puts("  Worker received: #{n}")
        after
          1000 -> :timeout
        end
      end)
    end

    Manifold.send(pids, {:work, 42})

    # Give workers time to print
    Process.sleep(100)

    # Nil pids are silently filtered
    mixed = [self(), nil, self()]
    Manifold.send(mixed, :from_mixed_list)
    receive do :from_mixed_list -> IO.puts("Got from mixed list (nil filtered)") end
    receive do :from_mixed_list -> IO.puts("Got second from mixed list") end

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. pack_mode and send_mode options
  # -----------------------------------------------------------------------
  defp pack_and_send_modes do
    IO.puts("--- pack_mode and send_mode ---")

    IO.puts("""
    # pack_mode: controls External Term Format (ETF) encoding

    # Default (nil): standard BEAM encoding per node group
    Manifold.send(pids, message)

    # :binary — encode the term to binary ONCE, ship the binary everywhere.
    # Better when:
    #   - The message is large (avoids re-encoding per node)
    #   - You have many remote nodes (amortizes encoding cost)
    Manifold.send(pids, large_message, pack_mode: :binary)

    # send_mode: controls who does the sending

    # Default (nil): caller process sends directly (simple, synchronous)
    Manifold.send(pids, message)

    # :offload — delegate sending to Manifold.Sender worker pool.
    # Better when:
    #   - Messages are very large (don't block the caller during encoding)
    #   - You want to return from send immediately
    # Requires config :manifold, senders: N in config
    Manifold.send(pids, large_message, send_mode: :offload)

    # Combined for maximum throughput:
    Manifold.send(pids, large_message,
      pack_mode: :binary,
      send_mode: :offload
    )

    # CAUTION: Don't mix offload/non-offload for the same receiving nodes
    # within a single broadcast — message order may break.
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Configuration
  # -----------------------------------------------------------------------
  defp configuration do
    IO.puts("--- Configuration ---")

    IO.puts("""
    # config/config.exs

    # Number of Partitioner processes (default: 1, max: 32)
    # More partitioners = less contention in very high-throughput scenarios
    config :manifold, partitioners: 4

    # Workers per partitioner (default: System.schedulers_online)
    # Each worker handles a consistent subset of local pids
    config :manifold, workers_per_partitioner: 8

    # Sender pool size (default: System.schedulers_online, max: 128)
    # Only needed if using send_mode: :offload
    config :manifold, senders: 16

    # Add to supervision tree (required):
    defmodule MyApp.Application do
      def start(_type, _args) do
        children = [
          Manifold,   # ← must be supervised
          # ... rest of your tree
        ]
        Supervisor.start_link(children, strategy: :one_for_one)
      end
    end
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Real-world pattern (Discord-style server broadcast)
  # -----------------------------------------------------------------------
  defp real_world_pattern do
    IO.puts("--- Real-World Pattern: Server Broadcast ---")

    IO.puts("""
    # Discord's use case: a "guild" GenServer with 100k connected user pids
    # broadcasting events like "user joined", "message sent", etc.

    defmodule MyApp.GuildServer do
      use GenServer

      # State holds all connected session pids
      defstruct [:guild_id, members: %{}]   # %{user_id => pid}

      def broadcast(guild_id, event) do
        GenServer.cast({:via, Registry, {GuildRegistry, guild_id}}, {:broadcast, event})
      end

      def handle_cast({:broadcast, event}, %{members: members} = state) do
        pids = Map.values(members)

        # Naive: Enum.each(pids, &send(&1, event))
        # → 100k send calls, blocks this GenServer for seconds

        # Manifold: group by node, N sends total (N = cluster size)
        Manifold.send(pids, event)
        # → returns immediately, partitioners handle distribution

        {:noreply, state}
      end

      def handle_cast({:join, user_id, pid}, %{members: members} = state) do
        {:noreply, %{state | members: Map.put(members, user_id, pid)}}
      end

      def handle_cast({:leave, user_id}, %{members: members} = state) do
        {:noreply, %{state | members: Map.delete(members, user_id)}}
      end
    end

    # For very large payloads (e.g. initial state sync):
    def handle_cast({:sync, payload}, %{members: members} = state) do
      pids = Map.values(members)

      Manifold.send(pids, {:sync, payload},
        pack_mode: :binary,   # encode once for all nodes
        send_mode: :offload   # don't block this GenServer at all
      )

      {:noreply, state}
    end

    # Rule of thumb:
    #   < 100 recipients  → plain send/2 or Enum.each is fine
    #   > 1000 recipients → use Manifold
    #   cross-node        → Manifold shines most (N sends vs 1000s)
    """)

    # Live demo: measure time for direct vs Manifold send
    n = 1000
    pids = for _ <- 1..n do
      spawn(fn -> receive do _ -> :ok end end)
    end

    {direct_us, _} = :timer.tc(fn ->
      Enum.each(pids, &send(&1, :ping))
    end)

    {manifold_us, _} = :timer.tc(fn ->
      Manifold.send(pids, :ping)
    end)

    IO.puts("Direct send (#{n} pids):   #{direct_us}µs")
    IO.puts("Manifold send (#{n} pids): #{manifold_us}µs")
    IO.puts("(Manifold advantage grows with node count and message size)")
    IO.puts("")
  end
end
