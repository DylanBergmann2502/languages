defmodule LearnHorde do
  @moduledoc """
  Horde v0.10 — distributed supervisor and registry using CRDTs.

  Unlike a regular Supervisor/Registry which only lives on one node,
  Horde spreads processes across a cluster. When a node dies, Horde
  redistributes its processes to surviving nodes automatically.

  Two main modules:
    Horde.Registry        — distributed process registry (unique keys)
    Horde.DynamicSupervisor — distributed dynamic supervisor

  Both use CRDTs (conflict-free replicated data types) for eventual
  consistency across nodes — no single leader, no split-brain panics.

  Setup in mix.exs:
    {:horde, "~> 0.10.0"}
  """

  require Logger

  def run do
    IO.puts("\n=== Horde: Distributed Supervisor & Registry ===\n")

    registry_demo()
    dynamic_supervisor_demo()
    via_tuple_demo()
    cluster_membership()
  end

  # -----------------------------------------------------------------------
  # 1. Horde.Registry
  # -----------------------------------------------------------------------
  defp registry_demo do
    IO.puts("--- Horde.Registry ---")

    # Start a local Horde.Registry (in production this runs across nodes)
    {:ok, _} = Horde.Registry.start_link(
      name: LearnHorde.Registry,
      keys: :unique   # only :unique is supported (no :duplicate)
    )

    # Register current process under a key
    {:ok, _} = Horde.Registry.register(LearnHorde.Registry, "my_key", :some_value)

    # lookup/2 → [{pid, value}]
    result = Horde.Registry.lookup(LearnHorde.Registry, "my_key")
    IO.puts("Lookup result: #{inspect(result)}")

    # Via-tuple format for GenServer naming
    via = {:via, Horde.Registry, {LearnHorde.Registry, "my_key"}}
    IO.puts("Via-tuple: #{inspect(via)}")

    # keys/2 — get all keys registered by a pid
    keys = Horde.Registry.keys(LearnHorde.Registry, self())
    IO.puts("Keys for self(): #{inspect(keys)}")

    # select/2 — query with match spec (like ETS select)
    all = Horde.Registry.select(LearnHorde.Registry, [{{:"$1", :"$2", :"$3"}, [], [{{:"$1", :"$2", :"$3"}}]}])
    IO.puts("All entries: #{inspect(all)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Horde.DynamicSupervisor
  # -----------------------------------------------------------------------
  defp dynamic_supervisor_demo do
    IO.puts("--- Horde.DynamicSupervisor ---")

    {:ok, _} = Horde.DynamicSupervisor.start_link(
      name: LearnHorde.Supervisor,
      strategy: :one_for_one
      # In a real cluster: members: :auto
      # or members: [{LearnHorde.Supervisor, node1}, {LearnHorde.Supervisor, node2}]
    )

    # start_child/2 — distribute child across the cluster
    child_spec = %{
      id: :worker_1,
      start: {Agent, :start_link, [fn -> %{count: 0} end]},
      restart: :transient
    }

    {:ok, pid1} = Horde.DynamicSupervisor.start_child(LearnHorde.Supervisor, child_spec)
    IO.puts("Started child: #{inspect(pid1)}")

    # Start more children
    {:ok, pid2} = Horde.DynamicSupervisor.start_child(
      LearnHorde.Supervisor,
      %{id: :worker_2, start: {Agent, :start_link, [fn -> 42 end]}, restart: :transient}
    )

    # which_children/1
    children = Horde.DynamicSupervisor.which_children(LearnHorde.Supervisor)
    IO.puts("Children: #{length(children)}")

    # count_children/1
    counts = Horde.DynamicSupervisor.count_children(LearnHorde.Supervisor)
    IO.puts("Child counts: #{inspect(counts)}")

    # terminate_child/2
    :ok = Horde.DynamicSupervisor.terminate_child(LearnHorde.Supervisor, pid1)
    IO.puts("After terminating pid1, children: #{Horde.DynamicSupervisor.which_children(LearnHorde.Supervisor) |> length()}")

    _ = pid2
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Via-tuple with GenServer (the real power of Horde.Registry)
  # -----------------------------------------------------------------------
  defp via_tuple_demo do
    IO.puts("--- Via-Tuple: Named GenServers across cluster ---")

    # In production this registry spans multiple nodes via Horde.Cluster.set_members/2
    {:ok, _} = Horde.Registry.start_link(
      name: LearnHorde.NamedRegistry,
      keys: :unique
    )
    {:ok, _} = Horde.DynamicSupervisor.start_link(
      name: LearnHorde.NamedSupervisor,
      strategy: :one_for_one
    )

    # Start a GenServer with a globally unique name via Horde.Registry
    via_name = {:via, Horde.Registry, {LearnHorde.NamedRegistry, "session:user_42"}}

    {:ok, _pid} = Horde.DynamicSupervisor.start_child(
      LearnHorde.NamedSupervisor,
      %{
        id: :session_worker,
        start: {GenServer, :start_link, [HordeWorker, %{user_id: 42}, [name: via_name]]},
        restart: :transient
      }
    )

    # Call it from anywhere in the cluster using the via-tuple
    state = GenServer.call(via_name, :get_state)
    IO.puts("Session state via Horde.Registry: #{inspect(state)}")

    # The power: if the node running this GenServer dies,
    # Horde restarts it on another node — same via-tuple still works.
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Cluster membership
  # -----------------------------------------------------------------------
  defp cluster_membership do
    IO.puts("--- Cluster Membership ---")

    # In a multi-node setup you'd call:
    #   Horde.Cluster.set_members(LearnHorde.Registry, [
    #     {LearnHorde.Registry, :node1@host},
    #     {LearnHorde.Registry, :node2@host},
    #   ])
    # This makes the CRDT sync across nodes.

    # With members: :auto (requires libcluster or similar),
    # Horde discovers nodes automatically via Node.list().

    IO.puts("Current node: #{Node.self()}")
    IO.puts("Connected nodes: #{inspect(Node.list())}")
    IO.puts("""
    In production:
      1. Start Horde.Registry and Horde.DynamicSupervisor on every node
      2. Call Horde.Cluster.set_members/2 on each node when cluster changes
         (or use members: :auto with libcluster)
      3. Use {:via, Horde.Registry, {name, key}} everywhere
      4. Process migration happens automatically on node join/leave
    """)
  end
end

defmodule HordeWorker do
  use GenServer
  def init(state), do: {:ok, state}
  def handle_call(:get_state, _from, state), do: {:reply, state, state}
end
