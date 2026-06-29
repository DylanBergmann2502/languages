defmodule LearnRa do
  @moduledoc """
  Ra v2.x — Raft consensus implementation for Erlang/Elixir.

  Ra is the Raft library that powers RabbitMQ quorum queues and Khepri.
  Raft is a consensus algorithm: it ensures a cluster of nodes agrees
  on a sequence of commands even when some nodes crash or partition.

  Key concepts:
    - Cluster: a set of Ra servers (members) that agree via Raft
    - Machine:  your state machine — defines how commands transform state
    - Leader:   the one server that accepts commands; others are followers
    - Log:      append-only journal replicated to all members

  Ra is an Erlang library: use :ra atoms.

  Machine callbacks (Erlang behaviour, but works fine from Elixir):
    init/1          → initial state
    apply/3         → handle a command: {State, Reply, Effects}
    state_enter/2   → called when a node transitions role (optional)

  Setup in mix.exs:
    {:ra, "~> 2.14"}

  In application/0:
    extra_applications: [:ra]
  """

  require Logger

  # Ra machine behaviour (the state machine that Ra replicates)
  @behaviour :ra_machine

  def run do
    IO.puts("\n=== Ra: Raft Consensus Library ===\n")

    machine_concept()
    single_node_cluster()
    commands_and_queries()
    effects_concept()
    cluster_operations()
  end

  # -----------------------------------------------------------------------
  # Ra machine callbacks (required by :ra_machine behaviour)
  # -----------------------------------------------------------------------

  @impl :ra_machine
  def init(_config) do
    # Return the initial state of your state machine.
    # This is replicated to all nodes in the cluster.
    %{counter: 0, entries: %{}}
  end

  @impl :ra_machine
  def apply(_meta, command, state) do
    # Handle a command. Must return {NewState, Reply, Effects}.
    # Effects are side-effects that Ra executes after committing to log
    # (e.g. sending messages, timers). They run only on the leader.
    case command do
      {:increment, amount} ->
        new_state = Map.update!(state, :counter, &(&1 + amount))
        {new_state, {:ok, new_state.counter}, []}

      {:put, key, value} ->
        new_state = put_in(state, [:entries, key], value)
        {new_state, {:ok, value}, []}

      {:delete, key} ->
        new_state = update_in(state, [:entries], &Map.delete(&1, key))
        {new_state, :ok, []}

      {:get, key} ->
        # Queries via apply/3 are linearizable (go through Raft log)
        # For cheaper reads, use ra:local_query or ra:leader_query
        reply = Map.get(state.entries, key)
        {state, reply, []}

      _ ->
        {state, {:error, :unknown_command}, []}
    end
  end

  # Optional: react to leadership changes
  @impl :ra_machine
  def state_enter(role, state) do
    # role: :leader | :follower | :candidate | :await_condition | :recover
    Logger.info("Ra node became: #{role}, counter=#{state.counter}")
    []  # must return list of effects
  end

  # -----------------------------------------------------------------------
  # 1. Machine concept
  # -----------------------------------------------------------------------
  defp machine_concept do
    IO.puts("--- Ra Machine Concept ---")

    IO.puts("""
    # Ra replicates a state machine across a cluster using Raft.
    # You define THREE callbacks:

    @behaviour :ra_machine

    # 1. init/1 — return initial state
    def init(_config), do: %{counter: 0}

    # 2. apply/3 — handle a command
    #    Returns {NewState, Reply, Effects}
    def apply(_meta, {:increment, n}, state) do
      new_state = Map.update!(state, :counter, &(&1 + n))
      {new_state, {:ok, new_state.counter}, []}
    end

    # 3. state_enter/2 (optional) — react to role changes
    def state_enter(:leader, state), do: Logger.info("I am leader")
    def state_enter(_role, _state),  do: []

    # Effects (3rd element in apply return):
    #   {:send_msg, Pid, Msg}            — send message after commit
    #   {:timer, Name, TimeMs, Command}  — set a timer
    #   {:mod_call, Mod, Fun, Args}      — call MFA after commit
    #   {:monitor, :process, Pid}        — monitor a process
    #   {:demonitor, :process, Pid}
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 2. Starting a single-node cluster
  # -----------------------------------------------------------------------
  defp single_node_cluster do
    IO.puts("--- Single-Node Ra Cluster ---")

    # Ra needs its data directory set up
    data_dir = Path.join(System.tmp_dir!(), "ra_learn_#{:erlang.unique_integer([:positive])}")
    File.mkdir_p!(data_dir)
    Application.put_env(:ra, :data_dir, String.to_charlist(data_dir))

    # Start Ra if not already started
    :ra.start()

    cluster_name = :learn_ra_cluster
    server_id    = {cluster_name, node()}

    # Machine spec: {Module, InitConfig}
    machine = {:module, __MODULE__, %{}}

    # ra:start_cluster/3 — start a cluster with given member set
    case :ra.start_cluster(:default, cluster_name, machine, [server_id]) do
      {:ok, started, _failed} ->
        IO.puts("Cluster started, members: #{inspect(started)}")
        # Store server_id for subsequent demos
        Process.put(:ra_server_id, server_id)
      {:error, _reason} ->
        IO.puts("Cluster already running")
        Process.put(:ra_server_id, server_id)
    end
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 3. Commands and queries
  # -----------------------------------------------------------------------
  defp commands_and_queries do
    IO.puts("--- Commands & Queries ---")

    server_id = Process.get(:ra_server_id)

    # process_command/2 — linearizable write (goes through Raft log)
    # Returns {:ok, Reply, LeaderID} or {:error, Reason}
    {:ok, counter_val, _leader} = :ra.process_command(server_id, {:increment, 5})
    IO.puts("Counter after +5: #{counter_val}")

    {:ok, counter_val2, _leader} = :ra.process_command(server_id, {:increment, 3})
    IO.puts("Counter after +3: #{counter_val2}")

    # Write a key-value entry
    {:ok, _val, _leader} = :ra.process_command(server_id, {:put, :greeting, "hello"})
    {:ok, _val, _leader} = :ra.process_command(server_id, {:put, :count, 42})

    # local_query/2 — cheap read from local node (may be slightly stale)
    # QueryFun receives current state, must be a pure function
    {:ok, {_idx, state}, _leader} = :ra.local_query(server_id, fn s -> s end)
    IO.puts("State via local_query: #{inspect(state)}")

    # leader_query/2 — read from leader only (linearizable reads)
    {:ok, {_idx, greeting}, _leader} = :ra.leader_query(server_id,
      fn s -> Map.get(s.entries, :greeting) end)
    IO.puts("Greeting via leader_query: #{inspect(greeting)}")

    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 4. Effects
  # -----------------------------------------------------------------------
  defp effects_concept do
    IO.puts("--- Effects: Safe Side-Effects ---")

    IO.puts("""
    # Effects allow the machine to trigger side-effects AFTER a command
    # is safely committed to the log. They only execute on the leader.

    # Send a message to a process:
    def apply(_meta, {:complete_job, job_id}, state) do
      new_state = remove_job(state, job_id)
      effects = [{:send_msg, state.completion_listener, {:job_done, job_id}}]
      {new_state, :ok, effects}
    end

    # Call an MFA (module-function-args):
    def apply(_meta, :sync_to_postgres, state) do
      effects = [{:mod_call, MyApp.Sync, :push, [state]}]
      {state, :ok, effects}
    end

    # Register/start a timer that fires a command:
    def apply(_meta, :start_timer, state) do
      effects = [{:timer, :my_timer, 5000, :timer_fired}]
      {state, :ok, effects}
    end

    # Why effects instead of direct IO.puts/send?
    # In Raft, a command may be applied multiple times during recovery.
    # Effects are only fired once (after durable commit) — safe for
    # external side-effects.
    """)
    IO.puts("")
  end

  # -----------------------------------------------------------------------
  # 5. Cluster operations
  # -----------------------------------------------------------------------
  defp cluster_operations do
    IO.puts("--- Cluster Operations ---")

    server_id = Process.get(:ra_server_id)

    # members/1 — list current cluster members
    {:ok, members, _leader} = :ra.members(server_id)
    IO.puts("Cluster members: #{inspect(members)}")

    # member_overview/1 — detailed state of each member
    overview = :ra.member_overview(server_id)
    IO.puts("Member overview keys: #{overview |> Map.keys() |> inspect()}")

    IO.puts("""

    In a real multi-node cluster:

    # Add a member:
    :ra.add_member(ServerID, {ClusterName, NewNode})

    # Remove a member:
    :ra.remove_member(ServerID, {ClusterName, OldNode})

    # Transfer leadership:
    :ra.transfer_leadership(ServerID, {ClusterName, TargetNode})

    # Stop the cluster:
    :ra.delete_cluster([ServerID, ...])

    # Check who is leader:
    :ra.leader_id(ServerID)

    Multi-node setup (each node must start Ra and call start_cluster):
      Node 1: :ra.start_cluster(:default, :my_cluster, machine, [
                {my_cluster, :"node1@host"}, {my_cluster, :"node2@host"},
                {my_cluster, :"node3@host"}
              ])
      Node 2,3: :ra.start_server(:default, %{
                  cluster_name: :my_cluster,
                  id: {my_cluster, node()},
                  machine: machine,
                  initial_members: [...]
                })
    """)

    # Cleanup: stop the cluster
    :ra.stop_server(:default, server_id)
    IO.puts("Cluster stopped.")
  end
end
